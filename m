Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443AbaIAK0p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 06:26:45 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:62605 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154AbaIAK0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 06:26:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "long.wanglong" <long.wanglong@huawei.com>
Cc: linux@arm.linux.org.uk, santosh.shilimkar@ti.com,
        victor.kamensky@linaro.org, nico@linaro.org, ben.dooks@codethink.co.uk,
        cov@codeaurora.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [SMP BUG?] the return value of is_smp() is bug?
Date: Mon, 01 Sep 2014 12:26 +0200
Message-ID: <25226905.0IHWyHSRxb@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <540443DA.7030502@huawei.com>
References: <1409550563-92081-1-git-send-email-long.wanglong@huawei.com> <540443DA.7030502@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:H/CKrFIBZMs/OMGmZbJdVj9+KwDT+mtTX+0IDlsE697
 nB4pWPWCB/tO6ndrOdSOQDbpEcxK4un9fxa2lGff847BMTcSNy
 nJQsLYoK4uswoIhkTetQVj/Vjl3nN6ALViw+j6dkGNo8Kdmato
 R7R+OyHOmQOqWaA34kHXCwWxgt1Vz6D9RUvYEPQqEwyGQqfP9r
 ZGzcf4SrBZdFj9zUbI3Fcfix9iYPjyy8k8ys7KtgEWhcgJXd36
 JvfQDLWXHe8j/CNBXVjzi9chQ0apcEO9prdb/xBqyjvg7sb44L
 LCdFCq3kXtXLREn/N/3CDroFSCZ82nipMQ5WMA2UcH8IxWLi2K
 H3VuZ1dfqWIOoSQvaG/0=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 September 2014 18:00:58 long.wanglong wrote:
> On 2014/9/1 13:49, Wang Long wrote:
> > 
> > Hi,all
> > 
> > In kernel 3.17-rc2, when i set CONFIG_HAVE_SMP = y and CONFIG_SMP_ON_UP = y 
> > in .config file. the secondary core can not boot.
> > 
> > when i set CONFIG_HAVE_SMP = y and CONFIG_SMP_ON_UP = n in .config file,
> > the secondary core can boot.
> > 
> > But this does not happen in kernel 3.10 lts kernel, Whether the 
> > CONFIG_SMP_ON_UP is set yes or no ,the secondary core can boot.
> > 
> > Does the meaning of CONFIG_SMP_ON_UP changed or this is a bug in kernel 3.17-rc2 ? 
> > 
> > 
> 
> hi Arnd
> 
> In above two cases, i also set  CONFIG_SMP = y. in addtion,
> the CONFIG_SMP_ON_UP depends on CONFIG_SMP. when set
> CONFIG_SMP_ON_UP = y, the value of CONFIG_SMP must be y.

I see.

I'm looking at the code more closely now:

> > config:     set CONFIG_HAVE_SMP = y and CONFIG_SMP_ON_UP = y
> > command:    # qemu-system-arm -M vexpress-a9 -smp 2  -m 128M -kernel arch/arm/boot/zImage -nographic
> > The output:
> > 
> > ..........
> > is_smp() return false;

This test basically checks whether the __fixup_smp_on_up code was
run or not. This has changed in bc41b8724f24 "ARM: 7846/1: Update
SMP_ON_UP code to detect A9MPCore with 1 CPU devices", in order
to support a quirk in the Aegis platform. Can you try reverting
that commit?

	Arnd

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964818Ab3BNMPF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 07:15:05 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:38100 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934253Ab3BNMPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 07:15:03 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>, Dave Jones <davej@redhat.com>,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Subject: Re: [PATCH 0/5] Add P state driver for Intel Core Processors
Date: Thu, 14 Feb 2013 13:21:31 +0100
Message-ID: <1540905.Sh9giL2bZe@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc7; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAOh2x=nwHbbngQm1PE7SfOLbHs3oMMb74zHXD9721OJzWo1+Tg@mail.gmail.com>
References: <1360170133-5066-1-git-send-email-dirk.brandewie@gmail.com> <511BC16C.7040807@gmail.com> <CAOh2x=nwHbbngQm1PE7SfOLbHs3oMMb74zHXD9721OJzWo1+Tg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, February 14, 2013 09:38:21 AM Viresh Kumar wrote:
> On Wed, Feb 13, 2013 at 10:08 PM, Dirk Brandewie
> <dirk.brandewie@gmail.com> wrote:
> > For the case where both are built-in the load order works my driver uses
> > device_initcall() and acpi_cpufreq uses late_initcall().
> >
> > For the case where both are a module (which I was sure I tested) you are
> > right
> > I will have to do something.
> >
> > For now I propose to make my driver built-in only while I sort out the right
> > solution for the module build.  Does this seem reasonable to everyone?
> 
> Of-course i am missing something here. Why would anybody want to insert
> acpi-cpufreq module when the system supports the pstate driver.
> 
> In case they are mutually exclusive, then we can have something like
> depends on !ACPI-DRIVER in the kconfig option of pstate driver.

Yes.  Or the other way around (i.e. make acpi_cpufreq depend on
!X86_INTEL_PSTATE).

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

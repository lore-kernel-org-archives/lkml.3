Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab3I1NsP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 09:48:15 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:44485 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754036Ab3I1NsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 09:48:13 -0400
MIME-Version: 1.0
In-Reply-To: <20130925184435.GH2954@lukather>
References: <1379852488-32147-1-git-send-email-cinifr@gmail.com>
	<1379852488-32147-2-git-send-email-cinifr@gmail.com>
	<20130923181707.GR2779@lukather>
	<CAK3cCBwLrnV7L9WzJ+1P_62PEjEEtgzVjFH8m6SZzWG1O+2vEw@mail.gmail.com>
	<20130925184435.GH2954@lukather>
Date: Sat, 28 Sep 2013 21:48:11 +0800
Message-ID: <CAK3cCBwOpkk5ObeEm+by=RS6jSptPdGZM+fvpgGZpX9TPij5gg@mail.gmail.com>
Subject: Re: [PATCH V3: Add Smp support for Allwinner A20. 1/3] Add smp
 support for Allwinner A20(sunxi 7i).
From: cinifr <cinifr@gmail.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: coosty@163.com, Daniel Lezcano <daniel.lezcano@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "pawel.moll@arm.co" <pawel.moll@arm.co>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-sunxi@googlegroups.com" <linux-sunxi@googlegroups.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi  Maxime,
    I have test it, but I found it does not work. If using
smp_prepare_cpus, the kernenl cannot find the secondary cpus because
that smp_prepare_cpus semms not be excuted before kernel is booting
secondary cpus. So I have to use early_initcall.

Fan.

On 26 September 2013 02:44, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:
> Hi Fan,
>
> On Wed, Sep 25, 2013 at 12:22:44AM +0800, cinifr wrote:
>> > You still haven't said why you don't want to use smp_init_cpus there.
>> I find that of_funcation liking of_find_matching_node and of_iomap can
>> not run well in smp_init_cpus. It cause kernel crash. So I have to use
>> early_initcall.
>
> Ah, right.
>
> Then, can't we use smp_prepare_cpus for this? it looks to be late enough
> so that we can use ioremap there.
>
> I don't want it to be an initcall. The code will be different on the
> A31, and we don't want it to be run on all the other machines whenever
> we boot a multiplatform kernel anyway.
>
> Maxime
>
> --
> Maxime Ripard, Free Electrons
> Embedded Linux, Kernel and Android engineering
> http://free-electrons.com

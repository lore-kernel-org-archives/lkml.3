Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095AbaAIL5h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 06:57:37 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:55627 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751300AbaAIL5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 06:57:25 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Olof Johansson <olof@lixom.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3 Resend] cpufreq: create cpufreq_generic_get() routine
Date: Thu, 09 Jan 2014 13:11:15 +0100
Message-ID: <1645387.93uAkEaqro@vostro.rjw.lan>
User-Agent: KMail/4.11.3 (Linux/3.13.0-rc6+; KDE/4.11.3; x86_64; ; )
In-Reply-To: <CAKohpo=EsaBPdF3wYsa2rEdjcpPagbhPcxWw1_PA=yVLDnjRiA@mail.gmail.com>
References: <d9239e0a5df99392647ff8343673342f89d09476.1389059568.git.viresh.kumar@linaro.org> <CAOesGMgfFVoVJpOMXWtzVWj_F4pD-L9Osyv4u6=c8RUWOoLHFw@mail.gmail.com> <CAKohpo=EsaBPdF3wYsa2rEdjcpPagbhPcxWw1_PA=yVLDnjRiA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 09, 2014 02:56:28 PM Viresh Kumar wrote:
> cc'ng Russell/LAKML/Fengguang..
> 
> On 9 January 2014 14:08, Olof Johansson <olof@lixom.net> wrote:
> > This patch breaks a bunch of ARM boards. In particular, the following
> > defconfigs no longer build:
> 
> That's really bad, Rafael will scold me again :)
> 
> >           assabet_defconfig
> >           badge4_defconfig
> >           cerfcube_defconfig
> >           collie_defconfig
> >           h3600_defconfig
> >           hackkit_defconfig
> >           jornada720_defconfig
> >           lart_defconfig
> >           neponset_defconfig
> >           pleb_defconfig
> >           shannon_defconfig
> >           simpad_defconfig
> >
> > Error is:
> >
> > drivers/built-in.o: In function `cpufreq_generic_get':
> > drivers/cpufreq/cpufreq.c:189: undefined reference to `clk_get_rate'
> >
> > Seems like this needs to be guarded by HAVE_CLK?
> 
> Naah.. After some investigation I found this:
> 
> - We already have dummy implementations of clk routines in case
> CONFIG_HAVE_CLK is not defined (I added them long back).
> 
> - There is one thing common among all above defconfigs, all
> belong to SA1100 family :)
> 
> - And the problem is: SA1100 wanted to define its own clk routines
> and selects CLKDEV_LOOKUP (which enables HAVE_CLK), but it
> doesn't implement all clk routines. Which is *wrong*.
> 
> So, actually this patch brought an _existing_ bug in limelight. And
> this should be fixed by adding dummy or meaningful implementation
> of missing clk routines.
> 
> @Russell: If above looks correct then can you please communicate
> what should we do here? I don't really know what exactly these
> routines should have, simply a copy of dummy routines from clk.h
> or some meaningful stuff. So, maybe you can write a patch, otherwise
> let me know what to write and I will give it a try.
> 
> @Rafael: Please *don't* revert this patch, its not my fault this time :)

Well, if build is broken, it *always* is the fault of the commit that
introduced the breakage, even if that is a result of someone else doing
things incorrectly.  Why?  Because it potentially breaks bisection for
people and *that* is a big deal.

So yes, I'm going to revert it.  Please resubmit after you've addressed the
build breakage.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

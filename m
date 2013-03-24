Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210Ab3CXOqe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 10:46:34 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:38693 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753940Ab3CXOqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 10:46:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [REGRESSION] [CPUFREQ] 3.9.0-rcX
Date: Sun, 24 Mar 2013 15:53:54 +0100
Message-ID: <1965505.vyQ4xZcodg@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAKohpokBySA5uaTTAwF5tmUr-_+W04Ki_f6cWTLu7n1C3Tcqog@mail.gmail.com>
References: <CAG9S4UjMeRZECAiigZVLTU4av2ZJNBukyUAoCmiYRjtkdThhFw@mail.gmail.com> <CAKohpokBySA5uaTTAwF5tmUr-_+W04Ki_f6cWTLu7n1C3Tcqog@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, March 24, 2013 07:59:35 PM Viresh Kumar wrote:
> On 24 March 2013 19:41, Maciej Rutecki <maciej.rutecki@gmail.com> wrote:
> > (long e-mail, sorry ;-))
> 
> Don't be, it was useful :)
> 
> > Last known good: 3.8.0
> >
> > Short description:
> > 1. On -rc3, after s2ram cpufreq does not set CPU on max frequency on high
> > load (on battery).
> 
> Try attached patch for this.
> 
> > 2. On -rc4 (this is not real regression because I change config between -rc3
> > and rc4), "ondemand" does not work. Current frequency is 'strange' (792
> > MHz).
> 
> I don't really have a reason for that :(
> But with your config it is clear that, your working setup has:
> 
> # CONFIG_X86_INTEL_PSTATE is not set
> # CONFIG_X86_PCC_CPUFREQ is not set
> CONFIG_X86_ACPI_CPUFREQ=m
> 
> and rc4 version has:
> 
> CONFIG_X86_INTEL_PSTATE=y
> CONFIG_X86_PCC_CPUFREQ=m
> CONFIG_X86_ACPI_CPUFREQ=m
> 
> So, i believe you are using another cpufreq driver this, try with same
> configuration once.
> 
> > 1. Kernel 3.8.0:
> >
> > Output (show only fisrt CPU, others are same):
> > cpu0/cpufreq//affected_cpus:0
> > cpu0/cpufreq//related_cpus:0 1 2 3
> 
> > Kernel 3.9.0-rc1
> 
> > CASE 2
> > After boot:
> > cpu0/cpufreq//affected_cpus:0 1 2 3
> > cpu0/cpufreq//related_cpus:0 1 2 3
> 
> My attached patch will restore 1. instead of CASE 2.
> 
> > ===============================================================================
> > Kernel 3.9.0-rc4
> >
> > CASE 7
> > (normal boot)
> > cpu0/cpufreq//affected_cpus:0
> > cpu0/cpufreq//related_cpus:0
> 
> This must be related to your different driver.

Yes, intel_pstate is not really a cpufreq driver.  It just overtakes the
whole subsystem.

Dirk, can you please check if this is as intended?

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049Ab3KQOqF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 09:46:05 -0500
Received: from nebula.mojo.cc ([46.4.89.19]:33009 "EHLO nebula.mojo.cc"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753482Ab3KQOp4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 09:45:56 -0500
From: "MPhil. Emanoil Kotsev" <Emanoil.Kotsev@fincom.at>
Organization: FinCom Consulting
To: Borislav Petkov <bp@alien8.de>
Subject: Re: [Intel-gfx] kernel 3.11.6 general protection fault
Date: Sun, 17 Nov 2013 15:45:34 +0100
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel@ffwll.ch>
References: <201311132058.30310.Emanoil.Kotsev@fincom.at> <201311171235.17602.Emanoil.Kotsev@fincom.at> <20131117120734.GE27323@pd.tnic>
In-Reply-To: <20131117120734.GE27323@pd.tnic>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201311171545.35217.Emanoil.Kotsev@fincom.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sunday 17 November 2013 13:07:34 Borislav Petkov wrote:
> On Sun, Nov 17, 2013 at 12:35:16PM +0100, MPhil. Emanoil Kotsev wrote:
> > After doing all of this I was able to reproduce the issue by
> > overloading the system with following simple steps:
> > 1. start a compilation of something (ex. kernel)
> > 2. run another process hungry application (flashplayer in firefox)
> > => system locks in about 3-5mins
>
> Ha, so we're getting somewhere :)

yes looks like :)

>
> > I also noticed that the board gets pretty hot, so in my opinion it
> > locks because of thermal issue.
>
> The symptoms we're seeing so far are very much consistent with a thermal
> issue.

this is also true - which makes me sad as the notebook was working great in 
the past 7y

>
> > I think this also would explain why I see errors at different
> > processes (mostly Xorg), but with 3.12 I do not get any trace message
> > in the log files. Could you advise which option should be enabled in
> > the kernel or how I could log/trace if system locks.
>
> Try enabling CONFIG_LOCKUP_DETECTOR, that could tell us where we're
> hanging.
>
> But, make sure to be on a console and not in X in order to get a chance
> to see the message. What I do is reroute all log messages to /dev/tty8,
> i.e. have
>
> *.*		|/dev/tty8
>
> in syslog.conf and switch to it with Ctrl-Alt-F8.

thanks for the advise. I'll do so

>
> > How can I make sure that the cooling/temp works properly?
> >
> > Perhaps after upgrading in september the system is working under
>
> What kind of upgrade exactly did you do to a laptop?

I was using debian squeeze with trinity desktop (KDE 3.5.10) and upgraded to 
debian wheeze with TDE (3.5.13)

>
> > heavier load and therefore I started having the issue, or something
> > broke in software or hardware and it can not cool down properly. I
> > don't think the kernel is the issue, because I had the same with older
> > kernels that were working fine before.
> >
> > The fan looks clean and there is no dust or whatever in the cooling
> > area, that would prevent colling. The physical position of the
> > notebook (docking station) also did not change.
>
> Does the issue happen if the laptop is not in the docking station?

I wanted to test this, but as I have to replug a lot, didn't do it so far, 
also because it was working with this docking station for the past 2y

>
> In any case, you need to follow your steps back of the upgrade to have
> at least a clue what causes the overheating.
>
> Can you revert the upgrade and see whether it still happens?
This would be hard - no impossible as I have a backup but it will be time 
consuming
>
> Also, do you have sensors support for your hardware? IOW, can you
> monitor the temperature of some hardware elements by running
>
> $ sensors

$ sensors
acpitz-virtual-0
Adapter: Virtual device
temp1:        +47.5°C  (crit = +126.0°C)


>
> ?
>
> For example, I see this on my box here:
>
> $ sensors
> fam15h_power-pci-00c4
> Adapter: PCI adapter
> power1:       45.64 W  (crit = 125.19 W)
>
> k10temp-pci-00c3
> Adapter: PCI adapter
> temp1:        +19.2°C  (high = +70.0°C)
>                        (crit = +90.0°C, hyst = +87.0°C)
>
> radeon-pci-0100
> Adapter: PCI adapter
> temp1:        +80.0°C
>
> so when something overheats, running "watch -n 1 sensors" could give
> some hints.
>
> Also, what does
>
> $ grep . -EriIn /sys/devices/system/cpu/cpu0/cpufreq
>
> give?

grep . -EriIn /sys/devices/system/cpu/cpu0/cpufreq
/sys/devices/system/cpu/cpu0/cpufreq/bios_limit:1:2000000
/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor:1:ondemand
/sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_transition_latency:1:10000
/sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies:1:2000000 
1667000 1333000 1000000
/sys/devices/system/cpu/cpu0/cpufreq/freqdomain_cpus:1:0 1
/sys/devices/system/cpu/cpu0/cpufreq/scaling_driver:1:acpi-cpufreq
/sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_cur_freq:1:1000000
/sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors:1:ondemand 
powersave performance conservative userspace
/sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq:1:1000000
/sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq:1:2000000
/sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_min_freq:1:1000000
/sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq:1:2000000
/sys/devices/system/cpu/cpu0/cpufreq/affected_cpus:1:0
/sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq:1:1000000
/sys/devices/system/cpu/cpu0/cpufreq/related_cpus:1:0
/sys/devices/system/cpu/cpu0/cpufreq/scaling_setspeed:1:<unsupported>


>
> Also, can you connect your laptop to a serial or netconsole to collect
> dmesg before and while the lockup happens?

I could try this. I guess this assumes I have to have another machine running 
in paralell, but this can be arranged with a little effort

>
> Basically, we're looking for a hint about which part of the hw causes
> the overheating...
>
> HTH.

Thanks for the hints. As I never had to do with overheating or similar issues, 
your help is very precious to me. Unfortunately we have a little child on 
board and time is limitted :) to a couple of hours daily, where I can work at 
home which means even less time for debugging. But I never give up. I just 
want to be sure that it is not a hardware issue

Thanks again and kind regards. I'll post when I have some useful input


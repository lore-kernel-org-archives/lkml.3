Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368Ab3KQQps (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 11:45:48 -0500
Received: from nebula.mojo.cc ([46.4.89.19]:33146 "EHLO nebula.mojo.cc"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751234Ab3KQQpk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 11:45:40 -0500
From: "MPhil. Emanoil Kotsev" <Emanoil.Kotsev@fincom.at>
Organization: FinCom Consulting
To: Borislav Petkov <bp@alien8.de>
Subject: Re: [Intel-gfx] kernel 3.11.6 general protection fault
Date: Sun, 17 Nov 2013 17:45:18 +0100
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel@ffwll.ch>
References: <201311132058.30310.Emanoil.Kotsev@fincom.at> <201311171545.35217.Emanoil.Kotsev@fincom.at> <20131117150607.GF27323@pd.tnic>
In-Reply-To: <20131117150607.GF27323@pd.tnic>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201311171745.19339.Emanoil.Kotsev@fincom.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi

On Sunday 17 November 2013 16:06:07 you wrote:
> On Sun, Nov 17, 2013 at 03:45:34PM +0100, MPhil. Emanoil Kotsev wrote:
> > this is also true - which makes me sad as the notebook was working
> > thgreat in e past 7y
>
> Hmm, maybe it is heading slowly for the eternal hunting fields... :-)
may be, but I am a bit of academic so until 100% prove - I doubt, which does 
not mean that I can not purchaise a new one :)
>
> > > What kind of upgrade exactly did you do to a laptop?
> >
> > I was using debian squeeze with trinity desktop (KDE 3.5.10) and upgraded
> > to debian wheeze with TDE (3.5.13)
>
> Oh ok, so I thought you were talking about a hw upgrade, like adding
> more RAM, hew hdd, etc.
>
> Ok, can you try this: boot without X and try overloading the machine on
> the console, i.e. do
>
> while true; do make clean && make -j64; done
>
> or similar in your kernel repository. Does it trigger then?
I'll try - I'm also curious what will happen!
>
> Although I can't imagine how a software upgrade would cause the
> overheating... :-\.
How - new libraries - more exhaustive algorythms - higher cpu usage etc. Some 
of the things M$ is doing on purpose to force you upgrade your hardware every 
2-3years

>
> > > Can you revert the upgrade and see whether it still happens?
> >
> > This would be hard - no impossible as I have a backup but it will be
> > time consuming
>
> You could try booting a distro from a livecd and see any change there...
>
> > $ sensors
> > acpitz-virtual-0
> > Adapter: Virtual device
> > temp1:        +47.5°C  (crit = +126.0°C)
>
> That's some ACPI timezone thing. So what happens if you do
>
> $ watch -n 1 sensors
>
> and you incur the load? Do you hit the critical temperature?

I wanted to first compile the kernel with the debug option you mentioned, but 
while compiling it went to about 75°C.

>
> > grep . -EriIn /sys/devices/system/cpu/cpu0/cpufreq
> > /sys/devices/system/cpu/cpu0/cpufreq/bios_limit:1:2000000
> > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor:1:ondemand
> > /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_transition_latency:1:10000
> > /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies:1:2000
> >000 1667000 1333000 1000000
> > /sys/devices/system/cpu/cpu0/cpufreq/freqdomain_cpus:1:0 1
> > /sys/devices/system/cpu/cpu0/cpufreq/scaling_driver:1:acpi-cpufreq
> > /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_cur_freq:1:1000000
> > /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors:1:ondema
> >nd powersave performance conservative userspace
> > /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq:1:1000000
> > /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq:1:2000000
> > /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_min_freq:1:1000000
> > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq:1:2000000
> > /sys/devices/system/cpu/cpu0/cpufreq/affected_cpus:1:0
> > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq:1:1000000
> > /sys/devices/system/cpu/cpu0/cpufreq/related_cpus:1:0
> > /sys/devices/system/cpu/cpu0/cpufreq/scaling_setspeed:1:<unsupported>
>
> Yeah, I don't see anything wrong with that output.
yes looks nice
>
> > I could try this. I guess this assumes I have to have another machine
> > running in paralell, but this can be arranged with a little effort
>
> Yep.
>
> > Thanks for the hints. As I never had to do with overheating or
> > similar issues, your help is very precious to me. Unfortunately we
> > have a little child on board and time is limitted :) to a couple of
> > hours daily, where I can work at home which means even less time for
> > debugging. But I never give up. I just want to be sure that it is not
> > a hardware issue
>
> No worries, take care of the child first - the laptop and everyone else
> can wait :-)

yes - we do load balancing with my wife :)

I'll post back with some data (I hope)

regards

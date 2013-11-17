Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab3KQPGq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 10:06:46 -0500
Received: from mail.skyhub.de ([78.46.96.112]:55881 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752410Ab3KQPGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 10:06:39 -0500
Date: Sun, 17 Nov 2013 16:06:07 +0100
From: Borislav Petkov <bp@alien8.de>
To: "MPhil. Emanoil Kotsev" <Emanoil.Kotsev@fincom.at>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [Intel-gfx] kernel 3.11.6 general protection fault
Message-ID: <20131117150607.GF27323@pd.tnic>
References: <201311132058.30310.Emanoil.Kotsev@fincom.at>
 <201311171235.17602.Emanoil.Kotsev@fincom.at>
 <20131117120734.GE27323@pd.tnic>
 <201311171545.35217.Emanoil.Kotsev@fincom.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201311171545.35217.Emanoil.Kotsev@fincom.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 17, 2013 at 03:45:34PM +0100, MPhil. Emanoil Kotsev wrote:
> this is also true - which makes me sad as the notebook was working
> thgreat in e past 7y

Hmm, maybe it is heading slowly for the eternal hunting fields... :-)

> > What kind of upgrade exactly did you do to a laptop?
> 
> I was using debian squeeze with trinity desktop (KDE 3.5.10) and upgraded to 
> debian wheeze with TDE (3.5.13)

Oh ok, so I thought you were talking about a hw upgrade, like adding
more RAM, hew hdd, etc.

Ok, can you try this: boot without X and try overloading the machine on
the console, i.e. do

while true; do make clean && make -j64; done

or similar in your kernel repository. Does it trigger then?

Although I can't imagine how a software upgrade would cause the
overheating... :-\.

> > Can you revert the upgrade and see whether it still happens?
> This would be hard - no impossible as I have a backup but it will be
> time consuming

You could try booting a distro from a livecd and see any change there...

> $ sensors
> acpitz-virtual-0
> Adapter: Virtual device
> temp1:        +47.5°C  (crit = +126.0°C)

That's some ACPI timezone thing. So what happens if you do

$ watch -n 1 sensors

and you incur the load? Do you hit the critical temperature?

> grep . -EriIn /sys/devices/system/cpu/cpu0/cpufreq
> /sys/devices/system/cpu/cpu0/cpufreq/bios_limit:1:2000000
> /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor:1:ondemand
> /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_transition_latency:1:10000
> /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies:1:2000000 1667000 1333000 1000000
> /sys/devices/system/cpu/cpu0/cpufreq/freqdomain_cpus:1:0 1
> /sys/devices/system/cpu/cpu0/cpufreq/scaling_driver:1:acpi-cpufreq
> /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_cur_freq:1:1000000
> /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors:1:ondemand powersave performance conservative userspace
> /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq:1:1000000
> /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq:1:2000000
> /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_min_freq:1:1000000
> /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq:1:2000000
> /sys/devices/system/cpu/cpu0/cpufreq/affected_cpus:1:0
> /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq:1:1000000
> /sys/devices/system/cpu/cpu0/cpufreq/related_cpus:1:0
> /sys/devices/system/cpu/cpu0/cpufreq/scaling_setspeed:1:<unsupported>

Yeah, I don't see anything wrong with that output.

> I could try this. I guess this assumes I have to have another machine
> running in paralell, but this can be arranged with a little effort

Yep.

> Thanks for the hints. As I never had to do with overheating or
> similar issues, your help is very precious to me. Unfortunately we
> have a little child on board and time is limitted :) to a couple of
> hours daily, where I can work at home which means even less time for
> debugging. But I never give up. I just want to be sure that it is not
> a hardware issue

No worries, take care of the child first - the laptop and everyone else
can wait :-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

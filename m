Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932505AbaFIWOQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 18:14:16 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:63800 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932438AbaFIWOO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 18:14:14 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [REGRESSION] 3.15: Seems to turbo mode Intel Sandybridge Dual Core without need, overheating CPU
Date: Tue, 10 Jun 2014 00:31:37 +0200
Message-ID: <1542877.unMcdq6DKs@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <31874206.p2BkN8t4Hy@merkaba>
References: <1996399.buoKlNI5nG@merkaba> <1773550.hda5I1At4Q@vostro.rjw.lan> <31874206.p2BkN8t4Hy@merkaba>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 10, 2014 12:11:50 AM Martin Steigerwald wrote:
> Am Dienstag, 10. Juni 2014, 00:20:20 schrieb Rafael J. Wysocki:
> > On Monday, June 09, 2014 11:41:40 PM Martin Steigerwald wrote:
> > > Am Montag, 9. Juni 2014, 23:33:43 schrieb Martin Steigerwald:
> > > > Hi!
> > > > 
> > > > Added linux-pm to Cc. Also reboots seems to fix up the condition:
> > > > 
> > > > merkaba:~> grep . /sys/devices/system/cpu/cpu[0-3]/cpufreq/cpuinfo_cur_freq
> > > > /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_cur_freq:830957
> > > > /sys/devices/system/cpu/cpu1/cpufreq/cpuinfo_cur_freq:819628
> > > > /sys/devices/system/cpu/cpu2/cpufreq/cpuinfo_cur_freq:800000
> > > > /sys/devices/system/cpu/cpu3/cpufreq/cpuinfo_cur_freq:813476
> > > > merkaba:~> sensors                                                         
> > > > acpitz-virtual-0
> > > > Adapter: Virtual device
> > > > temp1:        +71.0°C  (crit = +98.0°C)
> > > > 
> > > > coretemp-isa-0000
> > > > Adapter: ISA adapter
> > > > Physical id 0:  +71.0°C  (high = +86.0°C, crit = +100.0°C)
> > > > Core 0:         +70.0°C  (high = +86.0°C, crit = +100.0°C)
> > > > Core 1:         +71.0°C  (high = +86.0°C, crit = +100.0°C)
> > > > 
> > > > thinkpad-isa-0000
> > > > Adapter: ISA adapter
> > > > fan1:        3137 R
> > > > 
> > > > 
> > > > Still hot in here and after reboot and login into KDE session there is quite
> > > > some CPU activity for a while.
> > > > 
> > > > But way better than before.
> > > > 
> > > > I can test whether this also happens with ACPI cpufreq driver.
> > > > 
> > > > I think I didn´t see this with 3.14.
> > > 
> > > Its not just me:
> > > 
> > > Please change intel_pstate default to disable
> > > https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1188647
> > 
> > Did you test the 3.15-rc kernels?  If so, do they have this problem too?
> 
> I think I saw this with 3.15-rc7 as well. Not so sure about 3.15-rc5.
> 
> I now switched to acpi + ondemand governor which seems to work better, as I
> posted. I still hit cpu throttling, but well its hot inside here. And maybe the fan
> also needs some cleaning.
> 
> Anyway, need to get some sleep now. I can test with rc7, rc5 and probably
> some older rc as I still have those available. Will take some time tough.

Well, my point really is whether or not there is a kernel where you didn't have
this problem with intel_pstate (ie. there is a regression in intel_pstate).

Rafael


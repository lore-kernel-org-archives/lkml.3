Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164AbaFKUjn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 16:39:43 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:37582 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbaFKUjl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 16:39:41 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Dirk Brandewie <dirk.brandewie@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [REGRESSION] 3.15: Seems to turbo mode Intel Sandybridge Dual Core without need, overheating CPU
Date: Wed, 11 Jun 2014 22:39:38 +0200
Message-ID: <3140356.YJAN8cBJY0@merkaba>
User-Agent: KMail/4.14 pre (Linux/3.15.0-tp520; KDE/4.13.1; x86_64; git-d280d4b; 2014-06-10)
In-Reply-To: <53963275.5040909@gmail.com>
References: <1996399.buoKlNI5nG@merkaba> <13232691.DxAv2jorp8@merkaba> <53963275.5040909@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 9. Juni 2014, 15:17:25 schrieb Dirk Brandewie:

> Hi Martin,

Hi Dirk,

> Can you send the output of:
>     turbostat sleep 10
> and
>     for i in 0 1 2 3; do rdmsr  -p $i -u -f15:8 0x198; done
> 
> For the normal and bad case please.

Normal case:

merkaba:~> turbostat sleep 10
    Core     CPU Avg_MHz   %Busy Bzy_MHz TSC_MHz     SMI  CPU%c1  CPU%c3  CPU%c6  CPU%c7 CoreTmp  PkgTmp Pkg%pc2 Pkg%pc3 Pkg%pc6 Pkg%pc7 PkgWatt CorWatt GFXWatt 
       -       -      22    1.82    1217    2492       0    3.22    2.09    0.00   92.87      53      52    1.46    3.51    2.98   83.13    3.43    0.38    0.15
       0       0      32    2.37    1335    2492       0    3.24    0.07    0.00   94.33      53      52    1.46    3.51    2.98   83.13    3.43    0.38    0.15
       0       1      23    2.04    1127    2492       0    3.57
       1       2      22    1.66    1328    2492       0    2.82    4.11    0.00   91.42      52
       1       3      12    1.20     984    2492       0    3.27
10.004021 sec

merkaba:~> for i in 0 1 2 3; do rdmsr  -p $i -u -f15:8 0x198; done
10
11
11
11

merkaba:~> sensors
acpitz-virtual-0
Adapter: Virtual device
temp1:        +68.0°C  (crit = +98.0°C)

coretemp-isa-0000
Adapter: ISA adapter
Physical id 0:  +59.0°C  (high = +86.0°C, crit = +100.0°C)
Core 0:         +56.0°C  (high = +86.0°C, crit = +100.0°C)
Core 1:         +59.0°C  (high = +86.0°C, crit = +100.0°C)

thinkpad-isa-0000
Adapter: ISA adapter
fan1:        2845 RPM




Bad case:

merkaba:~> turbostat sleep 10
    Core     CPU Avg_MHz   %Busy Bzy_MHz TSC_MHz     SMI  CPU%c1  CPU%c3  CPU%c6  CPU%c7 CoreTmp  PkgTmp Pkg%pc2 Pkg%pc3 Pkg%pc6 Pkg%pc7 PkgWatt CorWatt GFXWatt 
       -       -     505   16.18    3119    2492       0   24.45    1.33    0.14   57.90      89      92    0.00    0.00    0.00    0.00   24.29   11.68    9.31
       0       0    1564   49.63    3151    2492       0   15.54    2.32    0.28   32.23      87      92    0.00    0.00    0.00    0.00   24.29   11.68    9.31
       0       1     125    4.14    3024    2492       0   61.03
       1       2     216    7.15    3021    2492       0    8.95    0.33    0.00   83.56      89
       1       3     114    3.81    2987    2492       0   12.29
10.001227 sec

merkaba:~> for i in 0 1 2 3; do rdmsr  -p $i -u -f15:8 0x198; done
32
32
30
30

merkaba:~> sensors
acpitz-virtual-0
Adapter: Virtual device
temp1:        +91.0°C  (crit = +98.0°C)

coretemp-isa-0000
Adapter: ISA adapter
Physical id 0:  +91.0°C  (high = +86.0°C, crit = +100.0°C)
Core 0:         +91.0°C  (high = +86.0°C, crit = +100.0°C)
Core 1:         +90.0°C  (high = +86.0°C, crit = +100.0°C)

thinkpad-isa-0000
Adapter: ISA adapter
fan1:        3600 RP


It throttled just once so far.

Still 3.15 kernel. Only change: I upgraded from 8 GiB to 16 GiB of RAM.

This may lower CPU usage due to handling page scanning or swapping a bit,
as PlaneShift tends to take about 4 to 5 GiB RSS easily.

Should I hit throttling temperatures I will try to capture this output
once more.

Thanks,
Martin




> 
> --Dirk
> 
> On 06/09/2014 02:33 PM, Martin Steigerwald wrote:
> > Hi!
> >
> > Added linux-pm to Cc. Also reboots seems to fix up the condition:
> >
> > merkaba:~> grep . /sys/devices/system/cpu/cpu[0-3]/cpufreq/cpuinfo_cur_freq
> > /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_cur_freq:830957
> > /sys/devices/system/cpu/cpu1/cpufreq/cpuinfo_cur_freq:819628
> > /sys/devices/system/cpu/cpu2/cpufreq/cpuinfo_cur_freq:800000
> > /sys/devices/system/cpu/cpu3/cpufreq/cpuinfo_cur_freq:813476
> > merkaba:~> sensors
> > acpitz-virtual-0
> > Adapter: Virtual device
> > temp1:        +71.0°C  (crit = +98.0°C)
> >
> > coretemp-isa-0000
> > Adapter: ISA adapter
> > Physical id 0:  +71.0°C  (high = +86.0°C, crit = +100.0°C)
> > Core 0:         +70.0°C  (high = +86.0°C, crit = +100.0°C)
> > Core 1:         +71.0°C  (high = +86.0°C, crit = +100.0°C)
> >
> > thinkpad-isa-0000
> > Adapter: ISA adapter
> > fan1:        3137 R
> >
> >
> > Still hot in here and after reboot and login into KDE session there is quite
> > some CPU activity for a while.
> >
> > But way better than before.
> >
> > I can test whether this also happens with ACPI cpufreq driver.
> >
> > I think I didn´t see this with 3.14.
> >
> >
> >
> > Am Montag, 9. Juni 2014, 23:24:54 schrieb Martin Steigerwald:
> >> Hi!
> >>
> >> I get:
> >>
> >> Jun  9 22:41:32 merkaba kernel: [39978.006479] CPU0: Package temperature/speed normal
> >> Jun  9 22:41:32 merkaba kernel: [39978.006481] CPU3: Package temperature/speed normal
> >> Jun  9 22:41:32 merkaba kernel: [39978.006482] CPU2: Package temperature/speed normal
> >> Jun  9 22:41:32 merkaba kernel: [39978.006487] CPU1: Package temperature/speed normal
> >> Jun  9 22:44:02 merkaba kernel: [40127.673372] CPU2: Core temperature above threshold, cpu clock throttled (total events = 56554)
> >> Jun  9 22:44:02 merkaba kernel: [40127.673383] CPU3: Core temperature above threshold, cpu clock throttled (total events = 56554)
> >> Jun  9 22:44:02 merkaba kernel: [40127.674313] CPU3: Core temperature/speed normal
> >> Jun  9 22:44:02 merkaba kernel: [40127.674352] CPU2: Core temperature/speed normal
> >> Jun  9 22:45:21 merkaba kernel: [40207.302287] mce: [Hardware Error]: Machine check events logged
> >> Jun  9 22:46:32 merkaba kernel: [40278.054568] CPU0: Package temperature/speed normal
> >> Jun  9 22:46:32 merkaba kernel: [40278.054572] CPU3: Package temperature/speed normal
> >> Jun  9 22:46:32 merkaba kernel: [40278.054574] CPU2: Package temperature/speed normal
> >> Jun  9 22:46:32 merkaba kernel: [40278.054578] CPU1: Package temperature/speed normal
> >> Jun  9 22:48:06 merkaba kernel: [40371.570654] perf interrupt took too long (19348 > 17857), lowering kernel.perf_event_max_sample_rate to 7000
> >> Jun  9 22:51:32 merkaba kernel: [40578.103629] CPU3: Package temperature/speed normal
> >> Jun  9 22:51:32 merkaba kernel: [40578.103633] CPU0: Package temperature/speed normal
> >> Jun  9 22:51:32 merkaba kernel: [40578.103638] CPU2: Package temperature/speed normal
> >> Jun  9 22:51:32 merkaba kernel: [40578.103639] CPU1: Package temperature/speed normal
> >> Jun  9 22:56:32 merkaba kernel: [40878.174734] CPU1: Package temperature above threshold, cpu clock throttled (total events = 152620)
> >> Jun  9 22:56:32 merkaba kernel: [40878.174737] CPU0: Package temperature above threshold, cpu clock throttled (total events = 152620)
> >> Jun  9 22:56:32 merkaba kernel: [40878.174742] CPU3: Package temperature above threshold, cpu clock throttled (total events = 152620)
> >> Jun  9 22:56:32 merkaba kernel: [40878.174744] CPU2: Package temperature above threshold, cpu clock throttled (total events = 152620)
> >> Jun  9 22:56:32 merkaba kernel: [40878.176744] CPU3: Package temperature/speed normal
> >> Jun  9 22:56:32 merkaba kernel: [40878.176746] CPU2: Package temperature/speed normal
> >> Jun  9 22:56:32 merkaba kernel: [40878.176748] CPU1: Package temperature/speed normal
> >> Jun  9 22:56:32 merkaba kernel: [40878.176749] CPU0: Package temperature/speed normal
> >> Jun  9 22:59:11 merkaba kernel: [41037.278705] CPU3: Core temperature/speed normal
> >> Jun  9 22:59:11 merkaba kernel: [41037.278707] CPU2: Core temperature/speed normal
> >> Jun  9 23:01:32 merkaba kernel: [41178.225837] CPU2: Package temperature above threshold, cpu clock throttled (total events = 177343)
> >> Jun  9 23:01:32 merkaba kernel: [41178.225841] CPU0: Package temperature above threshold, cpu clock throttled (total events = 177343)
> >> Jun  9 23:01:32 merkaba kernel: [41178.225843] CPU3: Package temperature above threshold, cpu clock throttled (total events = 177343)
> >> Jun  9 23:01:32 merkaba kernel: [41178.225845] CPU1: Package temperature above threshold, cpu clock throttled (total events = 177343)
> >> Jun  9 23:01:32 merkaba kernel: [41178.237850] CPU1: Package temperature/speed normal
> >> Jun  9 23:01:32 merkaba kernel: [41178.237853] CPU2: Package temperature/speed normal
> >> Jun  9 23:01:32 merkaba kernel: [41178.237855] CPU0: Package temperature/speed normal
> >> Jun  9 23:01:32 merkaba kernel: [41178.237856] CPU3: Package temperature/speed normal
> >> Jun  9 23:01:36 merkaba kernel: [41182.452403] mce: [Hardware Error]: Machine check events logged
> >> Jun  9 23:06:32 merkaba kernel: [41478.291923] CPU1: Package temperature above threshold, cpu clock throttled (total events = 204756)
> >> Jun  9 23:06:32 merkaba kernel: [41478.291926] CPU0: Package temperature above threshold, cpu clock throttled (total events = 204756)
> >> Jun  9 23:06:32 merkaba kernel: [41478.291946] CPU3: Package temperature above threshold, cpu clock throttled (total events = 204756)
> >> Jun  9 23:06:32 merkaba kernel: [41478.291950] CPU2: Package temperature above threshold, cpu clock throttled (total events = 204756)
> >> Jun  9 23:11:32 merkaba kernel: [41778.341992] CPU3: Package temperature/speed normal
> >> Jun  9 23:11:32 merkaba kernel: [41778.341995] CPU0: Package temperature/speed normal
> >> Jun  9 23:11:32 merkaba kernel: [41778.341996] CPU1: Package temperature/speed normal
> >> Jun  9 23:11:32 merkaba kernel: [41778.341997] CPU2: Package temperature/speed normal
> >>
> >>
> >> And this:
> >>
> >> merkaba:~> sensors
> >> acpitz-virtual-0
> >> Adapter: Virtual device
> >> temp1:        +96.0°C  (crit = +98.0°C)
> >>
> >> coretemp-isa-0000
> >> Adapter: ISA adapter
> >> Physical id 0:  +98.0°C  (high = +86.0°C, crit = +100.0°C)
> >> Core 0:         +96.0°C  (high = +86.0°C, crit = +100.0°C)
> >> Core 1:         +96.0°C  (high = +86.0°C, crit = +100.0°C)
> >>
> >> thinkpad-isa-0000
> >> Adapter: ISA adapter
> >> fan1:        3580 RPM
> >>
> >> merkaba:~> acpi -t
> >> Thermal 0: ok, 96.0 degrees C
> >>
> >>
> >> On
> >>
> >> martin@merkaba:~> phoronix-test-suite system-info
> >>
> >> Phoronix Test Suite v4.8.3
> >> System Information
> >>
> >> Hardware:
> >> Processor: Intel Core i5-2520M @ 3.20GHz (4 Cores), Motherboard: LENOVO 42433WG, Chipset: Intel 2nd Generation Core Family DRAM, Memory: 8192MB, Disk: 300GB INTEL SSDSA2CW30 + 480GB Crucial_CT480M50, Graphics: Intel HD 3000 (1300MHz), Audio: Intel 6 /C200, Network: Intel 82579LM Gigabit Connection + Intel Centrino Advanced-N 6205
> >>
> >> Software:
> >> OS: Debian unstable, Kernel: 3.15.0-tp520 (x86_64), Desktop: KDE 4.13.1, Display Server: X Server 1.15.1, Display Driver: intel 2.21.15, OpenGL: 3.1 Mesa 10.1.4, Compiler: GCC 4.8, File-System: btrfs, Screen Resolution: 1920x1080
> >>
> >>
> >> during playing PlaneShift with Intel gfx.
> >>
> >>
> >> I get the impression that Intel P-State driver turbo modes all of the cores
> >> needlessly *and* permanently once this condition is triggered. Usually
> >> temperature is just about 55-60 degree celsius. But not at maximum.
> >>
> >>
> >> I see this:
> >>
> >> merkaba:/sys/devices/system/cpu> grep . cpu[0-3]/cpufreq/cpuinfo_cur_freq
> >> cpu0/cpufreq/cpuinfo_cur_freq:3015917
> >> cpu1/cpufreq/cpuinfo_cur_freq:3008984
> >> cpu2/cpufreq/cpuinfo_cur_freq:3000000
> >> cpu3/cpufreq/cpuinfo_cur_freq:3000000
> >>
> >>
> >> Without that much work to do:
> >>
> >> merkaba:~> mpstat -P ALL 10
> >> Linux 3.15.0-tp520 (merkaba)    09.06.2014      _x86_64_        (4 CPU)
> >>
> >> 23:21:42     CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest  %gnice   %idle
> >> 23:21:52     all   15,61    0,00    2,68   10,33    0,15    0,00    0,00    0,00    0,00   71,23
> >> 23:21:52       0   25,70    0,00    4,22   22,59    0,30    0,00    0,00    0,00    0,00   47,19
> >> 23:21:52       1   20,02    0,00    1,80   14,71    0,10    0,00    0,00    0,00    0,00   63,36
> >> 23:21:52       2   10,14    0,00    2,61    3,01    0,10    0,00    0,00    0,00    0,00   84,14
> >> 23:21:52       3    6,63    0,00    2,11    0,80    0,10    0,00    0,00    0,00    0,00   90,36
> >>
> >> 23:21:52     CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest  %gnice   %idle
> >> 23:22:02     all   14,19    0,00    2,26   10,93    0,13    0,00    0,00    0,00    0,00   72,50
> >> 23:22:02       0   32,26    0,00    4,01   31,86    0,20    0,00    0,00    0,00    0,00   31,66
> >> 23:22:02       1   12,11    0,00    1,30    8,51    0,10    0,00    0,00    0,00    0,00   77,98
> >> 23:22:02       2    8,12    0,00    2,21    2,91    0,10    0,00    0,00    0,00    0,00   86,66
> >> 23:22:02       3    4,31    0,00    1,60    0,40    0,10    0,00    0,00    0,00    0,00   93,59
> >>
> >> 23:22:02     CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest  %gnice   %idle
> >> 23:22:12     all   25,33    0,03    2,63    9,00    0,15    0,00    0,00    0,00    0,00   62,87
> >> 23:22:12       0   35,71    0,00    4,01   19,56    0,20    0,00    0,00    0,00    0,00   40,52
> >> 23:22:12       1   27,43    0,00    1,90   10,61    0,20    0,00    0,00    0,00    0,00   59,86
> >> 23:22:12       2   22,14    0,10    2,40    4,41    0,10    0,00    0,00    0,00    0,00   70,84
> >> 23:22:12       3   15,96    0,10    2,21    1,41    0,10    0,00    0,00    0,00    0,00   80,22
> >>
> >> 23:22:12     CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest  %gnice   %idle
> >> 23:22:22     all   27,90    0,03    3,94    8,87    0,33    0,00    0,00    0,00    0,00   58,94
> >> 23:22:22       0   36,77    0,00    5,81   20,74    0,90    0,00    0,00    0,00    0,00   35,77
> >> 23:22:22       1   28,99    0,00    2,41   10,13    0,10    0,00    0,00    0,00    0,00   58,38
> >> 23:22:22       2   25,48    0,00    3,81    3,21    0,20    0,00    0,00    0,00    0,00   67,30
> >> 23:22:22       3   20,34    0,00    3,71    1,40    0,20    0,00    0,00    0,00    0,00   74,35
> >>
> >>
> >>
> >> Will reboot now to see whether it resets that condition. Didn´t happen during the whole
> >> day.
> >>
> >> But seems to happen after a while of playing PlaneShift.
> >>
> >> Any hints?
> >
> > Thanks,
> >
> 

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

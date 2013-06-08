Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826Ab3FHUet (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 16:34:49 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:49587 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745Ab3FHUer convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 16:34:47 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [REGRESSION] fan always on with 3.10-rc2
Date: Sat, 08 Jun 2013 22:34:44 +0200
Message-ID: <1825381.bJOGDrYABG@merkaba>
User-Agent: KMail/4.10.2 (Linux/3.10.0-rc4-tp520; KDE/4.10.2; x86_64; ; )
In-Reply-To: <15568618.SsOOjPSAq8@merkaba>
References: <15568618.SsOOjPSAq8@merkaba>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 24. Mai 2013, 13:03:18 schrieb Martin Steigerwald:
> Hi!
> 
> With 3.10-rc2 I see fan always or almost always on, even during extended
> periods of basically idling around. I did not notice this with 3.9. This is
> on an ThinkPad T520 with Intel Sandybridge i5-2520M dual core with
> hyperthreading at regularily 2,5 GhZ and Intel graphics (no nvidia).
> 
> I am using full hz:
> 
> martin@merkaba:~/Linux/Kernel/Mainline/Bugs/fan always on with 3.10.2-rc2> xzgrep NO_HZ config-3.10.0-rc2-tp520.xz
> CONFIG_NO_HZ_COMMON=y
> # CONFIG_NO_HZ_IDLE is not set
> CONFIG_NO_HZ_FULL=y
> CONFIG_NO_HZ_FULL_ALL=y
> CONFIG_NO_HZ=y
> CONFIG_RCU_FAST_NO_HZ=y
> 
> And P-State driver (which I used in 3.9 already as well).
> 
> Kernel config attached as xz. Use xzless or xzcat to display.
> 
> 
> What puzzles is output of powertop, especially:

Still present in 3.10-rc4.

I disabled P-State driver but then rpm seems to be even worse.

Around 2800 rpm all the time, was about 2650 with Intel P State driver.

Next I will try without CONFIG_NO_HZ_FULL and CONFIG_NO_HZ_FULL_ALL.

According to powertop CPU 0 is never idle

PowerTOP v2.0     Overview   Idle stats   Frequency stats   Device stats   Tunables                                     


            Package |             Core    |            CPU 0       CPU 1
                    |                     | Actual       843 MHz    1148 MHz
Turbo Mode   2,2%   | Turbo Mode   2,1%   | Turbo Mode   2,1%        0,8%
2,50 GHz     0,9%   | 2,50 GHz     0,9%   | 2,50 GHz     0,9%        0,0%
2,00 GHz     0,0%   | 2,00 GHz     0,0%   | 2,00 GHz     0,0%        0,0%
1,80 GHz     0,1%   | 1,80 GHz     0,1%   | 1,80 GHz     0,1%        0,0%
1,60 GHz     0,0%   | 1,60 GHz     0,0%   | 1,60 GHz     0,0%        0,0%
1400 MHz     0,0%   | 1400 MHz     0,0%   | 1400 MHz     0,0%        0,0%
1200 MHz     0,0%   | 1200 MHz     0,0%   | 1200 MHz     0,0%        0,0%
1000 MHz     0,0%   | 1000 MHz     0,0%   | 1000 MHz     0,0%        0,0%
 800 MHz    87,9%   |  800 MHz    87,3%   |  800 MHz    87,1%        3,5%
Idle         9,0%   | Idle         9,6%   | Idle         9,9%       95,7%

                    |             Core    |            CPU 2       CPU 3
                    |                     | Actual       953 MHz     905 MHz
                    | Turbo Mode   0,8%   | Turbo Mode   0,7%        0,1%
                    | 2,50 GHz     0,7%   | 2,50 GHz     0,7%        0,0%
                    | 2,00 GHz     0,0%   | 2,00 GHz     0,0%        0,0%
                    | 1,80 GHz     0,1%   | 1,80 GHz     0,1%        0,0%
                    | 1,60 GHz     0,0%   | 1,60 GHz     0,0%        0,0%
                    | 1400 MHz     0,0%   | 1400 MHz     0,0%        0,0%
                    | 1200 MHz     0,0%   | 1200 MHz     0,0%        0,0%
                    | 1000 MHz     0,0%   | 1000 MHz     0,0%        0,0%
                    |  800 MHz    10,3%   |  800 MHz     7,4%        3,7%
                    | Idle        88,1%   | Idle        91,0%       96,2%




PowerTOP v2.0     Overview   Idle stats   Frequency stats   Device stats   Tunables                                     


          Package   |             Core    |            CPU 0       CPU 1
                    |                     | C0 active  32,5%        0,3%
                    |                     | POLL       96,4%    0,9 ms  0,0%    0,0 ms
                    |                     | C1E-SNB     0,0%    0,0 ms  0,0%    0,2 ms
C2 (pc2)    0,0%    |                     |
C3 (pc3)    0,0%    | C3 (cc3)    0,0%    | C3-SNB      0,0%    0,0 ms  0,0%    0,1 ms
C6 (pc6)    0,0%    | C6 (cc6)    0,0%    | C6-SNB      0,0%    0,0 ms  0,0%    0,0 ms
C7 (pc7)    0,0%    | C7 (cc7)    0,0%    | C7-SNB      0,0%    0,0 ms 99,2%   10,9 ms

                    |             Core    |            CPU 2       CPU 3
                    |                     | C0 active   1,2%        0,7%
                    |                     | POLL        0,0%    0,0 ms  0,0%    0,0 ms
                    |                     | C1E-SNB     0,0%    0,1 ms  0,1%    0,2 ms
                    |                     |
                    | C3 (cc3)    0,1%    | C3-SNB      0,0%    0,8 ms  0,0%    0,2 ms
                    | C6 (cc6)    0,0%    | C6-SNB      0,0%    0,0 ms  0,0%    0,0 ms
                    | C7 (cc7)   95,0%    | C7-SNB     97,7%   14,5 ms 97,7%   12,2 ms


Old outputs with rc2 and P-State driver for comparison:

> 
> PowerTOP v2.0     Overview   Idle stats   Frequency stats   Device stats   Tunables                                     
> 
> 
>           Package   |             Core    |            CPU 0       CPU 1
>                     |                     | C0 active 127,4%        2,3%
>                                                       ^^^^^^
>                     |                     | POLL       98,1%    0,9 ms  0,0%    0,0 ms
>                                                        ^^^^^
>                     |                     | C1E-SNB     0,0%    0,0 ms  0,4%    0,9 ms
> C2 (pc2)    0,0%    |                     |
> C3 (pc3)    0,0%    | C3 (cc3)    0,0%    | C3-SNB      0,0%    0,0 ms  0,1%    0,8 ms
> C6 (pc6)    0,0%    | C6 (cc6)    0,0%    | C6-SNB      0,0%    0,0 ms  0,0%    0,8 ms
> C7 (pc7)    0,0%    | C7 (cc7)    0,0%    | C7-SNB      0,0%    0,0 ms 97,5%    7,4 ms
> 
>                     |             Core    |            CPU 2       CPU 3
>                     |                     | C0 active   1,9%        0,8%
>                     |                     | POLL        0,0%    0,0 ms  0,0%    0,0 ms
>                     |                     | C1E-SNB     1,1%    1,3 ms  0,0%    0,1 ms
>                     |                     |
>                     | C3 (cc3)    0,3%    | C3-SNB      0,3%    1,0 ms  0,0%    0,2 ms
>                     | C6 (cc6)    0,1%    | C6-SNB      0,1%    2,5 ms  0,0%    0,3 ms
>                     | C7 (cc7)   96,2%    | C7-SNB     97,0%    7,2 ms 99,3%   17,2 ms
> 
> 
> PowerTOP v2.0     Overview   Idle stats   Frequency stats   Device stats   Tunables                                     
> 
> 
>             Package |             Core    |            CPU 0       CPU 1
>                     |                     | Actual    3,2 GHz     3,1 GHz
> Idle       100,0%   | Idle       100,0%   | Idle       100,0%      100,0%
> 
>                     |             Core    |            CPU 2       CPU 3
>                     |                     | Actual    3,0 GHz     3,0 GHz
>                     | Idle       100,0%   | Idle       100,0%      100,0%
> 
> 
> It seems the kernel is overbusying one core completely, if the output of
> powertop is correct. And why is Actual frequencing of CPUs that high?
> I saw that kernel tends to overtact quickly. I thought this was due to
> getting work done quickly and then let it idle. But the idle stats
> seem bogus to, maybe powertop is not up to date with current kernels?
> 
> I see no reason for busying one core. This happens when CPU usage is
> below 20%. The fan is consistently around 2640 rpm:
> 
> 
> PowerTOP v2.0     Overview   Idle stats   Frequency stats   Device stats   Tunables                                     
> 
> Summary: 399,8 wakeups/second,  0,0 GPU ops/second, 0,0 VFS ops/sec and 3,0% CPU use
> 
>                 Usage       Events/s    Category       Description
>              2644 rpm                   Device         Laptop fan
>             100,0%                      Device         Audio codec hwC0D1: Conexant
>             100,0%                      Device         Audio codec hwC0D3: Intel
>             100,0%                      Device         Audio codec hwC0D0: Conexant
>              30,7 탎/s     112,3        Process        [ksoftirqd/0]
>               4,2 ms/s      83,5        Process        kwin -session 10cec7d36b000136265311700000023930000_1369322581_349094
>               0,8 ms/s      67,3        Process        [irq/42-i915@pci]
>               5,5 ms/s      53,6        Process        /usr/bin/X :0 vt7 -br -nolisten tcp -auth /var/run/xauth/A:0-eXsirc
>             698,3 탎/s      13,3        Process        [irq/16-mmc0]
>              85,8 탎/s       9,1        Process        [rcu_preempt]
>             297,1 탎/s       8,7        Process        /usr/sbin/mysqld --defaults-file=/home/martin/.local/share/akonadi/mysql.conf --datadir
>              78,6 탎/s       8,1        Process        [ksoftirqd/2]
>               6,7 ms/s       3,7        Process        /usr/bin/plasma-desktop
>             218,9 탎/s       5,0        Interrupt      [1] timer(softirq)
>               2,8 ms/s       2,9        Process        /usr/bin/konsole -session 10cec7d36b000135326160200000249810027_1369322580_899575
>              65,9 탎/s       3,6        Process        [ksoftirqd/1]
>              69,8 탎/s       3,5        Process        [ksoftirqd/3]
>              38,1 탎/s       3,4        Process        [rcuop/3]
>              35,3 탎/s       2,4        Process        [rcuop/2]
>               6,0 ms/s      0,00        Process        atop
>              21,3 탎/s       1,8        Process        [irq/43-ahci]
>              33,3 탎/s       1,7        Process        [rcuop/0]
>             122,3 탎/s       1,7        Process        [btrfs-transacti]
>              66,4 탎/s       1,5        Process        /usr/bin/dirmngr --daemon --sh
>              61,2 탎/s       1,0        Process        [rcuop/1]
>              29,2 탎/s       1,0        Process        /usr/lib/gvfs/gvfs-afc-volume-monitor
>              40,8 탎/s       0,9        Timer          process_timeout
>              25,5 탎/s       0,9        Process        /usr/bin/python /usr/bin/hp-systray -x
>              32,2 탎/s       0,7        Process        /usr/bin/dbus-daemon --fork --print-pid 5 --print-address 7 --session
>               5,1 탎/s       0,7        Process        [irq/44-eth0]
>             612,1 탎/s       0,4        Process        ksysguardd
>             137,6 탎/s       0,5        Interrupt      [7] sched(softirq)
>               5,6 탎/s       0,5        Timer          clocksource_watchdog
>              71,2 탎/s       0,4        kWork          disk_events_workfn
>              57,5 탎/s       0,4        Process        kdeinit4: kded4 [kdeinit]
>              68,3 탎/s       0,3        Process        akonadiserver
>              34,6 탎/s       0,3        Process        /usr/bin/virtuoso-t +foreground +configfile /tmp/virtuoso_fB2599.ini +wait
>              14,9 탎/s       0,3        Process        /usr/bin/gpg-agent --daemon --sh --write-env-file=/home/martin/.gnupg/gpg-agent-info-me
>              39,4 탎/s      0,30        Process        /usr/bin/nepomukservicestub nepomukfileindexer
> 
> 
> PowerTOP v2.0     Overview   Idle stats   Frequency stats   Device stats   Tunables                                     
> 
> 
>               Usage     Device name
>              2644 rpm     Laptop fan
>               4,3%        CPU use
>             100,0%        Audio codec hwC0D3: Intel
>             100,0%        Audio codec hwC0D0: Conexant
>             100,0%        Audio codec hwC0D1: Conexant
>              20,9 pkts/s  Network interface: eth0 (e1000e)
>             100,0%        USB device: usb-device-8087-0024
>             100,0%        USB device: usb-device-8087-0024
>             100,0%        Display backlight
>             100,0%        Display backlight
>             100,0%        USB device: EHCI Host Controller
>             100,0%        USB device: Biometric Coprocessor (UPEK)
>             100,0%        USB device: Integrated Smart Card Reader (Lenovo)
>             100,0%        USB device: EHCI Host Controller
>               0,0 ops/s   GPU
>             100,0%        USB device: usb-device-17ef-100a
>             100,0%        PCI Device: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 5
>             100,0%        PCI Device: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 4
>             100,0%        PCI Device: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 2
>             100,0%        PCI Device: Intel Corporation 6 Series/C200 Series Chipset Family High Definition Audio Controller
>             100,0%        PCI Device: Intel Corporation 6 Series/C200 Series Chipset Family MEI Controller #1
>             100,0%        USB device: PS/2+USB Mouse
>             100,0%        PCI Device: Intel Corporation QM67 Express Chipset Family LPC Controller
>             100,0%        PCI Device: Intel Corporation 6 Series/C200 Series Chipset Family 6 port SATA AHCI Controller
>             100,0%        PCI Device: Ricoh Co Ltd MMC/SD Host Controller
>             100,0%        PCI Device: Silicon Image, Inc. SiI 3531 [SATALink/SATARaid] Serial ATA Controller
>             100,0%        PCI Device: Ricoh Co Ltd R5C832 PCIe IEEE 1394 Controller
>             100,0%        PCI Device: Intel Corporation 6 Series/C200 Series Chipset Family USB Enhanced Host Controller #2
>             100,0%        PCI Device: Intel Corporation 82579LM Gigabit Network Connection
>             100,0%        PCI Device: Intel Corporation 6 Series/C200 Series Chipset Family SMBus Controller
>             100,0%        PCI Device: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 1
>             100,0%        PCI Device: Intel Corporation 6 Series/C200 Series Chipset Family USB Enhanced Host Controller #1
>             100,0%        PCI Device: Intel Corporation 2nd Generation Core Processor Family Integrated Graphics Controller
>             100,0%        PCI Device: Intel Corporation 2nd Generation Core Processor Family DRAM Controller
>             100,0%        PCI Device: Intel Corporation Centrino Advanced-N 6205 [Taylor Peak]
>               0,0 pkts/s  Network interface: wlan0 (iwlwifi)
>               0,0%        Thinkpad light
>               0,0%        Radio device: thinkpad_acpi
>               0,0%        Radio device: iwlwifi
> 
> 
> I saw nothing outstanding in dmesg or kern.log, just
> 
> merkaba:~#2> grep "Intel pstate controlling: cpu" /var/log/kern.log
> May 20 10:03:31 merkaba kernel: [264852.930994] Intel pstate controlling: cpu 1
> May 20 10:03:31 merkaba kernel: [264852.944479] Intel pstate controlling: cpu 2
> May 20 10:03:31 merkaba kernel: [264852.957879] Intel pstate controlling: cpu 3
> May 21 09:14:03 merkaba kernel: [315800.710623] Intel pstate controlling: cpu 1
> May 21 09:14:03 merkaba kernel: [315800.724087] Intel pstate controlling: cpu 2
> May 21 09:14:03 merkaba kernel: [315800.737493] Intel pstate controlling: cpu 3
> May 21 20:01:20 merkaba kernel: [344305.122543] Intel pstate controlling: cpu 1
> May 21 20:01:20 merkaba kernel: [344305.135953] Intel pstate controlling: cpu 2
> May 21 20:01:20 merkaba kernel: [344305.149398] Intel pstate controlling: cpu 3
> May 21 21:52:18 merkaba kernel: [    1.441043] Intel pstate controlling: cpu 0
> May 21 21:52:18 merkaba kernel: [    1.441084] Intel pstate controlling: cpu 1
> May 21 21:52:18 merkaba kernel: [    1.441123] Intel pstate controlling: cpu 2
> May 21 21:52:18 merkaba kernel: [    1.441162] Intel pstate controlling: cpu 3
> May 23 17:22:29 merkaba kernel: [    1.860224] Intel pstate controlling: cpu 0
> May 23 17:22:29 merkaba kernel: [    1.860267] Intel pstate controlling: cpu 1
> May 23 17:22:29 merkaba kernel: [    1.860306] Intel pstate controlling: cpu 2
> May 23 17:22:29 merkaba kernel: [    1.860345] Intel pstate controlling: cpu 3
> 
> But these seem to be regular and I had them before as well.
> 
> Thanks,
> 
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

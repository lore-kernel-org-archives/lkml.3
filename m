Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031Ab3FHWJK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 18:09:10 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:60324 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752923Ab3FHWJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 18:09:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: Borislav Petkov <bp@suse.de>, Viresh Kumar <viresh.kumar@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] cpufreq: ondemand: Change the calculation of target frequency
Date: Sun, 09 Jun 2013 00:18:09 +0200
Message-ID: <2892497.M93vsSKx5I@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <51B394A9.3020005@semaphore.gr>
References: <q46r5iepl3sunqe5eemv66hk.1370694869222@email.android.com> <1731097.2elXaGsAyC@vostro.rjw.lan> <51B394A9.3020005@semaphore.gr>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, June 08, 2013 11:31:37 PM Stratos Karafotis wrote:
> On 06/08/2013 05:05 PM, Rafael J. Wysocki wrote:
> > On Saturday, June 08, 2013 03:34:29 PM Stratos Karafotis wrote:
> >> I also did the test with the way you mentioned. But I thought to run turbostat for 100 sec as I did with powertop.
> > 
> > Ah, OK.
> > 
> >> Actually benchmark lasts about 96 secs.
> >>
> >> I think that we use almost the same energy for 100 sec to run the same load a little bit faster. I think this means also a reduce to power consumption.
> >>
> >> I will also send the results running the test as you said.
> > 
> > Cool, thanks!
> 
> More results running:
> ./turbostat phoronix-test-suite benchmark pts/build-linux-kernel
> 
> Measurement steps with and without this patch:
> 1) Reboot system
> 2) Run twice the command above without taking measurement
> 3) Wait few minutes
> 4) Run the command and take measurement
> 
> Thanks,
> Stratos
> 
> --------------------------------------------------------------
> Test WITHOUT this patch:
> 
> Phoronix Test Suite v4.6.0
> 
>     Installed: pts/build-linux-kernel-1.3.0
> 
> System Information
> 
> Hardware:
> Processor: Intel Core i7-3770 @ 3.40GHz (8 Cores), Motherboard: ASUS CM6870, Chipset: Intel Xeon E3-1200 v2/3rd, Memory: 2 x 4096 MB DDR3-1600MHz HY64C1C1624ZY, Disk: 1000GB Seagate ST1000DM003-9YN1, Graphics: NVIDIA GeForce GT 640 3072MB, Audio: Realtek ALC892, Monitor: S23B350, Network: Realtek RTL8111/8168 + Ralink RT3090 Wireless 802.11n 1T/1R
> 
> Software:
> OS: Fedora 18, Kernel: 3.10.0-rc3v+ (x86_64), Desktop: KDE 4.10.3, Display Server: X Server 1.13.3, Display Driver: nouveau 1.0.7, File-System: ext4, Screen Resolution: 1920x1080
> 
>     Would you like to save these test results (Y/n): 
> 
> Timed Linux Kernel Compilation 3.1:
>     pts/build-linux-kernel-1.3.0
>     Test 1 of 1
>     Estimated Trial Run Count:    3
>     Estimated Time To Completion: 2 Minutes
>         Running Pre-Test Script @ 22:59:35
>         Started Run 1 @ 22:59:46
>         Running Interim Test Script @ 23:00:00
>         Started Run 2 @ 23:00:04
>         Running Interim Test Script @ 23:00:13
>         Started Run 3 @ 23:00:17
>         Running Interim Test Script @ 23:00:26  [Std. Dev: 10.04%]
>         Started Run 4 @ 23:00:30
>         Running Interim Test Script @ 23:00:39  [Std. Dev: 8.98%]
>         Started Run 5 @ 23:00:43
>         Running Interim Test Script @ 23:00:53  [Std. Dev: 7.80%]
>         Started Run 6 @ 23:00:56  [Std. Dev: 7.21%]
>         Running Post-Test Script @ 23:01:06
> 
>     Test Results:
>         11.121481895447
>         9.3301539421082
>         9.4521908760071
>         9.3115320205688
>         9.720575094223
>         9.396096944809
> 
>     Average: 9.72 Seconds
> 
> cor CPU    %c0  GHz  TSC SMI    %c1    %c3    %c6    %c7 CTMP PTMP   %pc2   %pc3   %pc6   %pc7  Pkg_W  Cor_W GFX_W
>          40.96 3.57 3.39   0   9.83   3.36  45.85   0.00   46   46   0.00   0.00   0.00   0.00  27.25  21.27  0.00
>   0   0  37.65 3.67 3.39   0  20.53   3.18  38.64   0.00   46   46   0.00   0.00   0.00   0.00  27.25  21.27  0.00
>   0   4  52.10 3.54 3.39   0   6.08
>   1   1  35.21 3.66 3.39   0  11.45   3.80  49.54   0.00   41
>   1   5  41.99 3.45 3.39   0   4.66
>   2   2  35.46 3.66 3.39   0  10.97   3.60  49.97   0.00   38
>   2   6  41.90 3.48 3.39   0   4.53
>   3   3  39.44 3.69 3.39   0  12.46   2.86  45.24   0.00   41
>   3   7  43.90 3.45 3.39   0   7.99
> 94.876210 sec
> 
> 
> ---------------------------------------------------------------------
> Test WITH this patch:
> 
> Phoronix Test Suite v4.6.0
> 
>     Installed: pts/build-linux-kernel-1.3.0
> 
> System Information
> 
> Hardware:
> Processor: Intel Core i7-3770 @ 3.40GHz (8 Cores), Motherboard: ASUS CM6870, Chipset: Intel Xeon E3-1200 v2/3rd, Memory: 2 x 4096 MB DDR3-1600MHz HY64C1C1624ZY, Disk: 1000GB Seagate ST1000DM003-9YN1, Graphics: NVIDIA GeForce GT 640 3072MB, Audio: Realtek ALC892, Monitor: S23B350, Network: Realtek RTL8111/8168 + Ralink RT3090 Wireless 802.11n 1T/1R
> 
> Software:
> OS: Fedora 18, Kernel: 3.10.0-rc3+ (x86_64), Desktop: KDE 4.10.3, Display Server: X Server 1.13.3, Display Driver: nouveau 1.0.7, File-System: ext4, Screen Resolution: 1920x1080
> 
>     Would you like to save these test results (Y/n): 
> 
> Timed Linux Kernel Compilation 3.1:
>     pts/build-linux-kernel-1.3.0
>     Test 1 of 1
>     Estimated Trial Run Count:    3
>     Estimated Time To Completion: 2 Minutes
>         Running Pre-Test Script @ 22:48:20
>         Started Run 1 @ 22:48:30
>         Running Interim Test Script @ 22:48:44
>         Started Run 2 @ 22:48:47
>         Running Interim Test Script @ 22:48:56
>         Started Run 3 @ 22:49:00
>         Running Interim Test Script @ 22:49:10  [Std. Dev: 4.68%]
>         Started Run 4 @ 22:49:13
>         Running Interim Test Script @ 22:49:23  [Std. Dev: 4.72%]
>         Started Run 5 @ 22:49:26
>         Running Interim Test Script @ 22:49:35  [Std. Dev: 4.25%]
>         Started Run 6 @ 22:49:39  [Std. Dev: 3.98%]
>         Running Post-Test Script @ 22:49:48
> 
>     Test Results:
>         10.205597162247
>         9.2953701019287
>         9.8262219429016
>         9.2547709941864
>         9.4089620113373
>         9.3398430347443
> 
>     Average: 9.56 Seconds
> 
> cor CPU    %c0  GHz  TSC SMI    %c1    %c3    %c6    %c7 CTMP PTMP   %pc2   %pc3   %pc6   %pc7  Pkg_W  Cor_W GFX_W
>          41.50 3.59 3.39   0   9.76   3.10  45.64   0.00   46   46   0.00   0.00   0.00   0.00  27.66  21.69  0.00
>   0   0  35.70 3.66 3.39   0  13.02   3.74  47.55   0.00   46   46   0.00   0.00   0.00   0.00  27.66  21.69  0.00
>   0   4  44.02 3.49 3.39   0   4.69
>   1   1  37.20 3.67 3.39   0  12.29   2.90  47.62   0.00   39
>   1   5  44.49 3.54 3.39   0   4.99
>   2   2  35.62 3.66 3.39   0  20.04   2.53  41.81   0.00   40
>   2   6  52.39 3.55 3.39   0   3.27
>   3   3  37.65 3.67 3.39   0  13.53   3.24  45.58   0.00   40
>   3   7  44.94 3.55 3.39   0   6.25
> 92.544695 sec

OK

The average power drawn by the package is slightly higher with the patchset
applied (27.66 W vs 27.25 W), but since the time needed to complete the
workload with the patchset applied was shorter by about 2.3 sec, the total
energy used was less in the latter case (by about 25.7 J if I'm not mistaken,
or 1% relative).  This means that in the absence of a power limit between
27.25 W and 27.66 W it's better to use the kernel with the patchset applied
for that particular workload from the performance and energy usage perspective.

Good, hopefully that's going to be confirmed on other systems and/or with other
workloads. :-)

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

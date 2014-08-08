Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814AbaHHQ0L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 12:26:11 -0400
Received: from mx4.wp.pl ([212.77.101.11]:46711 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755992AbaHHQ0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 12:26:05 -0400
Date: Fri, 8 Aug 2014 18:25:59 +0200
From: Janek Kozicki <janek_listy@wp.pl>
To: Takashi Iwai <tiwai@suse.de>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        Zhang Rui <rui.zhang@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: 3.16 crashes on resume from Suspend-To-disk, Intel pci_bus
 problem?
Message-ID: <20140808182559.643f3b33@absurd>
In-Reply-To: <s5h4mxo3aot.wl%tiwai@suse.de>
References: <CALGCz1qs2A7BCbcK3vzYRxJeOESVKc7c9kcSpP0NrQFLr1UpUg@mail.gmail.com>
	<20140805115834.5e5e76f0@absurd>
	<20140805190709.2b19c10a@absurd>
	<140743930.1Lg0eFFrXs@vostro.rjw.lan>
	<s5h4mxo3aot.wl%tiwai@suse.de>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
X-Face: $rkfae+2_DGd"-<Fvf,vE7&hL?oJC.uN!6/loh7NMwb/Cs*h!wXg0^+WL;VPwQ0]e0\sPi~63[g*K.:C@jj9zV:L^0&vNyT+aq.9L.0V'8yV%Q/PzmqW{8{/P`>BPR=BhRod2pTifbsp+}LY@O++;u~RqNMBFJgn?R{QHO^@4;?(l5x002ZHJ$zZd~:,H{5E&LV]7X9\7Bw*fl
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAALVBMVEUBAQEtLS1KSkpRUVFXV1dYWFhjY2Nzc3N3d3eHh4eKioqdnZ24uLjLy8vc3NxVIagyAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH2AIVEzgS1fgQtQAAAjRJREFUOMtt1DFv00AUAOAzFQNbjigSyoQaRaBMhKgLUyKXpVNNeUpk9vyDqFJhQ1kiBuaqAwJCqvPtSLY7RlTn5+5IdnYkkt/AOyfxXVLe5vf53Z1875kd34tOEax8djmj6GyjhB5bxz50GdsVZr9fqRjZwAtKOJw5Wqs2MMZ16ALHsaDncF7xAHix1oEFHAB8f+pRjcO4gfZDykcYzbiucRolOLUJ6kjA0xtVt+A6TySlM0RajIpK6DzwKZ/nOYbF/gclHMo1ZOHYY/+Ha+AWuM+3oMS4eeqYzZ8FiCltgUqI8cd2wwAVpJk+8LWYjBtnJdQpHQqJMd4Oxt4bU9ESiFGc5hkqaH74asAX4iabP5I5gZ+qjgGlJCqZa3h3lxhoeVcSE1qLQC4sqKOK9MGW9E3izFqqHokoztLFEgXg31sbZEKnWi2T74A4NxfVQqlkjKtcAWD+zcArFEES01dR0E/nnV0IgugmDd/2L84sOAouRBBHEc7gtc8teDkRlE0iNQPo2w3Xhh/D4TCIQ4LRLoTvgwjj6RRgavdurxYGMaIuGOyAW/PpNlCcU9/93AHenAWYjPoAwa+G3e3to/MgFNTAEKvKDjzuCzHTnY3qqdXtx24VijzQfZ0yewZ5cwRFQaa+mIYr1uI0I76+3W4xhlvoVRwOA0Fdl64HlJnxP6T8YpX/Lga4Wv4A3ErrU5oTfN7Mu/llXMl8RXEPji/lQkN3H7qXqgC2By47EXeU/7PJ/wPxRKMnuZwIeAAAAABJRU5ErkJggg==
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-AV: skaner antywirusowy poczty Wirtualnej Polski S. A.
X-WP-SPAM: NO 0000000 [QfM0]                               
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Full reply, along with CONFIG_PM_TRACE_RTC=y results is below.


Takashi Iwai said:     (by the date of Thu, 07 Aug 2014 11:34:26
+0200)

> At Wed, 06 Aug 2014 01:15 +0200,
> Rafael J. Wysocki wrote:
> > 
> > On Tuesday, August 05, 2014 07:07:09 PM Janek Kozicki wrote:
> > > Rafael J. Wysocki said:     (by the date of Tue, 05 Aug 2014 03:30:58 +0200)
> > > 
> > > > On Monday, August 04, 2014 09:06:52 AM Markus Gutschke wrote:
> > > > > Thanks for checking in. And no, I have not heard from Zhang since my
> > > > > last e-mail. I suspect he is still working on finding a solution. But
> > > > > you are of course right, reverting the patch in the meantime might be
> > > > > a good idea.
> > > > 
> > > > It has too many dependencies.  Besides, reverting it now (at the beginning of
> > > > a merge window) won't be particularly useful anyway.
> > > > 
> > > > We need to fix it.
> > > 
> > > 
> > > Hi, sorry for hijacking this thread, but apparently my other plead
> > > for help got ignored in this very busy mailing list.
> > > 
> > > I have an up-to-date recently installed debian wheezy. I downloaded
> > > https://www.kernel.org/pub/linux/kernel/v3.x/linux-3.16.tar.xz and compiled it using:
> > >   cp /boot/config-`uname -r` ./.config
> > >   make menuconfig
> > >   fakeroot make-kpkg --initrd --append-to-version=-vanilla.1 kernel_image kernel_headers -j38
> > >   dpkg -i linux-image-3.16.0-vanilla.1_3.16.0-vanilla.1-10.00.Custom_amd64.deb linux-headers-3.16.0-vanilla.1_3.16.0-vanilla.1-10.00.Custom_amd64.deb
> > > 
> > > where .config was taken from debian /boot/config-3.14-0.bpo.1-amd64
> > > 
> > > my PC has 64GB of RAM, 32 Xeon E5-2687W cores and motherboard SuperMicro MBD-X9DRI
> > > 
> > > I just did 25 tries of suspend/resume cycle. I tried 4 different
> > > methods of hibernation:
> > > 
> > > 1. /usr/sbin/hibernate                  # 7 successess, 1 failure
> > > 2. /usr/sbin/s2disk                     # 8 successess, 2 failures
> > > 3. echo platform > /sys/power/disk      # 0 successess, 5 failures
> > >    echo disk > /sys/power/state
> > > 4. echo shutdown > /sys/power/disk      # 2 successess, 3 failures
> > >    echo disk > /sys/power/state
> > > 
> > > 
> > > 
> > > The failure was always a reboot after resume had almost succeeded. In
> > > cases when there was a success there was a following ---[cut here]--- part:
> > 
> > This is warning is from _request_firmware() and is triggered by the snd-hda-intel
> > driver (audio).
> > 
> > Why don't you file a bug at bugzilla.kernel.org against hibernation/suspend and
> > put that information into it?
> 
> .... or involve the relevant maintainer :)
> 
> I can't tell exactly because of lack of the whole kernel message, but
> if my guess is correct,  the problem is that the machine has no
> firmware installed.  Usually, the firmware is cached in the firmware
> core code and reused in the resume code path.  If the prior
> request_firmware() failed, however, the succeeding request_firmware()
> at resume will go into the actual f/w loading code, thus it triggers
> such a warning.
> 
> A quick patch below is an untested fix.  Let me know if this really
> fixes the issue.
> 
> 
> thanks,
> 
> Takashi
> 
> ---
> diff --git a/sound/pci/hda/patch_ca0132.c b/sound/pci/hda/patch_ca0132.c
> index 4f3aba78f720..5d8455e2dacd 100644
> --- a/sound/pci/hda/patch_ca0132.c
> +++ b/sound/pci/hda/patch_ca0132.c
> @@ -4376,6 +4376,9 @@ static void ca0132_download_dsp(struct hda_codec *codec)
>  	return; /* NOP */
>  #endif
>  
> +	if (spec->dsp_state == DSP_DOWNLOAD_FAILED)
> +		return; /* don't retry failures */
> +
>  	chipio_enable_clocks(codec);
>  	spec->dsp_state = DSP_DOWNLOADING;
>  	if (!ca0132_download_dsp_images(codec))
> @@ -4552,7 +4555,8 @@ static int ca0132_init(struct hda_codec *codec)
>  	struct auto_pin_cfg *cfg = &spec->autocfg;
>  	int i;
>  
> -	spec->dsp_state = DSP_DOWNLOAD_INIT;
> +	if (spec->dsp_state != DSP_DOWNLOAD_FAILED)
> +		spec->dsp_state = DSP_DOWNLOAD_INIT;
>  	spec->curr_chip_addx = INVALID_CHIP_ADDRESS;
>  
>  	snd_hda_power_up(codec);
> @@ -4663,6 +4667,7 @@ static int patch_ca0132(struct hda_codec *codec)
>  	codec->spec = spec;
>  	spec->codec = codec;
>  
> +	spec->dsp_state = DSP_DOWNLOAD_INIT;
>  	spec->num_mixers = 1;
>  	spec->mixers[0] = ca0132_mixer;
>  
> --


OK, so I did full testing using instructions in both files Rafael suggested:
  Documentation/power/s2ram.txt
  Documentation/power/basic-pm-debugging.txt

Unfortunately the above patch proposed by Takashi didn't work.

I did about a dozen of hibernate/resume attempts, always with:
  /bin/sync
  echo 1 > /sys/power/pm_trace
  echo reboot > /sys/power/disk
  echo disk > /sys/power/state

then after resume failed I recorded following magic number(s) from realtime clock:

[    2.254602] registered taskstats version 1
[    2.256077]   Magic number: 0:670:380
[    2.256080]   hash matches drivers/base/power/main.c:812
[    2.256123] pci_bus 0000:ff: hash matches
[    2.256405] rtc_cmos 00:05: setting system clock to 1980-05-21 12:22:50 UTC (327759770)

[    2.266756]   Magic number: 13:317:739
[    2.266784] pci 0000:ff:0d.1: hash matches
[    2.266831] acpi LNXCPU:68: hash matches
[    2.266846] acpi LNXCPU:3b: hash matches
[    2.267101] rtc_cmos 00:05: setting system clock to 2013-01-01 15:44:17 UTC (1357055057)

[    2.257216]   Magic number: 13:317:739
[    2.257266] pci 0000:ff:0d.1: hash matches
[    2.257302] acpi LNXCPU:68: hash matches
[    2.257324] acpi LNXCPU:3b: hash matches
[    2.257573] rtc_cmos 00:05: setting system clock to 2013-01-01 15:43:44 UTC (1357055024)

[    2.261415]   Magic number: 0:670:380
[    2.261418]   hash matches drivers/base/power/main.c:812
[    2.261462] pci_bus 0000:ff: hash matches
[    2.261725] rtc_cmos 00:05: setting system clock to 1980-05-21 12:22:43 UTC (327759763)

[    2.256938]   Magic number: 0:670:380
[    2.256941]   hash matches drivers/base/power/main.c:812
[    2.256983] pci_bus 0000:ff: hash matches
[    2.257266] rtc_cmos 00:05: setting system clock to 1980-05-21 12:22:43 UTC (327759763)

[    2.265434]   Magic number: 0:670:380
[    2.265438]   hash matches drivers/base/power/main.c:812
[    2.265486] pci_bus 0000:ff: hash matches
[    2.265752] rtc_cmos 00:05: setting system clock to 1980-05-21 12:22:44 UTC (327759764)

[    2.265628]   Magic number: 0:670:380
[    2.265632]   hash matches drivers/base/power/main.c:812
[    2.265683] pci_bus 0000:ff: hash matches
[    2.265980] rtc_cmos 00:05: setting system clock to 1980-05-21 12:22:45 UTC (327759765)

[    2.256348]   Magic number: 0:670:380
[    2.256351]   hash matches drivers/base/power/main.c:812
[    2.256392] pci_bus 0000:ff: hash matches
[    2.256669] rtc_cmos 00:05: setting system clock to 1980-05-21 12:22:43 UTC (327759763)

[    2.266391]   Magic number: 13:317:739
[    2.266437] pci 0000:ff:0d.1: hash matches
[    2.266470] acpi LNXCPU:68: hash matches
[    2.266486] acpi LNXCPU:3b: hash matches
[    2.266720] rtc_cmos 00:05: setting system clock to 2013-01-01 15:43:54 UTC (1357055034)

[    2.266580]   Magic number: 13:317:739
[    2.266625] pci 0000:ff:0d.1: hash matches
[    2.266658] acpi LNXCPU:68: hash matches
[    2.266675] acpi LNXCPU:3b: hash matches
[    2.266898] rtc_cmos 00:05: setting system clock to 2013-01-01 15:43:45 UTC (1357055025)

###############
The info from `cat /sys/power/pm_trace_dev_match` varied between:
  pci
  acpi
  acpi

and just this:
  pci_bus


In case if you need some other info, here's a full dmesg from one of
reboots after a failed resume. But read below this pasted text for
more information.

############### paste start:
Magic number below
this is effect of following:
  /bin/sync
  echo 1 > /sys/power/pm_trace
  echo reboot > /sys/power/disk
  echo disk > /sys/power/state

# cat /sys/power/pm_trace_dev_match
pci
acpi
acpi

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.16.0-vanilla.3+trtc (root@absurd) (gcc version 4.7.2 (Debian 4.7.2-5) ) #2 SMP Fri Aug 8 15:21:04 CEST 2014
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.16.0-vanilla.3+trtc root=UUID=1b1cb5fb-b820-4281-badb-fe60995879cf ro resume=/dev/disk/by-uuid/04e6765a-fe0c-44e7-9165-219563f6171e quiet
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009abff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009ac00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000007df5cfff] usable
[    0.000000] BIOS-e820: [mem 0x000000007df5d000-0x000000007e0c7fff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007e0c8000-0x000000007e2d7fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000007e2d8000-0x000000007f352fff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007f353000-0x000000007f7fffff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000080000000-0x000000008fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed3ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000107fffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: Supermicro X9DR3-F/X9DR3-F, BIOS 3.0a 07/31/2013
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn = 0x1080000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask 3FF000000000 write-back
[    0.000000]   1 base 001000000000 mask 3FFF80000000 write-back
[    0.000000]   2 base 000080000000 mask 3FFF80000000 uncachable
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: update [mem 0x80000000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0x7df5d max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000fdbb0-0x000fdbbf] mapped at [ffff8800000fdbb0]
[    0.000000] Base memory trampoline at [ffff880000093000] 93000 size 28672
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x01a8b000, 0x01a8bfff] PGTABLE
[    0.000000] BRK [0x01a8c000, 0x01a8cfff] PGTABLE
[    0.000000] BRK [0x01a8d000, 0x01a8dfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x107fe00000-0x107fffffff]
[    0.000000]  [mem 0x107fe00000-0x107fffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x107c000000-0x107fdfffff]
[    0.000000]  [mem 0x107c000000-0x107fdfffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x1000000000-0x107bffffff]
[    0.000000]  [mem 0x1000000000-0x107bffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x00100000-0x7df5cfff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x7ddfffff] page 2M
[    0.000000]  [mem 0x7de00000-0x7df5cfff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0xfffffffff]
[    0.000000]  [mem 0x100000000-0xfffffffff] page 1G
[    0.000000] RAMDISK: [mem 0x36350000-0x3719ffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F04A0 000024 (v02 ALASKA)
[    0.000000] ACPI: XSDT 0x000000007E1F0090 00009C (v01 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: FACP 0x000000007E1FD058 00010C (v05 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: DSDT 0x000000007E1F01C0 00CE96 (v02 ALASKA A M I    00000015 INTL 20051117)
[    0.000000] ACPI: FACS 0x000000007E2CF080 000040
[    0.000000] ACPI: APIC 0x000000007E1FD168 000224 (v03 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: FPDT 0x000000007E1FD390 000044 (v01 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: MCFG 0x000000007E1FD3D8 00003C (v01 ALASKA OEMMCFG. 01072009 MSFT 00000097)
[    0.000000] ACPI: SRAT 0x000000007E1FD418 0004B0 (v01 A M I  AMI SRAT 00000001 AMI. 00000000)
[    0.000000] ACPI: SLIT 0x000000007E1FD8C8 000030 (v01 A M I  AMI SLIT 00000000 AMI. 00000000)
[    0.000000] ACPI: HPET 0x000000007E1FD8F8 000038 (v01 ALASKA A M I    01072009 AMI. 00000005)
[    0.000000] ACPI: PRAD 0x000000007E1FD930 0000BE (v02 PRADID PRADTID  00000001 MSFT 03000001)
[    0.000000] ACPI: SPMI 0x000000007E1FD9F0 000040 (v05 A M I  OEMSPMI  00000000 AMI. 00000000)
[    0.000000] ACPI: SSDT 0x000000007E1FDA30 0D0CB0 (v02 INTEL  CpuPm    00004000 INTL 20051117)
[    0.000000] ACPI: EINJ 0x000000007E2CE6E0 000130 (v01 AMI    AMI EINJ 00000000      00000000)
[    0.000000] ACPI: ERST 0x000000007E2CE810 000230 (v01 AMIER  AMI ERST 00000000      00000000)
[    0.000000] ACPI: HEST 0x000000007E2CEA40 0000A8 (v01 AMI    AMI HEST 00000000      00000000)
[    0.000000] ACPI: BERT 0x000000007E2CEAE8 000030 (v01 AMI    AMI BERT 00000000      00000000)
[    0.000000] ACPI: DMAR 0x000000007E2CEB18 000160 (v01 A M I  OEMDMAR  00000001 INTL 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] SRAT: PXM 0 -> APIC 0x02 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x03 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x04 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x05 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x06 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x07 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x08 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x09 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x10 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x11 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x12 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x13 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x14 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x15 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x16 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x17 -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 0x22 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x23 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x24 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x25 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x26 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x27 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x28 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x29 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x30 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x31 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x32 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x33 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x34 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x35 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x36 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x37 -> Node 1
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x00000000-0x7fffffff]
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x100000000-0x87fffffff]
[    0.000000] SRAT: Node 1 PXM 1 [mem 0x880000000-0x107fffffff]
[    0.000000] NUMA: Initialized distance table, cnt=2
[    0.000000] NUMA: Node 0 [mem 0x00000000-0x7fffffff] + [mem 0x100000000-0x87fffffff] -> [mem 0x00000000-0x87fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x87fffffff]
[    0.000000]   NODE_DATA [mem 0x87fffb000-0x87fffffff]
[    0.000000] Initmem setup node 1 [mem 0x880000000-0x107fffffff]
[    0.000000]   NODE_DATA [mem 0x107fff8000-0x107fffcfff]
[    0.000000]  [ffffea0000000000-ffffea001dbfffff] PMD -> [ffff88085fe00000-ffff88087bdfffff] on node 0
[    0.000000]  [ffffea001dc00000-ffffea0039bfffff] PMD -> [ffff88105f600000-ffff88107b5fffff] on node 1
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x107fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x00099fff]
[    0.000000]   node   0: [mem 0x00100000-0x7df5cfff]
[    0.000000]   node   0: [mem 0x100000000-0x87fffffff]
[    0.000000]   node   1: [mem 0x880000000-0x107fffffff]
[    0.000000] On node 0 totalpages: 8380150
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 22 pages reserved
[    0.000000]   DMA zone: 3993 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 6998 pages used for memmap
[    0.000000]   DMA32 zone: 511837 pages, LIFO batch:31
[    0.000000]   Normal zone: 107520 pages used for memmap
[    0.000000]   Normal zone: 7864320 pages, LIFO batch:31
[    0.000000] On node 1 totalpages: 8388608
[    0.000000]   Normal zone: 114688 pages used for memmap
[    0.000000]   Normal zone: 8388608 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x08] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x10] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x12] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x14] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x16] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x22] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x12] lapic_id[0x24] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x14] lapic_id[0x26] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x16] lapic_id[0x28] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x18] lapic_id[0x30] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1a] lapic_id[0x32] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1c] lapic_id[0x34] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1e] lapic_id[0x36] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x09] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x11] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x13] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x15] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x17] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0x23] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x13] lapic_id[0x25] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x15] lapic_id[0x27] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0x29] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x19] lapic_id[0x31] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1b] lapic_id[0x33] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1d] lapic_id[0x35] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1f] lapic_id[0x37] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x08] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0a] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0c] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0e] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x10] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x12] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x14] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x16] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x18] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1a] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1c] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1e] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x09] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0b] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0d] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0f] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x11] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x13] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x15] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x17] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x19] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1b] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1d] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1f] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec01000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 2, version 32, address 0xfec01000, GSI 24-47
[    0.000000] ACPI: IOAPIC (id[0x03] address[0xfec40000] gsi_base[48])
[    0.000000] IOAPIC[2]: apic_id 3, version 32, address 0xfec40000, GSI 48-71
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] smpboot: Allowing 32 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 88
[    0.000000] PM: Registered nosave memory: [mem 0x0009a000-0x0009afff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009b000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x7df5d000-0x7e0c7fff]
[    0.000000] PM: Registered nosave memory: [mem 0x7e0c8000-0x7e2d7fff]
[    0.000000] PM: Registered nosave memory: [mem 0x7e2d8000-0x7f352fff]
[    0.000000] PM: Registered nosave memory: [mem 0x7f353000-0x7f7fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x7f800000-0x7fffffff]
[    0.000000] PM: Registered nosave memory: [mem 0x80000000-0x8fffffff]
[    0.000000] PM: Registered nosave memory: [mem 0x90000000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed3ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed40000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
[    0.000000] e820: [mem 0x90000000-0xfed1bfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:32 nr_node_ids:2
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88087fc00000 s85696 r8192 d20800 u131072
[    0.000000] pcpu-alloc: s85696 r8192 d20800 u131072 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 00 01 02 03 04 05 06 07 16 17 18 19 20 21 22 23 
[    0.000000] pcpu-alloc: [1] 08 09 10 11 12 13 14 15 24 25 26 27 28 29 30 31 
[    0.000000] Built 2 zonelists in Zone order, mobility grouping on.  Total pages: 16539474
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.16.0-vanilla.3+trtc root=UUID=1b1cb5fb-b820-4281-badb-fe60995879cf ro resume=/dev/disk/by-uuid/04e6765a-fe0c-44e7-9165-219563f6171e quiet
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 66061904K/67075032K available (5152K kernel code, 736K rwdata, 1712K rodata, 1004K init, 828K bss, 1013128K reserved)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=32.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=32
[    0.000000] NR_IRQS:33024 nr_irqs:1752 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 268435456 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] mempolicy: Disabling automatic NUMA balancing. Configure with numa_balancing= or the kernel.numa_balancing sysctl
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 3400.211 MHz processor
[    0.000032] Calibrating delay loop (skipped), value calculated using timer frequency.. 6800.42 BogoMIPS (lpj=13600844)
[    0.000034] pid_max: default: 32768 minimum: 301
[    0.000047] ACPI: Core revision 20140424
[    0.037829] ACPI: All ACPI Tables successfully acquired
[    0.038122] Security Framework initialized
[    0.038125] AppArmor: AppArmor disabled by boot time parameter
[    0.038126] Yama: becoming mindful.
[    0.041144] Dentry cache hash table entries: 8388608 (order: 14, 67108864 bytes)
[    0.053414] Inode-cache hash table entries: 4194304 (order: 13, 33554432 bytes)
[    0.058855] Mount-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.058905] Mountpoint-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.059412] Initializing cgroup subsys memory
[    0.059436] Initializing cgroup subsys devices
[    0.059442] Initializing cgroup subsys freezer
[    0.059444] Initializing cgroup subsys net_cls
[    0.059447] Initializing cgroup subsys blkio
[    0.059450] Initializing cgroup subsys perf_event
[    0.059483] CPU: Physical Processor ID: 0
[    0.059483] CPU: Processor Core ID: 1
[    0.060157] mce: CPU supports 27 MCE banks
[    0.060188] CPU0: Thermal monitoring enabled (TM1)
[    0.060213] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 8
[    0.060213] Last level dTLB entries: 4KB 512, 2MB 0, 4MB 0, 1GB 4
[    0.060213] tlb_flushall_shift: 6
[    0.060311] Freeing SMP alternatives memory: 20K (ffffffff819b5000 - ffffffff819ba000)
[    0.061195] dmar: Host address width 46
[    0.061197] dmar: DRHD base: 0x000000fbffe000 flags: 0x0
[    0.061207] dmar: IOMMU 0: reg_base_addr fbffe000 ver 1:0 cap d2078c106f0466 ecap f020de
[    0.061208] dmar: DRHD base: 0x000000dfffc000 flags: 0x1
[    0.061213] dmar: IOMMU 1: reg_base_addr dfffc000 ver 1:0 cap d2078c106f0466 ecap f020de
[    0.061214] dmar: RMRR base: 0x0000007f223000 end: 0x0000007f231fff
[    0.061215] dmar: ATSR flags: 0x0
[    0.061216] dmar: RHSA base: 0x000000fbffe000 proximity domain: 0x1
[    0.061217] dmar: RHSA base: 0x000000dfffc000 proximity domain: 0x0
[    0.061344] IOAPIC id 3 under DRHD base  0xfbffe000 IOMMU 0
[    0.061345] IOAPIC id 0 under DRHD base  0xdfffc000 IOMMU 1
[    0.061346] IOAPIC id 2 under DRHD base  0xdfffc000 IOMMU 1
[    0.061346] HPET id 0 under DRHD base 0xdfffc000
[    0.061347] Queued invalidation will be enabled to support x2apic and Intr-remapping.
[    0.061972] Enabled IRQ remapping in x2apic mode
[    0.061973] Enabling x2apic
[    0.061973] Enabled x2apic
[    0.061977] Switched APIC routing to cluster x2apic.
[    0.062615] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.102277] smpboot: CPU0: Intel(R) Xeon(R) CPU E5-2687W v2 @ 3.40GHz (fam: 06, model: 3e, stepping: 04)
[    0.102285] TSC deadline timer enabled
[    0.102307] Performance Events: PEBS fmt1+, 16-deep LBR, IvyBridge events, full-width counters, Intel PMU driver.
[    0.102323] ... version:                3
[    0.102324] ... bit width:              48
[    0.102324] ... generic registers:      4
[    0.102325] ... value mask:             0000ffffffffffff
[    0.102326] ... max period:             0000ffffffffffff
[    0.102326] ... fixed-purpose events:   3
[    0.102327] ... event mask:             000000070000000f
[    0.103052] x86: Booting SMP configuration:
[    0.103053] .... node  #0, CPUs:        #1
[    0.120033] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.120174]   #2  #3  #4  #5  #6  #7
[    0.203643] .... node  #1, CPUs:    #8  #9 #10 #11 #12 #13 #14 #15
[    0.417933] .... node  #0, CPUs:   #16 #17 #18 #19 #20 #21 #22 #23
[    0.529233] .... node  #1, CPUs:   #24 #25 #26 #27 #28 #29 #30 #31
[    0.645726] x86: Booted up 2 nodes, 32 CPUs
[    0.645729] smpboot: Total of 32 processors activated (217640.16 BogoMIPS)
[    0.699463] devtmpfs: initialized
[    0.699618] memory block size : 2048MB
[    0.701294] PM: Registering ACPI NVS region [mem 0x7e0c8000-0x7e2d7fff] (2162688 bytes)
[    0.701351] PM: Registering ACPI NVS region [mem 0x7f353000-0x7f7fffff] (4902912 bytes)
[    0.701847] pinctrl core: initialized pinctrl subsystem
[    0.701893] RTC time: 15:43:43, date: 01/01/13
[    0.702014] NET: Registered protocol family 16
[    0.702135] cpuidle: using governor ladder
[    0.702137] cpuidle: using governor menu
[    0.702179] ACPI: bus type PCI registered
[    0.702181] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.702338] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0x80000000-0x8fffffff] (base 0x80000000)
[    0.702339] PCI: MMCONFIG at [mem 0x80000000-0x8fffffff] reserved in E820
[    0.702698] PCI: Using configuration type 1 for base access
[    0.727825] ACPI: Added _OSI(Module Device)
[    0.727827] ACPI: Added _OSI(Processor Device)
[    0.727827] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.727828] ACPI: Added _OSI(Processor Aggregator Device)
[    0.737485] ACPI: Executed 1 blocks of module-level executable AML code
[    0.889922] \_SB_:_OSC invalid UUID
[    0.889923] _OSC request data:1 1f 
[    0.893079] ACPI: Interpreter enabled
[    0.893086] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140424/hwxface-580)
[    0.893088] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S3_] (20140424/hwxface-580)
[    0.893095] ACPI: (supports S0 S1 S4 S5)
[    0.893096] ACPI: Using IOAPIC for interrupt routing
[    0.893151] HEST: Table parsing has been initialized.
[    0.893153] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.906368] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-7e])
[    0.906372] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.906480] acpi PNP0A08:00: _OSC: platform does not support [AER]
[    0.906576] acpi PNP0A08:00: _OSC: OS now controls [PCIeHotplug PME PCIeCapability]
[    0.906872] PCI host bridge to bus 0000:00
[    0.906874] pci_bus 0000:00: root bus resource [bus 00-7e]
[    0.906876] pci_bus 0000:00: root bus resource [io  0x0000-0x03af]
[    0.906877] pci_bus 0000:00: root bus resource [io  0x03e0-0x0cf7]
[    0.906878] pci_bus 0000:00: root bus resource [io  0x03b0-0x03df]
[    0.906879] pci_bus 0000:00: root bus resource [io  0x0d00-0x9fff]
[    0.906880] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.906881] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000dffff]
[    0.906882] pci_bus 0000:00: root bus resource [mem 0xfed0e000-0xfed0ffff]
[    0.906883] pci_bus 0000:00: root bus resource [mem 0x80000000-0xdfffffff]
[    0.906892] pci 0000:00:00.0: [8086:0e00] type 00 class 0x060000
[    0.906951] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[    0.907020] pci 0000:00:01.0: [8086:0e02] type 01 class 0x060400
[    0.907088] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.907128] pci 0000:00:01.0: System wakeup disabled by ACPI
[    0.907163] pci 0000:00:01.1: [8086:0e03] type 01 class 0x060400
[    0.907228] pci 0000:00:01.1: PME# supported from D0 D3hot D3cold
[    0.907268] pci 0000:00:01.1: System wakeup disabled by ACPI
[    0.907305] pci 0000:00:02.0: [8086:0e04] type 01 class 0x060400
[    0.907370] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    0.907412] pci 0000:00:02.0: System wakeup disabled by ACPI
[    0.907447] pci 0000:00:03.0: [8086:0e08] type 01 class 0x060400
[    0.907514] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.907555] pci 0000:00:03.0: System wakeup disabled by ACPI
[    0.907591] pci 0000:00:03.2: [8086:0e0a] type 01 class 0x060400
[    0.907656] pci 0000:00:03.2: PME# supported from D0 D3hot D3cold
[    0.907694] pci 0000:00:03.2: System wakeup disabled by ACPI
[    0.907729] pci 0000:00:04.0: [8086:0e20] type 00 class 0x088000
[    0.907742] pci 0000:00:04.0: reg 0x10: [mem 0xdf31c000-0xdf31ffff 64bit]
[    0.907852] pci 0000:00:04.1: [8086:0e21] type 00 class 0x088000
[    0.907865] pci 0000:00:04.1: reg 0x10: [mem 0xdf318000-0xdf31bfff 64bit]
[    0.907975] pci 0000:00:04.2: [8086:0e22] type 00 class 0x088000
[    0.907988] pci 0000:00:04.2: reg 0x10: [mem 0xdf314000-0xdf317fff 64bit]
[    0.908102] pci 0000:00:04.3: [8086:0e23] type 00 class 0x088000
[    0.908114] pci 0000:00:04.3: reg 0x10: [mem 0xdf310000-0xdf313fff 64bit]
[    0.908228] pci 0000:00:04.4: [8086:0e24] type 00 class 0x088000
[    0.908240] pci 0000:00:04.4: reg 0x10: [mem 0xdf30c000-0xdf30ffff 64bit]
[    0.908352] pci 0000:00:04.5: [8086:0e25] type 00 class 0x088000
[    0.908365] pci 0000:00:04.5: reg 0x10: [mem 0xdf308000-0xdf30bfff 64bit]
[    0.908477] pci 0000:00:04.6: [8086:0e26] type 00 class 0x088000
[    0.908489] pci 0000:00:04.6: reg 0x10: [mem 0xdf304000-0xdf307fff 64bit]
[    0.908600] pci 0000:00:04.7: [8086:0e27] type 00 class 0x088000
[    0.908612] pci 0000:00:04.7: reg 0x10: [mem 0xdf300000-0xdf303fff 64bit]
[    0.908722] pci 0000:00:05.0: [8086:0e28] type 00 class 0x088000
[    0.908824] pci 0000:00:05.2: [8086:0e2a] type 00 class 0x088000
[    0.908927] pci 0000:00:05.4: [8086:0e2c] type 00 class 0x080020
[    0.908936] pci 0000:00:05.4: reg 0x10: [mem 0xdf328000-0xdf328fff]
[    0.909059] pci 0000:00:11.0: [8086:1d3e] type 01 class 0x060400
[    0.909152] pci 0000:00:11.0: PME# supported from D0 D3hot D3cold
[    0.909233] pci 0000:00:16.0: [8086:1d3a] type 00 class 0x078000
[    0.909250] pci 0000:00:16.0: reg 0x10: [mem 0xdf327000-0xdf32700f 64bit]
[    0.909306] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.909374] pci 0000:00:16.1: [8086:1d3b] type 00 class 0x078000
[    0.909391] pci 0000:00:16.1: reg 0x10: [mem 0xdf326000-0xdf32600f 64bit]
[    0.909447] pci 0000:00:16.1: PME# supported from D0 D3hot D3cold
[    0.909524] pci 0000:00:1a.0: [8086:1d2d] type 00 class 0x0c0320
[    0.909542] pci 0000:00:1a.0: reg 0x10: [mem 0xdf324000-0xdf3243ff]
[    0.909622] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.909660] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    0.909699] pci 0000:00:1d.0: [8086:1d26] type 00 class 0x0c0320
[    0.909720] pci 0000:00:1d.0: reg 0x10: [mem 0xdf323000-0xdf3233ff]
[    0.909800] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.909839] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.909873] pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
[    0.909947] pci 0000:00:1e.0: System wakeup disabled by ACPI
[    0.909982] pci 0000:00:1f.0: [8086:1d41] type 00 class 0x060100
[    0.910141] pci 0000:00:1f.2: [8086:1d02] type 00 class 0x010601
[    0.910157] pci 0000:00:1f.2: reg 0x10: [io  0x9070-0x9077]
[    0.910163] pci 0000:00:1f.2: reg 0x14: [io  0x9060-0x9063]
[    0.910169] pci 0000:00:1f.2: reg 0x18: [io  0x9050-0x9057]
[    0.910176] pci 0000:00:1f.2: reg 0x1c: [io  0x9040-0x9043]
[    0.910182] pci 0000:00:1f.2: reg 0x20: [io  0x9020-0x903f]
[    0.910189] pci 0000:00:1f.2: reg 0x24: [mem 0xdf322000-0xdf3227ff]
[    0.910227] pci 0000:00:1f.2: PME# supported from D3hot
[    0.910294] pci 0000:00:1f.3: [8086:1d22] type 00 class 0x0c0500
[    0.910306] pci 0000:00:1f.3: reg 0x10: [mem 0xdf321000-0xdf3210ff 64bit]
[    0.910324] pci 0000:00:1f.3: reg 0x20: [io  0x9000-0x901f]
[    0.910401] pci 0000:00:1f.6: [8086:1d24] type 00 class 0x118000
[    0.910419] pci 0000:00:1f.6: reg 0x10: [mem 0xdf320000-0xdf320fff 64bit]
[    0.910579] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.910653] pci 0000:02:00.0: [8086:1521] type 00 class 0x020000
[    0.910662] pci 0000:02:00.0: reg 0x10: [mem 0xdf220000-0xdf23ffff]
[    0.910674] pci 0000:02:00.0: reg 0x18: [io  0x8020-0x803f]
[    0.910681] pci 0000:02:00.0: reg 0x1c: [mem 0xdf244000-0xdf247fff]
[    0.910739] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    0.910766] pci 0000:02:00.0: reg 0x184: [mem 0xdaa60000-0xdaa63fff 64bit pref]
[    0.910777] pci 0000:02:00.0: reg 0x190: [mem 0xdaa40000-0xdaa43fff 64bit pref]
[    0.910829] pci 0000:02:00.1: [8086:1521] type 00 class 0x020000
[    0.910839] pci 0000:02:00.1: reg 0x10: [mem 0xdf200000-0xdf21ffff]
[    0.910849] pci 0000:02:00.1: reg 0x18: [io  0x8000-0x801f]
[    0.910855] pci 0000:02:00.1: reg 0x1c: [mem 0xdf240000-0xdf243fff]
[    0.910915] pci 0000:02:00.1: PME# supported from D0 D3hot D3cold
[    0.910938] pci 0000:02:00.1: reg 0x184: [mem 0xdaa20000-0xdaa23fff 64bit pref]
[    0.910950] pci 0000:02:00.1: reg 0x190: [mem 0xdaa00000-0xdaa03fff 64bit pref]
[    0.911099] pci 0000:00:01.1: PCI bridge to [bus 02-03]
[    0.911101] pci 0000:00:01.1:   bridge window [io  0x8000-0x8fff]
[    0.911104] pci 0000:00:01.1:   bridge window [mem 0xdf200000-0xdf2fffff]
[    0.911108] pci 0000:00:01.1:   bridge window [mem 0xdaa00000-0xdaafffff 64bit pref]
[    0.911164] pci 0000:04:00.0: [10de:1004] type 00 class 0x030000
[    0.911173] pci 0000:04:00.0: reg 0x10: [mem 0xde000000-0xdeffffff]
[    0.911181] pci 0000:04:00.0: reg 0x14: [mem 0xd0000000-0xd7ffffff 64bit pref]
[    0.911190] pci 0000:04:00.0: reg 0x1c: [mem 0xd8000000-0xd9ffffff 64bit pref]
[    0.911195] pci 0000:04:00.0: reg 0x24: [io  0x7000-0x707f]
[    0.911201] pci 0000:04:00.0: reg 0x30: [mem 0xdf000000-0xdf07ffff pref]
[    0.911278] pci 0000:04:00.1: [10de:0e1a] type 00 class 0x040300
[    0.911287] pci 0000:04:00.1: reg 0x10: [mem 0xdf080000-0xdf083fff]
[    0.917746] pci 0000:00:02.0: PCI bridge to [bus 04]
[    0.917752] pci 0000:00:02.0:   bridge window [io  0x7000-0x7fff]
[    0.917768] pci 0000:00:02.0:   bridge window [mem 0xde000000-0xdf0fffff]
[    0.917773] pci 0000:00:02.0:   bridge window [mem 0xd0000000-0xd9ffffff 64bit pref]
[    0.917819] pci 0000:00:03.0: PCI bridge to [bus 05]
[    0.917867] pci 0000:00:03.2: PCI bridge to [bus 06]
[    0.917946] pci 0000:07:00.0: [8086:1d6b] type 00 class 0x010700
[    0.917965] pci 0000:07:00.0: reg 0x10: [mem 0xda87c000-0xda87ffff 64bit pref]
[    0.917978] pci 0000:07:00.0: reg 0x18: [mem 0xda400000-0xda7fffff 64bit pref]
[    0.917988] pci 0000:07:00.0: reg 0x20: [io  0x6000-0x60ff]
[    0.918093] pci 0000:07:00.0: reg 0x164: [mem 0xda800000-0xda803fff 64bit pref]
[    0.918174] pci 0000:00:11.0: PCI bridge to [bus 07]
[    0.918178] pci 0000:00:11.0:   bridge window [io  0x6000-0x6fff]
[    0.918182] pci 0000:00:11.0:   bridge window [mem 0xdf100000-0xdf1fffff]
[    0.918188] pci 0000:00:11.0:   bridge window [mem 0xda400000-0xda8fffff 64bit pref]
[    0.918253] pci 0000:00:1e.0: PCI bridge to [bus 08] (subtractive decode)
[    0.918262] pci 0000:00:1e.0:   bridge window [io  0x0000-0x03af] (subtractive decode)
[    0.918264] pci 0000:00:1e.0:   bridge window [io  0x03e0-0x0cf7] (subtractive decode)
[    0.918266] pci 0000:00:1e.0:   bridge window [io  0x03b0-0x03df] (subtractive decode)
[    0.918268] pci 0000:00:1e.0:   bridge window [io  0x0d00-0x9fff] (subtractive decode)
[    0.918269] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.918270] pci 0000:00:1e.0:   bridge window [mem 0x000c0000-0x000dffff] (subtractive decode)
[    0.918271] pci 0000:00:1e.0:   bridge window [mem 0xfed0e000-0xfed0ffff] (subtractive decode)
[    0.918272] pci 0000:00:1e.0:   bridge window [mem 0x80000000-0xdfffffff] (subtractive decode)
[    0.918304] pci_bus 0000:00: on NUMA node 0
[    0.918638] ACPI: PCI Root Bridge [UNC0] (domain 0000 [bus 7f])
[    0.918641] acpi PNP0A03:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.918658] acpi PNP0A03:00: _OSC: OS now controls [PCIeHotplug PME AER PCIeCapability]
[    0.918704] PCI host bridge to bus 0000:7f
[    0.918706] pci_bus 0000:7f: root bus resource [bus 7f]
[    0.918712] pci 0000:7f:08.0: [8086:0e80] type 00 class 0x088000
[    0.918755] pci 0000:7f:09.0: [8086:0e90] type 00 class 0x088000
[    0.918797] pci 0000:7f:0a.0: [8086:0ec0] type 00 class 0x088000
[    0.918836] pci 0000:7f:0a.1: [8086:0ec1] type 00 class 0x088000
[    0.918871] pci 0000:7f:0a.2: [8086:0ec2] type 00 class 0x088000
[    0.918913] pci 0000:7f:0a.3: [8086:0ec3] type 00 class 0x088000
[    0.918948] pci 0000:7f:0b.0: [8086:0e1e] type 00 class 0x088000
[    0.918984] pci 0000:7f:0b.3: [8086:0e1f] type 00 class 0x088000
[    0.919019] pci 0000:7f:0c.0: [8086:0ee0] type 00 class 0x088000
[    0.919056] pci 0000:7f:0c.1: [8086:0ee2] type 00 class 0x088000
[    0.919089] pci 0000:7f:0c.2: [8086:0ee4] type 00 class 0x088000
[    0.919122] pci 0000:7f:0c.3: [8086:0ee6] type 00 class 0x088000
[    0.919154] pci 0000:7f:0c.4: [8086:0ee8] type 00 class 0x088000
[    0.919188] pci 0000:7f:0d.0: [8086:0ee1] type 00 class 0x088000
[    0.919220] pci 0000:7f:0d.1: [8086:0ee3] type 00 class 0x088000
[    0.919255] pci 0000:7f:0d.2: [8086:0ee5] type 00 class 0x088000
[    0.919286] pci 0000:7f:0d.3: [8086:0ee7] type 00 class 0x088000
[    0.919319] pci 0000:7f:0d.4: [8086:0ee9] type 00 class 0x088000
[    0.919352] pci 0000:7f:0e.0: [8086:0ea0] type 00 class 0x088000
[    0.919393] pci 0000:7f:0e.1: [8086:0e30] type 00 class 0x110100
[    0.919431] pci 0000:7f:0f.0: [8086:0ea8] type 00 class 0x088000
[    0.919478] pci 0000:7f:0f.1: [8086:0e71] type 00 class 0x088000
[    0.919526] pci 0000:7f:0f.2: [8086:0eaa] type 00 class 0x088000
[    0.919572] pci 0000:7f:0f.3: [8086:0eab] type 00 class 0x088000
[    0.919616] pci 0000:7f:0f.4: [8086:0eac] type 00 class 0x088000
[    0.919660] pci 0000:7f:0f.5: [8086:0ead] type 00 class 0x088000
[    0.919704] pci 0000:7f:10.0: [8086:0eb0] type 00 class 0x088000
[    0.919749] pci 0000:7f:10.1: [8086:0eb1] type 00 class 0x088000
[    0.919794] pci 0000:7f:10.2: [8086:0eb2] type 00 class 0x088000
[    0.919837] pci 0000:7f:10.3: [8086:0eb3] type 00 class 0x088000
[    0.919884] pci 0000:7f:10.4: [8086:0eb4] type 00 class 0x088000
[    0.919933] pci 0000:7f:10.5: [8086:0eb5] type 00 class 0x088000
[    0.919982] pci 0000:7f:10.6: [8086:0eb6] type 00 class 0x088000
[    0.920035] pci 0000:7f:10.7: [8086:0eb7] type 00 class 0x088000
[    0.920082] pci 0000:7f:13.0: [8086:0e1d] type 00 class 0x088000
[    0.920117] pci 0000:7f:13.1: [8086:0e34] type 00 class 0x110100
[    0.920152] pci 0000:7f:13.4: [8086:0e81] type 00 class 0x088000
[    0.920190] pci 0000:7f:13.5: [8086:0e36] type 00 class 0x110100
[    0.920226] pci 0000:7f:16.0: [8086:0ec8] type 00 class 0x088000
[    0.920264] pci 0000:7f:16.1: [8086:0ec9] type 00 class 0x088000
[    0.920299] pci 0000:7f:16.2: [8086:0eca] type 00 class 0x088000
[    0.920342] pci_bus 0000:7f: on NUMA node 0
[    0.920431] ACPI: PCI Root Bridge [PCI1] (domain 0000 [bus 80-fe])
[    0.920433] acpi PNP0A08:01: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.920537] acpi PNP0A08:01: _OSC: platform does not support [AER]
[    0.920631] acpi PNP0A08:01: _OSC: OS now controls [PCIeHotplug PME PCIeCapability]
[    0.920821] PCI host bridge to bus 0000:80
[    0.920823] pci_bus 0000:80: root bus resource [bus 80-fe]
[    0.920824] pci_bus 0000:80: root bus resource [io  0xa000-0xffff]
[    0.920825] pci_bus 0000:80: root bus resource [mem 0xe0000000-0xfbffffff]
[    0.920837] pci 0000:80:01.0: [8086:0e02] type 01 class 0x060400
[    0.920913] pci 0000:80:01.0: PME# supported from D0 D3hot D3cold
[    0.920944] pci 0000:80:01.0: System wakeup disabled by ACPI
[    0.920985] pci 0000:80:02.0: [8086:0e04] type 01 class 0x060400
[    0.921060] pci 0000:80:02.0: PME# supported from D0 D3hot D3cold
[    0.921089] pci 0000:80:02.0: System wakeup disabled by ACPI
[    0.921128] pci 0000:80:03.0: [8086:0e08] type 01 class 0x060400
[    0.921205] pci 0000:80:03.0: PME# supported from D0 D3hot D3cold
[    0.921234] pci 0000:80:03.0: System wakeup disabled by ACPI
[    0.921272] pci 0000:80:04.0: [8086:0e20] type 00 class 0x088000
[    0.921287] pci 0000:80:04.0: reg 0x10: [mem 0xfbf1c000-0xfbf1ffff 64bit]
[    0.921393] pci 0000:80:04.1: [8086:0e21] type 00 class 0x088000
[    0.921407] pci 0000:80:04.1: reg 0x10: [mem 0xfbf18000-0xfbf1bfff 64bit]
[    0.921519] pci 0000:80:04.2: [8086:0e22] type 00 class 0x088000
[    0.921533] pci 0000:80:04.2: reg 0x10: [mem 0xfbf14000-0xfbf17fff 64bit]
[    0.921644] pci 0000:80:04.3: [8086:0e23] type 00 class 0x088000
[    0.921658] pci 0000:80:04.3: reg 0x10: [mem 0xfbf10000-0xfbf13fff 64bit]
[    0.921776] pci 0000:80:04.4: [8086:0e24] type 00 class 0x088000
[    0.921790] pci 0000:80:04.4: reg 0x10: [mem 0xfbf0c000-0xfbf0ffff 64bit]
[    0.921903] pci 0000:80:04.5: [8086:0e25] type 00 class 0x088000
[    0.921916] pci 0000:80:04.5: reg 0x10: [mem 0xfbf08000-0xfbf0bfff 64bit]
[    0.922029] pci 0000:80:04.6: [8086:0e26] type 00 class 0x088000
[    0.922043] pci 0000:80:04.6: reg 0x10: [mem 0xfbf04000-0xfbf07fff 64bit]
[    0.922154] pci 0000:80:04.7: [8086:0e27] type 00 class 0x088000
[    0.922168] pci 0000:80:04.7: reg 0x10: [mem 0xfbf00000-0xfbf03fff 64bit]
[    0.922281] pci 0000:80:05.0: [8086:0e28] type 00 class 0x088000
[    0.922377] pci 0000:80:05.2: [8086:0e2a] type 00 class 0x088000
[    0.922472] pci 0000:80:05.4: [8086:0e2c] type 00 class 0x080020
[    0.922482] pci 0000:80:05.4: reg 0x10: [mem 0xfbf20000-0xfbf20fff]
[    0.922639] pci 0000:80:01.0: PCI bridge to [bus 81]
[    0.922692] pci 0000:80:02.0: PCI bridge to [bus 82]
[    0.922757] pci 0000:83:00.0: [1102:0012] type 00 class 0x040300
[    0.922773] pci 0000:83:00.0: reg 0x10: [mem 0xfbe04000-0xfbe07fff 64bit]
[    0.922784] pci 0000:83:00.0: reg 0x18: [mem 0xfbe00000-0xfbe03fff 64bit]
[    0.922849] pci 0000:83:00.0: supports D2
[    0.922996] pci 0000:80:03.0: PCI bridge to [bus 83]
[    0.923000] pci 0000:80:03.0:   bridge window [mem 0xfbe00000-0xfbefffff]
[    0.923026] pci_bus 0000:80: on NUMA node 1
[    0.923077] ACPI: PCI Root Bridge [UNC1] (domain 0000 [bus ff])
[    0.923079] acpi PNP0A03:01: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.923095] acpi PNP0A03:01: _OSC: OS now controls [PCIeHotplug PME AER PCIeCapability]
[    0.923140] PCI host bridge to bus 0000:ff
[    0.923142] pci_bus 0000:ff: root bus resource [bus ff]
[    0.923148] pci 0000:ff:08.0: [8086:0e80] type 00 class 0x088000
[    0.923196] pci 0000:ff:09.0: [8086:0e90] type 00 class 0x088000
[    0.923247] pci 0000:ff:0a.0: [8086:0ec0] type 00 class 0x088000
[    0.923288] pci 0000:ff:0a.1: [8086:0ec1] type 00 class 0x088000
[    0.923329] pci 0000:ff:0a.2: [8086:0ec2] type 00 class 0x088000
[    0.923369] pci 0000:ff:0a.3: [8086:0ec3] type 00 class 0x088000
[    0.923412] pci 0000:ff:0b.0: [8086:0e1e] type 00 class 0x088000
[    0.923453] pci 0000:ff:0b.3: [8086:0e1f] type 00 class 0x088000
[    0.923494] pci 0000:ff:0c.0: [8086:0ee0] type 00 class 0x088000
[    0.923536] pci 0000:ff:0c.1: [8086:0ee2] type 00 class 0x088000
[    0.923576] pci 0000:ff:0c.2: [8086:0ee4] type 00 class 0x088000
[    0.923618] pci 0000:ff:0c.3: [8086:0ee6] type 00 class 0x088000
[    0.923657] pci 0000:ff:0c.4: [8086:0ee8] type 00 class 0x088000
[    0.923700] pci 0000:ff:0d.0: [8086:0ee1] type 00 class 0x088000
[    0.923740] pci 0000:ff:0d.1: [8086:0ee3] type 00 class 0x088000
[    0.923786] pci 0000:ff:0d.2: [8086:0ee5] type 00 class 0x088000
[    0.923825] pci 0000:ff:0d.3: [8086:0ee7] type 00 class 0x088000
[    0.923866] pci 0000:ff:0d.4: [8086:0ee9] type 00 class 0x088000
[    0.923907] pci 0000:ff:0e.0: [8086:0ea0] type 00 class 0x088000
[    0.923958] pci 0000:ff:0e.1: [8086:0e30] type 00 class 0x110100
[    0.924012] pci 0000:ff:0f.0: [8086:0ea8] type 00 class 0x088000
[    0.924071] pci 0000:ff:0f.1: [8086:0e71] type 00 class 0x088000
[    0.924131] pci 0000:ff:0f.2: [8086:0eaa] type 00 class 0x088000
[    0.924187] pci 0000:ff:0f.3: [8086:0eab] type 00 class 0x088000
[    0.924244] pci 0000:ff:0f.4: [8086:0eac] type 00 class 0x088000
[    0.924305] pci 0000:ff:0f.5: [8086:0ead] type 00 class 0x088000
[    0.924368] pci 0000:ff:10.0: [8086:0eb0] type 00 class 0x088000
[    0.924428] pci 0000:ff:10.1: [8086:0eb1] type 00 class 0x088000
[    0.924487] pci 0000:ff:10.2: [8086:0eb2] type 00 class 0x088000
[    0.924546] pci 0000:ff:10.3: [8086:0eb3] type 00 class 0x088000
[    0.924601] pci 0000:ff:10.4: [8086:0eb4] type 00 class 0x088000
[    0.924661] pci 0000:ff:10.5: [8086:0eb5] type 00 class 0x088000
[    0.924716] pci 0000:ff:10.6: [8086:0eb6] type 00 class 0x088000
[    0.924775] pci 0000:ff:10.7: [8086:0eb7] type 00 class 0x088000
[    0.924832] pci 0000:ff:13.0: [8086:0e1d] type 00 class 0x088000
[    0.924875] pci 0000:ff:13.1: [8086:0e34] type 00 class 0x110100
[    0.924920] pci 0000:ff:13.4: [8086:0e81] type 00 class 0x088000
[    0.924962] pci 0000:ff:13.5: [8086:0e36] type 00 class 0x110100
[    0.925009] pci 0000:ff:16.0: [8086:0ec8] type 00 class 0x088000
[    0.925053] pci 0000:ff:16.1: [8086:0ec9] type 00 class 0x088000
[    0.925099] pci 0000:ff:16.2: [8086:0eca] type 00 class 0x088000
[    0.925149] pci_bus 0000:ff: on NUMA node 1
[    0.925205] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.925244] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.925278] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 10 11 12 14 15)
[    0.925312] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.925345] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0
[    0.925380] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0
[    0.925414] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0
[    0.925447] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 *7 10 11 12 14 15)
[    0.927356] ACPI: Enabled 4 GPEs in block 00 to 3F
[    0.927508] vgaarb: device added: PCI:0000:04:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.927532] vgaarb: loaded
[    0.927532] vgaarb: bridge control possible 0000:04:00.0
[    0.927592] PCI: Using ACPI for IRQ routing
[    0.931483] PCI: pci_cache_line_size set to 64 bytes
[    0.931634] e820: reserve RAM buffer [mem 0x0009ac00-0x0009ffff]
[    0.931636] e820: reserve RAM buffer [mem 0x7df5d000-0x7fffffff]
[    0.931767] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.931770] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.934895] Switched to clocksource hpet
[    0.937027] pnp: PnP ACPI init
[    0.937047] ACPI: bus type PNP registered
[    0.937221] system 00:00: [mem 0xfc000000-0xfcffffff] has been reserved
[    0.937223] system 00:00: [mem 0xfd000000-0xfdffffff] has been reserved
[    0.937224] system 00:00: [mem 0xfe000000-0xfeafffff] has been reserved
[    0.937226] system 00:00: [mem 0xfeb00000-0xfebfffff] has been reserved
[    0.937228] system 00:00: [mem 0xfed00400-0xfed3ffff] could not be reserved
[    0.937229] system 00:00: [mem 0xfed45000-0xfedfffff] has been reserved
[    0.937232] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.937347] system 00:01: [mem 0xdfffc000-0xdfffdfff] could not be reserved
[    0.937348] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.937502] system 00:02: [io  0x0a00-0x0a7f] has been reserved
[    0.937504] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.937618] pnp 00:03: [dma 0 disabled]
[    0.937665] pnp 00:03: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.937940] pnp 00:04: [dma 0 disabled]
[    0.937995] pnp 00:04: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.938046] pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.938125] system 00:06: [io  0x04d0-0x04d1] has been reserved
[    0.938127] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.938241] pnp 00:07: Plug and Play ACPI device, IDs IPI0001 (active)
[    0.938406] system 00:08: [io  0x0400-0x0453] could not be reserved
[    0.938407] system 00:08: [io  0x0458-0x047f] has been reserved
[    0.938409] system 00:08: [io  0x1180-0x119f] has been reserved
[    0.938410] system 00:08: [io  0x0500-0x057f] has been reserved
[    0.938412] system 00:08: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.938413] system 00:08: [mem 0xfec00000-0xfecfffff] could not be reserved
[    0.938415] system 00:08: [mem 0xfed08000-0xfed08fff] has been reserved
[    0.938416] system 00:08: [mem 0xff000000-0xffffffff] has been reserved
[    0.938418] system 00:08: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.938492] system 00:09: [io  0x0454-0x0457] has been reserved
[    0.938493] system 00:09: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[    0.938656] system 00:0a: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.938733] system 00:0b: [mem 0xfbffe000-0xfbffffff] could not be reserved
[    0.938734] system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.939149] pnp: PnP ACPI: found 12 devices
[    0.939150] ACPI: bus type PNP unregistered
[    0.945562] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.945572] pci 0000:00:01.1: PCI bridge to [bus 02-03]
[    0.945574] pci 0000:00:01.1:   bridge window [io  0x8000-0x8fff]
[    0.945577] pci 0000:00:01.1:   bridge window [mem 0xdf200000-0xdf2fffff]
[    0.945580] pci 0000:00:01.1:   bridge window [mem 0xdaa00000-0xdaafffff 64bit pref]
[    0.945585] pci 0000:00:02.0: PCI bridge to [bus 04]
[    0.945587] pci 0000:00:02.0:   bridge window [io  0x7000-0x7fff]
[    0.945590] pci 0000:00:02.0:   bridge window [mem 0xde000000-0xdf0fffff]
[    0.945593] pci 0000:00:02.0:   bridge window [mem 0xd0000000-0xd9ffffff 64bit pref]
[    0.945598] pci 0000:00:03.0: PCI bridge to [bus 05]
[    0.945606] pci 0000:00:03.2: PCI bridge to [bus 06]
[    0.945615] pci 0000:00:11.0: PCI bridge to [bus 07]
[    0.945617] pci 0000:00:11.0:   bridge window [io  0x6000-0x6fff]
[    0.945622] pci 0000:00:11.0:   bridge window [mem 0xdf100000-0xdf1fffff]
[    0.945626] pci 0000:00:11.0:   bridge window [mem 0xda400000-0xda8fffff 64bit pref]
[    0.945632] pci 0000:00:1e.0: PCI bridge to [bus 08]
[    0.945642] pci_bus 0000:00: resource 4 [io  0x0000-0x03af]
[    0.945643] pci_bus 0000:00: resource 5 [io  0x03e0-0x0cf7]
[    0.945644] pci_bus 0000:00: resource 6 [io  0x03b0-0x03df]
[    0.945645] pci_bus 0000:00: resource 7 [io  0x0d00-0x9fff]
[    0.945646] pci_bus 0000:00: resource 8 [mem 0x000a0000-0x000bffff]
[    0.945647] pci_bus 0000:00: resource 9 [mem 0x000c0000-0x000dffff]
[    0.945649] pci_bus 0000:00: resource 10 [mem 0xfed0e000-0xfed0ffff]
[    0.945650] pci_bus 0000:00: resource 11 [mem 0x80000000-0xdfffffff]
[    0.945651] pci_bus 0000:02: resource 0 [io  0x8000-0x8fff]
[    0.945652] pci_bus 0000:02: resource 1 [mem 0xdf200000-0xdf2fffff]
[    0.945653] pci_bus 0000:02: resource 2 [mem 0xdaa00000-0xdaafffff 64bit pref]
[    0.945655] pci_bus 0000:04: resource 0 [io  0x7000-0x7fff]
[    0.945656] pci_bus 0000:04: resource 1 [mem 0xde000000-0xdf0fffff]
[    0.945657] pci_bus 0000:04: resource 2 [mem 0xd0000000-0xd9ffffff 64bit pref]
[    0.945658] pci_bus 0000:07: resource 0 [io  0x6000-0x6fff]
[    0.945659] pci_bus 0000:07: resource 1 [mem 0xdf100000-0xdf1fffff]
[    0.945660] pci_bus 0000:07: resource 2 [mem 0xda400000-0xda8fffff 64bit pref]
[    0.945662] pci_bus 0000:08: resource 4 [io  0x0000-0x03af]
[    0.945663] pci_bus 0000:08: resource 5 [io  0x03e0-0x0cf7]
[    0.945664] pci_bus 0000:08: resource 6 [io  0x03b0-0x03df]
[    0.945665] pci_bus 0000:08: resource 7 [io  0x0d00-0x9fff]
[    0.945666] pci_bus 0000:08: resource 8 [mem 0x000a0000-0x000bffff]
[    0.945667] pci_bus 0000:08: resource 9 [mem 0x000c0000-0x000dffff]
[    0.945668] pci_bus 0000:08: resource 10 [mem 0xfed0e000-0xfed0ffff]
[    0.945669] pci_bus 0000:08: resource 11 [mem 0x80000000-0xdfffffff]
[    0.945689] pci 0000:80:01.0: PCI bridge to [bus 81]
[    0.945697] pci 0000:80:02.0: PCI bridge to [bus 82]
[    0.945705] pci 0000:80:03.0: PCI bridge to [bus 83]
[    0.945708] pci 0000:80:03.0:   bridge window [mem 0xfbe00000-0xfbefffff]
[    0.945714] pci_bus 0000:80: resource 4 [io  0xa000-0xffff]
[    0.945715] pci_bus 0000:80: resource 5 [mem 0xe0000000-0xfbffffff]
[    0.945716] pci_bus 0000:83: resource 1 [mem 0xfbe00000-0xfbefffff]
[    0.945989] NET: Registered protocol family 2
[    0.946853] TCP established hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.947506] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.947661] TCP: Hash tables configured (established 524288 bind 65536)
[    0.947689] TCP: reno registered
[    0.947742] UDP hash table entries: 32768 (order: 8, 1048576 bytes)
[    0.947930] UDP-Lite hash table entries: 32768 (order: 8, 1048576 bytes)
[    0.948351] NET: Registered protocol family 1
[    0.986924] pci 0000:04:00.0: Boot video device
[    0.987023] PCI: CLS 64 bytes, default 64
[    0.987079] Unpacking initramfs...
[    1.182109] Freeing initrd memory: 14656K (ffff880036350000 - ffff8800371a0000)
[    1.182489] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    1.182491] software IO TLB [mem 0x79f5d000-0x7df5d000] (64MB) mapped at [ffff880079f5d000-ffff88007df5cfff]
[    1.184461] RAPL PMU detected, hw unit 2^-16 Joules, API unit is 2^-32 Joules, 3 fixed counters 163840 ms ovfl timer
[    1.184581] microcode: CPU0 sig=0x306e4, pf=0x1, revision=0x416
[    1.184594] microcode: CPU1 sig=0x306e4, pf=0x1, revision=0x416
[    1.184608] microcode: CPU2 sig=0x306e4, pf=0x1, revision=0x416
[    1.184630] microcode: CPU3 sig=0x306e4, pf=0x1, revision=0x416
[    1.184637] microcode: CPU4 sig=0x306e4, pf=0x1, revision=0x416
[    1.184644] microcode: CPU5 sig=0x306e4, pf=0x1, revision=0x416
[    1.184651] microcode: CPU6 sig=0x306e4, pf=0x1, revision=0x416
[    1.184658] microcode: CPU7 sig=0x306e4, pf=0x1, revision=0x416
[    1.184665] microcode: CPU8 sig=0x306e4, pf=0x1, revision=0x416
[    1.184672] microcode: CPU9 sig=0x306e4, pf=0x1, revision=0x416
[    1.184676] microcode: CPU10 sig=0x306e4, pf=0x1, revision=0x416
[    1.184691] microcode: CPU11 sig=0x306e4, pf=0x1, revision=0x416
[    1.184698] microcode: CPU12 sig=0x306e4, pf=0x1, revision=0x416
[    1.184704] microcode: CPU13 sig=0x306e4, pf=0x1, revision=0x416
[    1.184711] microcode: CPU14 sig=0x306e4, pf=0x1, revision=0x416
[    1.184718] microcode: CPU15 sig=0x306e4, pf=0x1, revision=0x416
[    1.184727] microcode: CPU16 sig=0x306e4, pf=0x1, revision=0x416
[    1.184737] microcode: CPU17 sig=0x306e4, pf=0x1, revision=0x416
[    1.184749] microcode: CPU18 sig=0x306e4, pf=0x1, revision=0x416
[    1.184760] microcode: CPU19 sig=0x306e4, pf=0x1, revision=0x416
[    1.184782] microcode: CPU20 sig=0x306e4, pf=0x1, revision=0x416
[    1.184788] microcode: CPU21 sig=0x306e4, pf=0x1, revision=0x416
[    1.184793] microcode: CPU22 sig=0x306e4, pf=0x1, revision=0x416
[    1.184799] microcode: CPU23 sig=0x306e4, pf=0x1, revision=0x416
[    1.184805] microcode: CPU24 sig=0x306e4, pf=0x1, revision=0x416
[    1.184810] microcode: CPU25 sig=0x306e4, pf=0x1, revision=0x416
[    1.184816] microcode: CPU26 sig=0x306e4, pf=0x1, revision=0x416
[    1.184822] microcode: CPU27 sig=0x306e4, pf=0x1, revision=0x416
[    1.184837] microcode: CPU28 sig=0x306e4, pf=0x1, revision=0x416
[    1.184843] microcode: CPU29 sig=0x306e4, pf=0x1, revision=0x416
[    1.184848] microcode: CPU30 sig=0x306e4, pf=0x1, revision=0x416
[    1.184854] microcode: CPU31 sig=0x306e4, pf=0x1, revision=0x416
[    1.184903] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    1.185508] futex hash table entries: 8192 (order: 7, 524288 bytes)
[    1.185647] audit: initializing netlink subsys (disabled)
[    1.185675] audit: type=2000 audit(1357055024.048:1): initialized
[    1.186565] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.187206] VFS: Disk quotas dquot_6.5.2
[    1.187270] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.187392] msgmni has been set to 32768
[    1.187780] alg: No test for stdrng (krng)
[    1.187871] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    1.188012] io scheduler noop registered
[    1.188014] io scheduler deadline registered
[    1.188132] io scheduler cfq registered (default)
[    1.188463] pcieport 0000:00:01.0: irq 90 for MSI/MSI-X
[    1.188671] pcieport 0000:00:01.1: irq 91 for MSI/MSI-X
[    1.188877] pcieport 0000:00:02.0: irq 92 for MSI/MSI-X
[    1.189080] pcieport 0000:00:03.0: irq 93 for MSI/MSI-X
[    1.189276] pcieport 0000:00:03.2: irq 94 for MSI/MSI-X
[    1.189476] pcieport 0000:00:11.0: irq 95 for MSI/MSI-X
[    1.189718] pcieport 0000:80:01.0: irq 96 for MSI/MSI-X
[    1.189839] pcieport 0000:80:02.0: irq 97 for MSI/MSI-X
[    1.189950] pcieport 0000:80:03.0: irq 98 for MSI/MSI-X
[    1.190044] pcieport 0000:00:01.0: Signaling PME through PCIe PME interrupt
[    1.190047] pcie_pme 0000:00:01.0:pcie01: service driver pcie_pme loaded
[    1.190067] pcieport 0000:00:01.1: Signaling PME through PCIe PME interrupt
[    1.190069] pci 0000:02:00.0: Signaling PME through PCIe PME interrupt
[    1.190070] pci 0000:02:00.1: Signaling PME through PCIe PME interrupt
[    1.190073] pcie_pme 0000:00:01.1:pcie01: service driver pcie_pme loaded
[    1.190093] pcieport 0000:00:02.0: Signaling PME through PCIe PME interrupt
[    1.190094] pci 0000:04:00.0: Signaling PME through PCIe PME interrupt
[    1.190096] pci 0000:04:00.1: Signaling PME through PCIe PME interrupt
[    1.190098] pcie_pme 0000:00:02.0:pcie01: service driver pcie_pme loaded
[    1.190119] pcieport 0000:00:03.0: Signaling PME through PCIe PME interrupt
[    1.190122] pcie_pme 0000:00:03.0:pcie01: service driver pcie_pme loaded
[    1.190141] pcieport 0000:00:03.2: Signaling PME through PCIe PME interrupt
[    1.190144] pcie_pme 0000:00:03.2:pcie01: service driver pcie_pme loaded
[    1.190164] pcieport 0000:00:11.0: Signaling PME through PCIe PME interrupt
[    1.190166] pci 0000:07:00.0: Signaling PME through PCIe PME interrupt
[    1.190169] pcie_pme 0000:00:11.0:pcie01: service driver pcie_pme loaded
[    1.190187] pcieport 0000:80:01.0: Signaling PME through PCIe PME interrupt
[    1.190189] pcie_pme 0000:80:01.0:pcie01: service driver pcie_pme loaded
[    1.190206] pcieport 0000:80:02.0: Signaling PME through PCIe PME interrupt
[    1.190209] pcie_pme 0000:80:02.0:pcie01: service driver pcie_pme loaded
[    1.190226] pcieport 0000:80:03.0: Signaling PME through PCIe PME interrupt
[    1.190227] pci 0000:83:00.0: Signaling PME through PCIe PME interrupt
[    1.190230] pcie_pme 0000:80:03.0:pcie01: service driver pcie_pme loaded
[    1.190265] ioapic: probe of 0000:00:05.4 failed with error -22
[    1.190274] ioapic: probe of 0000:80:05.4 failed with error -22
[    1.190285] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.190303] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.190350] intel_idle: MWAIT substates: 0x1120
[    1.190351] intel_idle: v0.4 model 0x3E
[    1.190352] intel_idle: lapic_timer_reliable_states 0xffffffff
[    1.191312] ERST: Error Record Serialization Table (ERST) support is initialized.
[    1.191316] pstore: Registered erst as persistent store backend
[    1.191408] GHES: APEI firmware first mode is enabled by WHEA _OSC.
[    1.191488] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.211905] 00:03: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    1.232339] 00:04: ttyS1 at I/O 0x2f8 (irq = 3, base_baud = 115200) is a 16550A
[    1.232680] Linux agpgart interface v0.103
[    1.232932] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    2.178126] tsc: Refined TSC clocksource calibration: 3399.999 MHz
[    2.259815] i8042: No controller found
[    2.259944] mousedev: PS/2 mouse device common for all mice
[    2.259976] rtc_cmos 00:05: RTC can wake from S4
[    2.260097] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    2.260126] rtc_cmos 00:05: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    2.260137] Intel P-state driver initializing.
[    2.260150] Intel pstate controlling: cpu 0
[    2.260167] Intel pstate controlling: cpu 1
[    2.260182] Intel pstate controlling: cpu 2
[    2.260196] Intel pstate controlling: cpu 3
[    2.260209] Intel pstate controlling: cpu 4
[    2.260224] Intel pstate controlling: cpu 5
[    2.260237] Intel pstate controlling: cpu 6
[    2.260251] Intel pstate controlling: cpu 7
[    2.260265] Intel pstate controlling: cpu 8
[    2.260279] Intel pstate controlling: cpu 9
[    2.260293] Intel pstate controlling: cpu 10
[    2.260303] Intel pstate controlling: cpu 11
[    2.260316] Intel pstate controlling: cpu 12
[    2.260330] Intel pstate controlling: cpu 13
[    2.260343] Intel pstate controlling: cpu 14
[    2.260356] Intel pstate controlling: cpu 15
[    2.260371] Intel pstate controlling: cpu 16
[    2.260384] Intel pstate controlling: cpu 17
[    2.260399] Intel pstate controlling: cpu 18
[    2.260412] Intel pstate controlling: cpu 19
[    2.260426] Intel pstate controlling: cpu 20
[    2.260440] Intel pstate controlling: cpu 21
[    2.260453] Intel pstate controlling: cpu 22
[    2.260467] Intel pstate controlling: cpu 23
[    2.260490] Intel pstate controlling: cpu 24
[    2.260520] Intel pstate controlling: cpu 25
[    2.260534] Intel pstate controlling: cpu 26
[    2.260548] Intel pstate controlling: cpu 27
[    2.260564] Intel pstate controlling: cpu 28
[    2.260577] Intel pstate controlling: cpu 29
[    2.260591] Intel pstate controlling: cpu 30
[    2.260606] Intel pstate controlling: cpu 31
[    2.260663] AMD IOMMUv2 driver by Joerg Roedel <joerg.roedel@amd.com>
[    2.260665] AMD IOMMUv2 functionality not available on this system
[    2.260852] TCP: cubic registered
[    2.261421] NET: Registered protocol family 10
[    2.262277] mip6: Mobile IPv6
[    2.262286] NET: Registered protocol family 17
[    2.262301] mpls_gso: MPLS GSO support
[    2.264895] registered taskstats version 1
[    2.266580]   Magic number: 13:317:739
[    2.266625] pci 0000:ff:0d.1: hash matches
[    2.266658] acpi LNXCPU:68: hash matches
[    2.266675] acpi LNXCPU:3b: hash matches
[    2.266898] rtc_cmos 00:05: setting system clock to 2013-01-01 15:43:45 UTC (1357055025)
[    2.267002] PM: Checking hibernation image partition /dev/disk/by-uuid/04e6765a-fe0c-44e7-9165-219563f6171e
[    2.267005] PM: Hibernation image not present or could not be loaded.
[    2.268311] Freeing unused kernel memory: 1004K (ffffffff818ba000 - ffffffff819b5000)
[    2.268313] Write protecting the kernel read-only data: 8192k
[    2.271697] Freeing unused kernel memory: 980K (ffff88000150b000 - ffff880001600000)
[    2.272804] Freeing unused kernel memory: 336K (ffff8800017ac000 - ffff880001800000)
[    2.357628] udevd[228]: starting version 175
[    2.389953] pps_core: LinuxPPS API ver. 1 registered
[    2.389956] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    2.390412] PTP clock support registered
[    2.390730] dca service started, version 1.12.1
[    2.393106] ACPI: bus type USB registered
[    2.393132] usbcore: registered new interface driver usbfs
[    2.393141] usbcore: registered new interface driver hub
[    2.393187] usbcore: registered new device driver usb
[    2.394176] SCSI subsystem initialized
[    2.394494] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.394500] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.0.5-k
[    2.394503] igb: Copyright (c) 2007-2014 Intel Corporation.
[    2.394903] igb 0000:02:00.0: irq 99 for MSI/MSI-X
[    2.394913] igb 0000:02:00.0: irq 100 for MSI/MSI-X
[    2.394922] igb 0000:02:00.0: irq 101 for MSI/MSI-X
[    2.394928] igb 0000:02:00.0: irq 102 for MSI/MSI-X
[    2.394935] igb 0000:02:00.0: irq 103 for MSI/MSI-X
[    2.394941] igb 0000:02:00.0: irq 104 for MSI/MSI-X
[    2.394949] igb 0000:02:00.0: irq 105 for MSI/MSI-X
[    2.394956] igb 0000:02:00.0: irq 106 for MSI/MSI-X
[    2.394956] ehci-pci: EHCI PCI platform driver
[    2.394963] igb 0000:02:00.0: irq 107 for MSI/MSI-X
[    2.395109] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    2.395115] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    2.395131] ehci-pci 0000:00:1a.0: debug port 2
[    2.395991] libata version 3.00 loaded.
[    2.397783] isci: Intel(R) C600 SAS Controller Driver - version 1.2.0
[    2.397797] isci 0000:07:00.0: driver configured for rev: 6 silicon
[    2.397800] isci 0000:07:00.0: OEM parameter table found in OROM
[    2.397801] isci 0000:07:00.0: OEM SAS parameters (version: 1.0) loaded (platform)
[    2.398049] isci 0000:07:00.0: SCU controller 0: phy 3-0 cables: {short, short, short, short}
[    2.399035] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[    2.399055] ehci-pci 0000:00:1a.0: irq 16, io mem 0xdf324000
[    2.400285] scsi0 : isci
[    2.400748] isci 0000:07:00.0: irq 108 for MSI/MSI-X
[    2.400755] isci 0000:07:00.0: irq 109 for MSI/MSI-X
[    2.410011] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    2.410036] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    2.410037] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.410039] usb usb1: Product: EHCI Host Controller
[    2.410040] usb usb1: Manufacturer: Linux 3.16.0-vanilla.3+trtc ehci_hcd
[    2.410041] usb usb1: SerialNumber: 0000:00:1a.0
[    2.410191] hub 1-0:1.0: USB hub found
[    2.410198] hub 1-0:1.0: 2 ports detected
[    2.410450] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    2.410456] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    2.410468] ehci-pci 0000:00:1d.0: debug port 2
[    2.414345] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[    2.414362] ehci-pci 0000:00:1d.0: irq 23, io mem 0xdf323000
[    2.424304] igb 0000:02:00.0: irq 99 for MSI/MSI-X
[    2.424310] igb 0000:02:00.0: irq 100 for MSI/MSI-X
[    2.424315] igb 0000:02:00.0: irq 101 for MSI/MSI-X
[    2.424319] igb 0000:02:00.0: irq 102 for MSI/MSI-X
[    2.424323] igb 0000:02:00.0: irq 103 for MSI/MSI-X
[    2.424327] igb 0000:02:00.0: irq 104 for MSI/MSI-X
[    2.424331] igb 0000:02:00.0: irq 105 for MSI/MSI-X
[    2.424336] igb 0000:02:00.0: irq 106 for MSI/MSI-X
[    2.424340] igb 0000:02:00.0: irq 107 for MSI/MSI-X
[    2.425985] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    2.426018] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    2.426020] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.426021] usb usb2: Product: EHCI Host Controller
[    2.426022] usb usb2: Manufacturer: Linux 3.16.0-vanilla.3+trtc ehci_hcd
[    2.426023] usb usb2: SerialNumber: 0000:00:1d.0
[    2.426114] hub 2-0:1.0: USB hub found
[    2.426118] hub 2-0:1.0: 2 ports detected
[    2.426362] ahci 0000:00:1f.2: version 3.0
[    2.426499] ahci 0000:00:1f.2: irq 110 for MSI/MSI-X
[    2.446700] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x3f impl SATA mode
[    2.446702] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ems apst 
[    2.476609] igb 0000:02:00.0: added PHC on eth0
[    2.476611] igb 0000:02:00.0: Intel(R) Gigabit Ethernet Network Connection
[    2.476612] igb 0000:02:00.0: eth0: (PCIe:5.0Gb/s:Width x4) 00:25:90:e0:6a:de
[    2.476685] igb 0000:02:00.0: eth0: PBA No: 106100-000
[    2.476686] igb 0000:02:00.0: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
[    2.476989] igb 0000:02:00.1: irq 111 for MSI/MSI-X
[    2.476994] igb 0000:02:00.1: irq 112 for MSI/MSI-X
[    2.477003] igb 0000:02:00.1: irq 113 for MSI/MSI-X
[    2.477008] igb 0000:02:00.1: irq 114 for MSI/MSI-X
[    2.477013] igb 0000:02:00.1: irq 115 for MSI/MSI-X
[    2.477017] igb 0000:02:00.1: irq 116 for MSI/MSI-X
[    2.477022] igb 0000:02:00.1: irq 117 for MSI/MSI-X
[    2.477028] igb 0000:02:00.1: irq 118 for MSI/MSI-X
[    2.477032] igb 0000:02:00.1: irq 119 for MSI/MSI-X
[    2.486611] scsi1 : ahci
[    2.486705] scsi2 : ahci
[    2.486792] scsi3 : ahci
[    2.486877] scsi4 : ahci
[    2.486962] scsi5 : ahci
[    2.487043] scsi6 : ahci
[    2.487080] ata1: SATA max UDMA/133 abar m2048@0xdf322000 port 0xdf322100 irq 110
[    2.487082] ata2: SATA max UDMA/133 abar m2048@0xdf322000 port 0xdf322180 irq 110
[    2.487084] ata3: SATA max UDMA/133 abar m2048@0xdf322000 port 0xdf322200 irq 110
[    2.487085] ata4: SATA max UDMA/133 abar m2048@0xdf322000 port 0xdf322280 irq 110
[    2.487087] ata5: SATA max UDMA/133 abar m2048@0xdf322000 port 0xdf322300 irq 110
[    2.487088] ata6: SATA max UDMA/133 abar m2048@0xdf322000 port 0xdf322380 irq 110
[    2.508059] igb 0000:02:00.1: irq 111 for MSI/MSI-X
[    2.508065] igb 0000:02:00.1: irq 112 for MSI/MSI-X
[    2.508070] igb 0000:02:00.1: irq 113 for MSI/MSI-X
[    2.508074] igb 0000:02:00.1: irq 114 for MSI/MSI-X
[    2.508079] igb 0000:02:00.1: irq 115 for MSI/MSI-X
[    2.508083] igb 0000:02:00.1: irq 116 for MSI/MSI-X
[    2.508087] igb 0000:02:00.1: irq 117 for MSI/MSI-X
[    2.508092] igb 0000:02:00.1: irq 118 for MSI/MSI-X
[    2.508096] igb 0000:02:00.1: irq 119 for MSI/MSI-X
[    2.563214] igb 0000:02:00.1: added PHC on eth1
[    2.563218] igb 0000:02:00.1: Intel(R) Gigabit Ethernet Network Connection
[    2.563220] igb 0000:02:00.1: eth1: (PCIe:5.0Gb/s:Width x4) 00:25:90:e0:6a:df
[    2.563306] igb 0000:02:00.1: eth1: PBA No: 106100-000
[    2.563307] igb 0000:02:00.1: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
[    2.721877] usb 1-1: new high-speed USB device number 2 using ehci-pci
[    2.805778] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    2.805821] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.805844] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.805882] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.805906] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    2.805929] ata3: SATA link down (SStatus 0 SControl 300)
[    2.806120] ata1.00: ATA-8: INTEL SSDSC2BB480G4, D2010355, max UDMA/133
[    2.806122] ata1.00: 937703088 sectors, multi 1: LBA48 NCQ (depth 31/32)
[    2.806411] ata1.00: configured for UDMA/133
[    2.806454] ata4.00: ATAPI: ASUS    BW-16D1HT, 1.01, max UDMA/100
[    2.806504] scsi 1:0:0:0: Direct-Access     ATA      INTEL SSDSC2BB48 0355 PQ: 0 ANSI: 5
[    2.807114] ata5.00: ATA-8: ST3500620AS, SD25, max UDMA/133
[    2.807116] ata5.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    2.807171] ata4.00: configured for UDMA/100
[    2.808857] ata5.00: configured for UDMA/133
[    2.811443] ata6.00: ATA-8: WDC WD20EARS-00S8B1, 80.00A80, max UDMA/133
[    2.811445] ata6.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    2.811551] sd 1:0:0:0: [sda] 937703088 512-byte logical blocks: (480 GB/447 GiB)
[    2.811707] sd 1:0:0:0: [sda] Write Protect is off
[    2.811709] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.811737] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.812328]  sda: sda1 sda2 sda3 sda4
[    2.812751] sd 1:0:0:0: [sda] Attached SCSI disk
[    2.817223] ata2.00: ATA-8: ADATA SX900, 5.0.7a, max UDMA/133
[    2.817224] ata2.00: 1000215216 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    2.817280] ata6.00: configured for UDMA/133
[    2.827044] ata2.00: configured for UDMA/133
[    2.827119] scsi 2:0:0:0: Direct-Access     ATA      ADATA SX900      7a   PQ: 0 ANSI: 5
[    2.827273] sd 2:0:0:0: [sdb] 1000215216 512-byte logical blocks: (512 GB/476 GiB)
[    2.827299] sd 2:0:0:0: [sdb] Write Protect is off
[    2.827301] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    2.827309] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.827607] scsi 4:0:0:0: CD-ROM            ASUS     BW-16D1HT        1.01 PQ: 0 ANSI: 5
[    2.827608]  sdb: sdb1 sdb2
[    2.827783] sd 2:0:0:0: [sdb] Attached SCSI disk
[    2.829487] sd 1:0:0:0: Attached scsi generic sg0 type 0
[    2.829528] sd 2:0:0:0: Attached scsi generic sg1 type 0
[    2.834036] scsi 4:0:0:0: Attached scsi generic sg2 type 5
[    2.834122] scsi 5:0:0:0: Direct-Access     ATA      ST3500620AS      SD25 PQ: 0 ANSI: 5
[    2.834242] sd 5:0:0:0: [sdc] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[    2.834264] sd 5:0:0:0: Attached scsi generic sg3 type 0
[    2.834272] sd 5:0:0:0: [sdc] Write Protect is off
[    2.834274] sd 5:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    2.834282] sd 5:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.834345] scsi 6:0:0:0: Direct-Access     ATA      WDC WD20EARS-00S 0A80 PQ: 0 ANSI: 5
[    2.834485] sd 6:0:0:0: [sdd] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[    2.834502] sd 6:0:0:0: [sdd] Write Protect is off
[    2.834504] sd 6:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[    2.834512] sd 6:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.834542] sd 6:0:0:0: Attached scsi generic sg4 type 0
[    2.836390] sr0: scsi3-mmc drive: 24x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[    2.836392] cdrom: Uniform CD-ROM driver Revision: 3.20
[    2.836479] sr 4:0:0:0: Attached scsi CD-ROM sr0
[    2.840663]  sdc: sdc1 sdc2
[    2.840812] sd 5:0:0:0: [sdc] Attached SCSI disk
[    2.854078] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
[    2.854080] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    2.854235] hub 1-1:1.0: USB hub found
[    2.854327] hub 1-1:1.0: 6 ports detected
[    2.869574]  sdd: sdd1
[    2.869704] sd 6:0:0:0: [sdd] Attached SCSI disk
[    2.965727] usb 2-1: new high-speed USB device number 2 using ehci-pci
[    3.101933] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
[    3.101935] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    3.102080] hub 2-1:1.0: USB hub found
[    3.102183] hub 2-1:1.0: 8 ports detected
[    3.173642] usb 1-1.6: new full-speed USB device number 3 using ehci-pci
[    3.177649] Switched to clocksource tsc
[    3.266959] usb 1-1.6: New USB device found, idVendor=0557, idProduct=2221
[    3.266960] usb 1-1.6: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    3.266961] usb 1-1.6: Product: Hermon USB hidmouse Device
[    3.266962] usb 1-1.6: Manufacturer: Winbond Electronics Corp
[    3.268540] hidraw: raw HID events driver (C) Jiri Kosina
[    3.269887] usbcore: registered new interface driver usbhid
[    3.269888] usbhid: USB HID core driver
[    3.271008] input: Winbond Electronics Corp Hermon USB hidmouse Device as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.6/1-1.6:1.0/0003:0557:2221.0001/input/input0
[    3.271075] hid-generic 0003:0557:2221.0001: input,hidraw0: USB HID v1.00 Mouse [Winbond Electronics Corp Hermon USB hidmouse Device] on usb-0000:00:1a.0-1.6/input0
[    3.271164] input: Winbond Electronics Corp Hermon USB hidmouse Device as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.6/1-1.6:1.1/0003:0557:2221.0002/input/input1
[    3.271202] hid-generic 0003:0557:2221.0002: input,hidraw1: USB HID v1.00 Keyboard [Winbond Electronics Corp Hermon USB hidmouse Device] on usb-0000:00:1a.0-1.6/input1
[    3.301705] md: md0 stopped.
[    3.302475] md: bind<sdb1>
[    3.302626] md: bind<sda4>
[    3.303400] md: raid1 personality registered for level 1
[    3.303661] md/raid1:md0: active with 2 out of 2 mirrors
[    3.303807] created bitmap (3 pages) for device md0
[    3.303983] md0: bitmap initialized from disk: read 1 pages, set 0 of 5187 bits
[    3.304409] md0: detected capacity change from 0 to 348032532480
[    3.305217]  md0: unknown partition table
[    3.373524] usb 2-1.1: new high-speed USB device number 3 using ehci-pci
[    3.466591] usb 2-1.1: New USB device found, idVendor=0bc2, idProduct=3312
[    3.466593] usb 2-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    3.466594] usb 2-1.1: Product: Expansion Desk
[    3.466595] usb 2-1.1: Manufacturer: Seagate 
[    3.466596] usb 2-1.1: SerialNumber: NA4M6A1L
[    3.468109] usb-storage 2-1.1:1.0: USB Mass Storage device detected
[    3.468226] scsi7 : usb-storage 2-1.1:1.0
[    3.468285] usbcore: registered new interface driver usb-storage
[    3.506615] device-mapper: uevent: version 1.0.3
[    3.506691] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
[    3.509249] random: nonblocking pool is initialized
[    3.510899] PM: Starting manual resume from disk
[    3.510902] PM: Hibernation image partition 8:2 present
[    3.510902] PM: Looking for hibernation image.
[    3.511068] PM: Image not found (code -22)
[    3.511069] PM: Hibernation image not present or could not be loaded.
[    3.513816] PM: Marking nosave pages: [mem 0x0009a000-0x000fffff]
[    3.513879] PM: Marking nosave pages: [mem 0x7df5d000-0xffffffff]
[    3.514942] PM: Basic memory bitmaps created
[    3.537427] usb 2-1.2: new low-speed USB device number 4 using ehci-pci
[    3.640238] usb 2-1.2: New USB device found, idVendor=0665, idProduct=5161
[    3.640299] usb 2-1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    3.640360] usb 2-1.2: Product: USB to Serial
[    3.640415] usb 2-1.2: Manufacturer: INNO TECH
[    3.640470] usb 2-1.2: SerialNumber: 20100826
[    3.644463] PM: Basic memory bitmaps freed
[    3.645914] hid-generic 0003:0665:5161.0003: hiddev0,hidraw2: USB HID v1.00 Device [INNO TECH USB to Serial] on usb-0000:00:1d.0-1.2/input0
[    3.653002] EXT4-fs (sda1): INFO: recovery required on readonly filesystem
[    3.653004] EXT4-fs (sda1): write access will be enabled during recovery
[    3.656618] EXT4-fs (sda1): recovery complete
[    3.656819] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[    3.717325] usb 2-1.3: new high-speed USB device number 5 using ehci-pci
[    3.809921] usb 2-1.3: New USB device found, idVendor=1a40, idProduct=0101
[    3.809924] usb 2-1.3: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[    3.809927] usb 2-1.3: Product: USB 2.0 Hub
[    3.810252] hub 2-1.3:1.0: USB hub found
[    3.810490] hub 2-1.3:1.0: 4 ports detected
[    3.813367] udevd[939]: starting version 175
[    3.879777] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input2
[    3.879784] ACPI: Power Button [PWRB]
[    3.879878] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    3.879881] ACPI: Power Button [PWRF]
[    3.886690] wmi: Mapper loaded
[    3.910097] ipmi message handler version 39.2
[    3.911371] IPMI System Interface driver.
[    3.911527] ipmi_si: probing via ACPI
[    3.911540] ipmi_si 00:07: [io  0x0ca2] regsize 1 spacing 1 irq 0
[    3.911541] ipmi_si: Adding ACPI-specified kcs state machine
[    3.911560] ipmi_si: probing via SMBIOS
[    3.911561] ipmi_si: SMBIOS: mem 0x0 regsize 1 spacing 1 irq 0
[    3.911562] ipmi_si: Adding SMBIOS-specified kcs state machine
[    3.911564] ipmi_si: probing via SPMI
[    3.911565] ipmi_si: SPMI: io 0xca2 regsize 1 spacing 1 irq 0
[    3.911565] ipmi_si: Adding SPMI-specified kcs state machine duplicate interface
[    3.911567] ipmi_si: Trying ACPI-specified kcs state machine at i/o address 0xca2, slave address 0x0, irq 0
[    3.918423] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    3.919403] ioatdma 0000:00:04.0: irq 120 for MSI/MSI-X
[    3.919810] igb 0000:02:00.0: DCA enabled
[    3.920104] igb 0000:02:00.1: DCA enabled
[    3.920832] ioatdma 0000:00:04.1: irq 121 for MSI/MSI-X
[    3.922193] ioatdma 0000:00:04.2: irq 122 for MSI/MSI-X
[    3.923285] ioatdma 0000:00:04.3: irq 123 for MSI/MSI-X
[    3.923737] ioatdma 0000:00:04.4: irq 124 for MSI/MSI-X
[    3.924702] ioatdma 0000:00:04.5: irq 125 for MSI/MSI-X
[    3.925554] ioatdma 0000:00:04.6: irq 126 for MSI/MSI-X
[    3.926034] ioatdma 0000:00:04.7: irq 127 for MSI/MSI-X
[    3.926367] mei_me 0000:00:16.0: Device doesn't have valid ME Interface
[    3.927135] ioatdma 0000:80:04.0: irq 128 for MSI/MSI-X
[    3.927291] i801_smbus 0000:00:1f.3: SMBus using PCI Interrupt
[    3.928162] ioatdma 0000:80:04.1: irq 129 for MSI/MSI-X
[    3.929353] ioatdma 0000:80:04.2: irq 130 for MSI/MSI-X
[    3.930277] ioatdma 0000:80:04.3: irq 131 for MSI/MSI-X
[    3.931252] ioatdma 0000:80:04.4: irq 132 for MSI/MSI-X
[    3.932131] EDAC MC: Ver: 3.0.0
[    3.932135] ioatdma 0000:80:04.5: irq 133 for MSI/MSI-X
[    3.932994] ioatdma 0000:80:04.6: irq 134 for MSI/MSI-X
[    3.933859] ioatdma 0000:80:04.7: irq 135 for MSI/MSI-X
[    3.933902] EDAC sbridge: Seeking for: dev 0e.0 PCI ID 8086:0ea0
[    3.933913] EDAC sbridge: Seeking for: dev 0e.0 PCI ID 8086:0ea0
[    3.933928] EDAC sbridge: Seeking for: dev 0e.0 PCI ID 8086:0ea0
[    3.933931] EDAC sbridge: Seeking for: dev 0f.0 PCI ID 8086:0ea8
[    3.933936] EDAC sbridge: Seeking for: dev 0f.0 PCI ID 8086:0ea8
[    3.933940] EDAC sbridge: Seeking for: dev 0f.0 PCI ID 8086:0ea8
[    3.933942] EDAC sbridge: Seeking for: dev 0f.1 PCI ID 8086:0e71
[    3.933946] EDAC sbridge: Seeking for: dev 0f.1 PCI ID 8086:0e71
[    3.933951] EDAC sbridge: Seeking for: dev 0f.1 PCI ID 8086:0e71
[    3.933953] EDAC sbridge: Seeking for: dev 0f.2 PCI ID 8086:0eaa
[    3.933957] EDAC sbridge: Seeking for: dev 0f.2 PCI ID 8086:0eaa
[    3.933962] EDAC sbridge: Seeking for: dev 0f.2 PCI ID 8086:0eaa
[    3.933963] EDAC sbridge: Seeking for: dev 0f.3 PCI ID 8086:0eab
[    3.933968] EDAC sbridge: Seeking for: dev 0f.3 PCI ID 8086:0eab
[    3.933973] EDAC sbridge: Seeking for: dev 0f.3 PCI ID 8086:0eab
[    3.933975] EDAC sbridge: Seeking for: dev 0f.4 PCI ID 8086:0eac
[    3.933979] EDAC sbridge: Seeking for: dev 0f.4 PCI ID 8086:0eac
[    3.933984] EDAC sbridge: Seeking for: dev 0f.4 PCI ID 8086:0eac
[    3.933987] EDAC sbridge: Seeking for: dev 0f.5 PCI ID 8086:0ead
[    3.934009] EDAC sbridge: Seeking for: dev 0f.5 PCI ID 8086:0ead
[    3.934017] EDAC sbridge: Seeking for: dev 0f.5 PCI ID 8086:0ead
[    3.934019] EDAC sbridge: Seeking for: dev 16.0 PCI ID 8086:0ec8
[    3.934024] EDAC sbridge: Seeking for: dev 16.0 PCI ID 8086:0ec8
[    3.934028] EDAC sbridge: Seeking for: dev 16.0 PCI ID 8086:0ec8
[    3.934030] EDAC sbridge: Seeking for: dev 16.1 PCI ID 8086:0ec9
[    3.934034] EDAC sbridge: Seeking for: dev 16.1 PCI ID 8086:0ec9
[    3.934039] EDAC sbridge: Seeking for: dev 16.1 PCI ID 8086:0ec9
[    3.934042] EDAC sbridge: Seeking for: dev 16.2 PCI ID 8086:0eca
[    3.934046] EDAC sbridge: Seeking for: dev 16.2 PCI ID 8086:0eca
[    3.934052] EDAC sbridge: Seeking for: dev 16.2 PCI ID 8086:0eca
[    3.934054] EDAC sbridge: Seeking for: dev 1c.0 PCI ID 8086:0e60
[    3.934059] EDAC sbridge: Seeking for: dev 1d.2 PCI ID 8086:0e6a
[    3.934066] EDAC sbridge: Seeking for: dev 1d.3 PCI ID 8086:0e6b
[    3.934072] EDAC sbridge: Seeking for: dev 11.0 PCI ID 8086:0eb8
[    3.934077] EDAC sbridge: Seeking for: dev 11.4 PCI ID 8086:0ebc
[    3.934296] EDAC MC0: Giving out device to module sbridge_edac.c controller Ivy Bridge Socket#0: DEV 0000:7f:0e.0 (POLLED)
[    3.934475] EDAC MC1: Giving out device to module sbridge_edac.c controller Ivy Bridge Socket#1: DEV 0000:ff:0e.0 (POLLED)
[    3.934477] EDAC sbridge: Driver loaded.
[    3.940570] snd_hda_intel 0000:04:00.1: Disabling MSI
[    3.940581] snd_hda_intel 0000:04:00.1: Handle VGA-switcheroo audio client
[    3.940698] snd_hda_intel 0000:83:00.0: Disabling MSI
[    3.940701] snd_hda_intel 0000:83:00.0: Force to non-snoop mode
[    3.942465] input: PC Speaker as /devices/platform/pcspkr/input/input4
[    3.950340] sound hdaudioC1D1: autoconfig: line_outs=1 (0xd/0x0/0x0/0x0/0x0) type:line
[    3.950342] sound hdaudioC1D1:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    3.950343] sound hdaudioC1D1:    hp_outs=1 (0x10/0x0/0x0/0x0/0x0)
[    3.950344] sound hdaudioC1D1:    mono: mono_out=0x0
[    3.950345] sound hdaudioC1D1:    dig-out=0xc/0x0
[    3.950346] sound hdaudioC1D1:    inputs:
[    3.950347] sound hdaudioC1D1:      Mic=0x12
[    3.950348] sound hdaudioC1D1:    dig-in=0xe
[    3.952322] snd_hda_intel 0000:83:00.0: Direct firmware load failed with error -2
[    3.952324] snd_hda_intel 0000:83:00.0: Falling back to user helper
[    3.957179] AVX version of gcm_enc/dec engaged.
[    3.958755] alg: No test for __gcm-aes-aesni (__driver-gcm-aes-aesni)
[    3.962615] iTCO_vendor_support: vendor-support=0
[    3.963236] alg: No test for crc32 (crc32-pclmul)
[    3.963756] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[    3.963810] iTCO_wdt: Found a Patsburg TCO device (Version=2, TCOBASE=0x0460)
[    3.964069] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    3.966034] nvidia: module license 'NVIDIA' taints kernel.
[    3.966036] Disabling lock debugging due to kernel taint
[    3.972736] vgaarb: device changed decodes: PCI:0000:04:00.0,olddecodes=io+mem,decodes=none:owns=none
[    3.972898] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  331.79  Sun May 18 03:55:59 PDT 2014
[    4.001774] input: HDA Creative Mic as /devices/pci0000:80/0000:80:03.0/0000:83:00.0/sound/card1/input5
[    4.001846] input: HDA Creative Front Headphone as /devices/pci0000:80/0000:80:03.0/0000:83:00.0/sound/card1/input6
[    4.017569] ipmi_si 00:07: Found new BMC (man_id: 0x002a7c, prod_id: 0x0628, dev_id: 0x20)
[    4.017576] ipmi_si 00:07: IPMI kcs interface initialized
[    4.081170] usb 2-1.3.1: new high-speed USB device number 6 using ehci-pci
[    4.173552] usb 2-1.3.1: New USB device found, idVendor=1a40, idProduct=0101
[    4.173554] usb 2-1.3.1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[    4.173556] usb 2-1.3.1: Product: USB 2.0 Hub
[    4.173699] hub 2-1.3.1:1.0: USB hub found
[    4.173800] hub 2-1.3.1:1.0: 4 ports detected
[    4.261001] usb 2-1.3.3: new full-speed USB device number 7 using ehci-pci
[    4.372934] usb 2-1.3.3: New USB device found, idVendor=046d, idProduct=c52b
[    4.372935] usb 2-1.3.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    4.372936] usb 2-1.3.3: Product: USB Receiver
[    4.372937] usb 2-1.3.3: Manufacturer: Logitech
[    4.394995] logitech-djreceiver 0003:046D:C52B.0006: hiddev0,hidraw3: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:1d.0-1.3.3/input2
[    4.401024] input: HDA NVidia HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:02.0/0000:04:00.1/sound/card0/input7
[    4.401077] input: HDA NVidia HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:02.0/0000:04:00.1/sound/card0/input8
[    4.401191] input: HDA NVidia HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:02.0/0000:04:00.1/sound/card0/input9
[    4.401293] input: HDA NVidia HDMI/DP,pcm=9 as /devices/pci0000:00/0000:00:02.0/0000:04:00.1/sound/card0/input10
[    4.450293] input: Logitech Unifying Device. Wireless PID:101b as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/2-1.3.3/2-1.3.3:1.2/0003:046D:C52B.0006/0003:046D:C52B.0007/input/input11
[    4.450398] logitech-djdevice 0003:046D:C52B.0007: input,hidraw4: USB HID v1.11 Mouse [Logitech Unifying Device. Wireless PID:101b] on usb-0000:00:1d.0-1.3.3:1
[    4.452327] input: Logitech Unifying Device. Wireless PID:2011 as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/2-1.3.3/2-1.3.3:1.2/0003:046D:C52B.0006/0003:046D:C52B.0008/input/input12
[    4.452411] logitech-djdevice 0003:046D:C52B.0008: input,hidraw5: USB HID v1.11 Keyboard [Logitech Unifying Device. Wireless PID:2011] on usb-0000:00:1d.0-1.3.3:2
[    4.465665] scsi 7:0:0:0: Direct-Access     Seagate  Expansion Desk   0737 PQ: 0 ANSI: 6
[    4.465854] sd 7:0:0:0: Attached scsi generic sg5 type 0
[    4.466385] sd 7:0:0:0: [sde] 488378645 4096-byte logical blocks: (2.00 TB/1.81 TiB)
[    4.467136] sd 7:0:0:0: [sde] Write Protect is off
[    4.467139] sd 7:0:0:0: [sde] Mode Sense: 2b 00 10 08
[    4.467760] sd 7:0:0:0: [sde] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    4.468382] sd 7:0:0:0: [sde] 488378645 4096-byte logical blocks: (2.00 TB/1.81 TiB)
[    7.173981]  sde: sde1
[    7.196809] sd 7:0:0:0: [sde] 488378645 4096-byte logical blocks: (2.00 TB/1.81 TiB)
[    7.204553] sd 7:0:0:0: [sde] Attached SCSI disk
[    7.401333] Adding 85983228k swap on /dev/sda2.  Priority:-1 extents:1 across:85983228k SS
[    7.404914] EXT4-fs (sda1): re-mounted. Opts: (null)
[    7.561248] EXT4-fs (sda1): re-mounted. Opts: commit=600,errors=remount-ro
[    7.574487] loop: module loaded
[   27.180555] EXT4-fs (dm-2): mounted filesystem with ordered data mode. Opts: commit=600
[   27.183554] EXT4-fs (dm-0): mounted filesystem with ordered data mode. Opts: commit=600
[   27.188019] EXT4-fs (dm-1): mounted filesystem with ordered data mode. Opts: commit=600
[   27.609340] RPC: Registered named UNIX socket transport module.
[   27.609343] RPC: Registered udp transport module.
[   27.609345] RPC: Registered tcp transport module.
[   27.609346] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   27.613399] FS-Cache: Loaded
[   27.617661] FS-Cache: Netfs 'nfs' registered for caching
[   27.623695] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   27.877453] vboxdrv: Found 32 processor cores.
[   27.878004] vboxdrv: fAsync=0 offMin=0x26a offMax=0x3822
[   27.878117] vboxdrv: TSC mode is 'synchronous', kernel timer mode is 'normal'.
[   27.878118] vboxdrv: Successfully loaded version 4.3.12_Debian (interface 0x001a0007).
[   27.909277] vboxpci: IOMMU not found (not registered)
[   27.920900] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
[   27.921046] NFSD: starting 90-second grace period (net ffffffff8188f400)
[   27.942025] Bluetooth: Core ver 2.19
[   27.942037] NET: Registered protocol family 31
[   27.942038] Bluetooth: HCI device and connection manager initialized
[   27.942047] Bluetooth: HCI socket layer initialized
[   27.942048] Bluetooth: L2CAP socket layer initialized
[   27.942054] Bluetooth: SCO socket layer initialized
[   27.943783] Bluetooth: RFCOMM TTY layer initialized
[   27.943791] Bluetooth: RFCOMM socket layer initialized
[   27.943795] Bluetooth: RFCOMM ver 1.11
[   27.946445] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   27.946447] Bluetooth: BNEP filters: protocol multicast
[   27.946450] Bluetooth: BNEP socket layer initialized
[   27.958772] lp: driver loaded but no devices found
[   27.960637] ppdev: user-space parallel port driver
[   28.079176] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   28.175329] IPv6: ADDRCONF(NETDEV_UP): eth1: link is not ready
[   28.258773] nvidia 0000:04:00.0: irq 136 for MSI/MSI-X
[   31.277439] igb 0000:02:00.0 eth0: igb: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
[   31.277592] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready

############### paste END.


Now I tried to identify the problem. There are two magic numbers
recorded in realtime clock:

pci     0000:ff:0d.1: hash matches
pci_bus 0000:ff: hash matches

The 0000:ff: is strange, like no particular piece of hardware driver is wrong, but whole bus?

The 0000:ff:0d.1 from lspci is a following thing:

ff:0d.1 System peripheral [0880]: Intel Corporation Ivytown Unicast Registers [8086:0ee3] (rev 04)
        Subsystem: Super Micro Computer Inc Device [15d9:0628]
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-


So that's the best I could do so far. Currently I am waiting for more
instructions from you on how to proceed.

PS: I am pretty sure that my hardware is not broken.
-- 
Janek Kozicki                               http://janek.kozicki.pl/  |

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780AbaF3IUw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 04:20:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:38241 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752340AbaF3IUt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 04:20:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,573,1400050800"; 
   d="scan'208";a="565903249"
Message-ID: <1404116444.8366.1.camel@rzhang1-toshiba>
Subject: Re: [BUG] rc3 Oops: unable to handle kernel NULL pointer
 dereference at 0000074c
From: Zhang Rui <rui.zhang@intel.com>
To: Martin Kepplinger <martink@posteo.de>
Cc: "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org
Date: Mon, 30 Jun 2014 16:20:44 +0800
In-Reply-To: <1404116299.8366.0.camel@rzhang1-toshiba>
References: <53A6E72A.9090000@posteo.de>
	 <744357E9AAD1214791ACBA4B0B90926301379B97@SHSMSX101.ccr.corp.intel.com>
	 <53A81BF7.3030207@posteo.de> <1403529246.4686.6.camel@rzhang1-toshiba>
	 <53A83DC7.1010606@posteo.de> <1403882067.16305.124.camel@rzhang1-toshiba>
	 <53ADB359.4010401@posteo.de> <53ADCB24.9030206@posteo.de>
	 <53ADECDA.60600@posteo.de> <53B11749.3020902@posteo.de>
	 <1404116299.8366.0.camel@rzhang1-toshiba>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-30 at 16:18 +0800, Zhang Rui wrote:
> On Mon, 2014-06-30 at 09:52 +0200, Martin Kepplinger wrote:
> > I now booted 3.16-rc3 and suddenly see an oops during boot:
> > 
> > the oops during boot: http://tny.cz/2301e393
> > 	also below
> > 
> > lshw if interesting: http://tny.cz/3c9a7609
> > 
> > the full boot log: http://tny.cz/88260b19
> > 
> > does anyone have an idea?
> 
> what if you rebuild the kernel with CONFIG_SENSORS_CORETEMP=n?
> 
BTW, can this be 100% reproduced on a rc3 kernel?

thanks,
rui
> thanks,
> rui
> >                            thanks
> > 
> > the oops:
> > 
> > Jun 30 08:35:08 laptop kernel: [    5.245811] bus: 'platform':
> > really_probe: probing driver coretemp with device coretemp.0
> > Jun 30 08:35:08 laptop kernel: [    5.246134] BUG: unable to handle
> > kernel NULL pointer dereference at 0000074c
> > Jun 30 08:35:08 laptop kernel: [    5.246145] IP: [<c10325d9>]
> > is_highmem+0x1/0x2b
> > Jun 30 08:35:08 laptop kernel: [    5.246158] *pdpt = 0000000033e49001
> > *pde = 0000000000000000
> > Jun 30 08:35:08 laptop kernel: [    5.246167] Oops: 0000 [#1] SMP
> > Jun 30 08:35:08 laptop kernel: [    5.246175] Modules linked in:
> > coretemp(+) kvm_intel kvm snd_hda_codec_hdmi snd_hda_codec_realtek
> > snd_hda_codec_generic microcode snd_hda_intel i915(+) snd_hda_controller
> > evdev psmouse snd_hda_codec serio_raw snd_hwdep snd_pcm iwlwifi i2c_i801
> > lpc_ich mfd_core snd_seq drm_kms_helper snd_timer battery ehci_pci
> > snd_seq_device drm cfg80211 ehci_hcd snd i2c_algo_bit ac video i2c_core
> > rfkill soundcore wmi acpi_cpufreq button processor thermal_sys ext4
> > crc16 jbd2 mbcache sg sd_mod crct10dif_generic crc_t10dif
> > crct10dif_common ahci libahci crc32c_intel tg3 ptp libata pps_core
> > sdhci_pci sdhci scsi_mod mmc_core libphy xhci_hcd usbcore usb_common
> > Jun 30 08:35:08 laptop kernel: [    5.246320] CPU: 1 PID: 491 Comm:
> > modprobe Not tainted 3.16.0-rc3 #83
> > Jun 30 08:35:08 laptop kernel: [    5.246330] Hardware name: Acer
> > TravelMate B113/BA10_HX           , BIOS V1.09 10/30/2012
> > Jun 30 08:35:08 laptop kernel: [    5.246344] task: f3828a90 ti:
> > f3e88000 task.ti: f3e88000
> > Jun 30 08:35:08 laptop kernel: [    5.246355] EIP: 0060:[<c10325d9>]
> > EFLAGS: 00010206 CPU: 1
> > Jun 30 08:35:08 laptop kernel: [    5.246367] EIP is at is_highmem+0x1/0x2b
> > Jun 30 08:35:08 laptop kernel: [    5.246376] EAX: 000003c0 EBX:
> > ffb76000 ECX: 00000001 EDX: 000003c0
> > Jun 30 08:35:08 laptop kernel: [    5.246386] ESI: f86cd279 EDI:
> > 00000000 EBP: f3e89c10 ESP: f3e89c04
> > Jun 30 08:35:08 laptop kernel: [    5.246396]  DS: 007b ES: 007b FS:
> > 00d8 GS: 00e0 SS: 0068
> > Jun 30 08:35:08 laptop kernel: [    5.246405] CR0: 80050033 CR2:
> > 0000074c CR3: 2e3fc000 CR4: 000407f0
> > Jun 30 08:35:08 laptop kernel: [    5.246414] Stack:
> > Jun 30 08:35:08 laptop kernel: [    5.246421]  f3e89c10 c1032889
> > f3cbcc60 f3e89c4c f86b52bf 00000005 00000000 00000448
> > Jun 30 08:35:08 laptop kernel: [    5.246442]  f3e89c30 00000006
> > 00165000 ffb76000 00000113 f870f010 ee881128 ee881128
> > Jun 30 08:35:08 laptop kernel: [    5.246465]  00000001 f418b980
> > f3e89c74 f86b4e5c 00000000 f3911e00 f3911e00 ee881128
> > Jun 30 08:35:08 laptop kernel: [    5.246487] Call Trace:
> > Jun 30 08:35:08 laptop kernel: [    5.246500]  [<c1032889>] ?
> > kunmap+0x3b/0x4e
> > Jun 30 08:35:08 laptop kernel: [    5.246578]  [<f86b52bf>] ?
> > i915_gem_render_state_init+0x24f/0x28c [i915]
> > Jun 30 08:35:08 laptop kernel: [    5.246634]  [<f86b4e5c>] ?
> > i915_switch_context+0x348/0x387 [i915]
> > Jun 30 08:35:08 laptop kernel: [    5.246684]  [<f86b4f0f>] ?
> > i915_gem_context_enable+0x74/0x7c [i915]
> > Jun 30 08:35:08 laptop kernel: [    5.246742]  [<f86bcd38>] ?
> > i915_gem_init_hw+0x23e/0x285 [i915]
> > Jun 30 08:35:08 laptop kernel: [    5.246818]  [<f86bce7e>] ?
> > i915_gem_init+0xff/0x179 [i915]
> > Jun 30 08:35:08 laptop kernel: [    5.246924]  [<f87047d9>] ?
> > i915_driver_load+0x989/0xc1d [i915]
> > Jun 30 08:35:08 laptop kernel: [    5.246940]  [<c1267429>] ?
> > get_device+0x14/0x1d
> > Jun 30 08:35:08 laptop kernel: [    5.246955]  [<c1268832>] ?
> > device_add+0x3b7/0x4a9
> > Jun 30 08:35:08 laptop kernel: [    5.246996]  [<f8619c80>] ?
> > drm_minor_register+0x104/0x15c [drm]
> > Jun 30 08:35:08 laptop kernel: [    5.247033]  [<f8619d44>] ?
> > drm_dev_register+0x6c/0xce [drm]
> > Jun 30 08:35:08 laptop kernel: [    5.247072]  [<f861bbb4>] ?
> > drm_get_pci_dev+0xde/0x174 [drm]
> > Jun 30 08:35:08 laptop kernel: [    5.247088]  [<c11dcc58>] ?
> > local_pci_probe+0x33/0x6c
> > Jun 30 08:35:08 laptop kernel: [    5.247101]  [<c11dcd39>] ?
> > pci_device_probe+0xa8/0xca
> > Jun 30 08:35:08 laptop kernel: [    5.247115]  [<c126a75a>] ?
> > driver_probe_device+0xd3/0x225
> > Jun 30 08:35:08 laptop kernel: [    5.247128]  [<c126a8f8>] ?
> > __driver_attach+0x4c/0x68
> > Jun 30 08:35:08 laptop kernel: [    5.247141]  [<c1269260>] ?
> > bus_for_each_dev+0x41/0x6b
> > Jun 30 08:35:08 laptop kernel: [    5.247155]  [<c126a26c>] ?
> > driver_attach+0x19/0x1b
> > Jun 30 08:35:08 laptop kernel: [    5.247166]  [<c126a8ac>] ?
> > driver_probe_device+0x225/0x225
> > Jun 30 08:35:08 laptop kernel: [    5.247176]  [<c126a027>] ?
> > bus_add_driver+0xcf/0x192
> > Jun 30 08:35:08 laptop kernel: [    5.247184]  [<c126ae69>] ?
> > driver_register+0x73/0xa5
> > Jun 30 08:35:08 laptop kernel: [    5.247193]  [<f85ee000>] ? 0xf85edfff
> > Jun 30 08:35:08 laptop kernel: [    5.247200]  [<c100045e>] ?
> > do_one_initcall+0xe0/0x17a
> > Jun 30 08:35:08 laptop kernel: [    5.247209]  [<c10fadf8>] ?
> > __cache_free+0x369/0x371
> > Jun 30 08:35:08 laptop kernel: [    5.247216]  [<c10fadf8>] ?
> > __cache_free+0x369/0x371
> > Jun 30 08:35:08 laptop kernel: [    5.247223]  [<c1088e4d>] ?
> > load_module+0x11a5/0x14b6
> > Jun 30 08:35:08 laptop kernel: [    5.247230]  [<c1088e4d>] ?
> > load_module+0x11a5/0x14b6
> > Jun 30 08:35:08 laptop kernel: [    5.247238]  [<c1088e90>] ?
> > load_module+0x11e8/0x14b6
> > Jun 30 08:35:08 laptop kernel: [    5.247248]  [<c10891e4>] ?
> > SyS_init_module+0x86/0x9e
> > Jun 30 08:35:08 laptop kernel: [    5.247263]  [<c135d64f>] ?
> > sysenter_do_call+0x12/0x16
> > Jun 30 08:35:08 laptop kernel: [    5.247269] Code: e4 00 00 00 00 e8 b8
> > f9 ff ff 83 c4 0c 8d 65 f4 5b 5e 5f 5d c3 55 89 e5 66 66 66 66 90 31 d2
> > e8 5e fe ff ff 31 c0 5d c3 90 90 55 <2b> 80 8c 03 00 00 89 e5 3d 80 07
> > 00 00 74 14 3d 40 0b 00 00 74
> > Jun 30 08:35:08 laptop kernel: [    5.247337] EIP: [<c10325d9>]
> > is_highmem+0x1/0x2b SS:ESP 0068:f3e89c04
> > Jun 30 08:35:08 laptop kernel: [    5.247354] CR2: 000000000000074c
> > Jun 30 08:35:08 laptop kernel: [    5.247364] ---[ end trace
> > f6bf47010230a3ea ]---
> > Jun 30 08:35:08 laptop kernel: [    5.249053] device: 'hwmon0': device_add
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



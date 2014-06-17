Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917AbaFQKcn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 06:32:43 -0400
Received: from mail.skyhub.de ([78.46.96.112]:46508 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751994AbaFQKck (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 06:32:40 -0400
Date: Tue, 17 Jun 2014 12:32:35 +0200
From: Borislav Petkov <bp@alien8.de>
To: linux-usb@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: WARNING: CPU: 1 PID: 479 at drivers/usb/core/port.c:197 ... failed
 to peer
Message-ID: <20140617103235.GB4824@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I get the splat below on latest linus/master + tip/master, i.e.
3.16-rc1+. More info available upon request:

...

[    3.366557] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    3.367225] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 2
[    3.368064] usb usb2: New USB device found, idVendor=1d6b, idProduct=0003
[    3.368884] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.369497] usb usb2: Product: xHCI Host Controller
[    3.370101] usb usb2: Manufacturer: Linux 3.16.0-rc1+ xhci_hcd
[    3.370701] usb usb2: SerialNumber: 0000:00:14.0
[    3.371731] hub 2-0:1.0: USB hub found
[    3.372364] hub 2-0:1.0: 4 ports detected
[    3.373350] ------------[ cut here ]------------
[    3.373957] WARNING: CPU: 1 PID: 479 at drivers/usb/core/port.c:197 link_peers_report+0xfb/0x280()
[    3.374603] failed to peer usb2-port2 and usb1-port1 (usb2-port2 ->           (null)) (usb1-port1 -> ffff8802132d3800)
[    3.375225] Modules linked in: x86_pkg_temp_thermal coretemp kvm_intel kvm crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 glue_helper lrw arc4 gf128mul ablk_helper cryptd microcode iwldvm pcspkr mac80211 i2c_i801(+) sdhci_pci snd_hda_intel(+) snd_hda_controller snd_hda_codec thinkpad_acpi(+) snd_hwdep sdhci iwlwifi snd_pcm mmc_core nvram snd_timer cfg80211 lpc_ich(+) mfd_core ehci_pci(+) xhci_hcd(+) snd ehci_hcd e1000e wmi soundcore led_class battery ac(+) acpi_cpufreq processor thermal
[    3.378139] CPU: 1 PID: 479 Comm: modprobe Not tainted 3.16.0-rc1+ #1
[    3.378871] Hardware name: LENOVO 2320CTO/2320CTO, BIOS G2ET86WW (2.06 ) 11/13/2012
[    3.379610]  0000000000000009 ffff880037a9b500 ffffffff815f2932 ffff880037a9b548
[    3.380392]  ffff880037a9b538 ffffffff8105175d ffff8802131d6800 ffff8802132d4000
[    3.381119]  ffffffff81485e00 ffff880213ac2400 ffff8802132d4000 ffff880037a9b598
[    3.381839] Call Trace:
[    3.382521]  [<ffffffff815f2932>] dump_stack+0x4e/0x7a
[    3.383278]  [<ffffffff8105175d>] warn_slowpath_common+0x7d/0xa0
[    3.383985]  [<ffffffff81485e00>] ? __find_interface+0x40/0x40
[    3.384669]  [<ffffffff810517cc>] warn_slowpath_fmt+0x4c/0x50
[    3.385366]  [<ffffffff815e8a20>] ? klist_next+0x20/0x100
[    3.386109]  [<ffffffff8149fb3b>] link_peers_report+0xfb/0x280
[    3.386799]  [<ffffffff81485e00>] ? __find_interface+0x40/0x40
[    3.387488]  [<ffffffff8149fd53>] match_location+0x93/0xa0
[    3.388227]  [<ffffffff81485e2c>] __each_dev+0x2c/0x30
[    3.388937]  [<ffffffff8141f2ab>] bus_for_each_dev+0x6b/0xb0
[    3.389617]  [<ffffffff81485a3e>] usb_for_each_dev+0x2e/0x30
[    3.390306]  [<ffffffff8149fcc0>] ? link_peers_report+0x280/0x280
[    3.391045]  [<ffffffff814a0007>] usb_hub_create_port_device+0x2a7/0x2b0
[    3.391714]  [<ffffffff8148d51f>] hub_probe+0x79f/0x990
[    3.392401]  [<ffffffff8149609a>] usb_probe_interface+0x1ca/0x2d0
[    3.393151]  [<ffffffff8142110f>] driver_probe_device+0x7f/0x250
[    3.393823]  [<ffffffff814212e0>] ? driver_probe_device+0x250/0x250
[    3.394488]  [<ffffffff8142131b>] __device_attach+0x3b/0x40
[    3.395191]  [<ffffffff8141f373>] bus_for_each_drv+0x63/0xa0
[    3.396054]  [<ffffffff81421040>] device_attach+0x90/0xb0
[    3.396701]  [<ffffffff81420598>] bus_probe_device+0xa8/0xd0
[    3.397371]  [<ffffffff8141e562>] device_add+0x4f2/0x610
[    3.398053]  [<ffffffff8149401d>] usb_set_configuration+0x50d/0x7f0
[    3.398695]  [<ffffffff8149e7ee>] generic_probe+0x2e/0xa0
[    3.399360]  [<ffffffff81495ea9>] usb_probe_device+0x29/0x50
[    3.400027]  [<ffffffff8142110f>] driver_probe_device+0x7f/0x250
[    3.400670]  [<ffffffff814212e0>] ? driver_probe_device+0x250/0x250
[    3.401334]  [<ffffffff8142131b>] __device_attach+0x3b/0x40
[    3.402001]  [<ffffffff8141f373>] bus_for_each_drv+0x63/0xa0
[    3.402636]  [<ffffffff81421040>] device_attach+0x90/0xb0
[    3.403288]  [<ffffffff81420598>] bus_probe_device+0xa8/0xd0
[    3.403946]  [<ffffffff8141e562>] device_add+0x4f2/0x610
[    3.404579]  [<ffffffff8148aa98>] usb_new_device+0x2a8/0x4c0
[    3.405236]  [<ffffffff81497ade>] ? usb_get_bos_descriptor+0xfe/0x260
[    3.405897]  [<ffffffff8148ef13>] usb_add_hcd+0x3e3/0x730
[    3.406540]  [<ffffffffa00b966c>] xhci_pci_probe+0x8c/0x170 [xhci_hcd]
[    3.407195]  [<ffffffff812d0265>] local_pci_probe+0x45/0xa0
[    3.407890]  [<ffffffff812d1425>] ? pci_match_device+0xe5/0x110
[    3.408485]  [<ffffffff812d1561>] pci_device_probe+0xd1/0x130
[    3.409081]  [<ffffffff8142110f>] driver_probe_device+0x7f/0x250
[    3.409634]  [<ffffffff814213b3>] __driver_attach+0x93/0xa0
[    3.410273]  [<ffffffff81421320>] ? __device_attach+0x40/0x40
[    3.410888]  [<ffffffff8141f2ab>] bus_for_each_dev+0x6b/0xb0
[    3.411403]  [<ffffffff81420c3e>] driver_attach+0x1e/0x20
[    3.411928]  [<ffffffff814208a8>] bus_add_driver+0x178/0x230
[    3.412438]  [<ffffffffa00c5000>] ? 0xffffffffa00c4fff
[    3.413001]  [<ffffffff81421bd4>] driver_register+0x64/0xf0
[    3.413496]  [<ffffffff812cfc0d>] __pci_register_driver+0x5d/0x60
[    3.414059]  [<ffffffffa00c52c2>] xhci_register_pci+0x1e/0xd5c [xhci_hcd]
[    3.414653]  [<ffffffffa00c5009>] xhci_hcd_init+0x9/0x14 [xhci_hcd]
[    3.415319]  [<ffffffff810002e0>] do_one_initcall+0xa0/0x1f0
[    3.415943]  [<ffffffff811626ba>] ? __vunmap+0xca/0x110
[    3.416524]  [<ffffffff810d1fee>] load_module+0x1cce/0x2410
[    3.417057]  [<ffffffff810ceae0>] ? symbol_put_addr+0x40/0x40
[    3.417662]  [<ffffffff810d287e>] SyS_finit_module+0x7e/0x80
[    3.418202]  [<ffffffff815fc556>] system_call_fastpath+0x1a/0x1f
[    3.418730] ---[ end trace 728d26e6b72a1bd1 ]---
[    3.419279] usb usb2-port2: failed to peer to usb1-port1 (-16)
[    3.419813] usb: port power management may be unreliable
[    3.420593] ------------[ cut here ]------------
[    3.421127] WARNING: CPU: 0 PID: 479 at drivers/usb/core/port.c:197 link_peers_report+0xfb/0x280()
[    3.421676] failed to peer usb2-port3 and usb1-port1 (usb2-port3 ->           (null)) (usb1-port1 -> ffff8802132d3800)
[    3.422246] Modules linked in: x86_pkg_temp_thermal coretemp kvm_intel kvm crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 glue_helper lrw arc4 gf128mul ablk_helper cryptd microcode iwldvm pcspkr mac80211 i2c_i801(+) sdhci_pci snd_hda_intel(+) snd_hda_controller snd_hda_codec thinkpad_acpi(+) snd_hwdep sdhci iwlwifi snd_pcm mmc_core nvram snd_timer cfg80211 lpc_ich(+) mfd_core ehci_pci(+) xhci_hcd(+) snd ehci_hcd e1000e wmi soundcore led_class battery ac(+) acpi_cpufreq processor thermal
[    3.424990] CPU: 0 PID: 479 Comm: modprobe Tainted: G        W     3.16.0-rc1+ #1
[    3.425651] Hardware name: LENOVO 2320CTO/2320CTO, BIOS G2ET86WW (2.06 ) 11/13/2012
[    3.426304]  0000000000000009 ffff880037a9b500 ffffffff815f2932 ffff880037a9b548
[    3.426985]  ffff880037a9b538 ffffffff8105175d ffff8802131d6800 ffff88021335a800
[    3.427643]  ffffffff81485e00 ffff880213ac2400 ffff88021335a800 ffff880037a9b598
[    3.428315] Call Trace:
[    3.428982]  [<ffffffff815f2932>] dump_stack+0x4e/0x7a
[    3.429630]  [<ffffffff8105175d>] warn_slowpath_common+0x7d/0xa0
[    3.430304]  [<ffffffff81485e00>] ? __find_interface+0x40/0x40
[    3.431007]  [<ffffffff810517cc>] warn_slowpath_fmt+0x4c/0x50
[    3.431657]  [<ffffffff815e8a20>] ? klist_next+0x20/0x100
[    3.432326]  [<ffffffff8149fb3b>] link_peers_report+0xfb/0x280
[    3.433001]  [<ffffffff81485e00>] ? __find_interface+0x40/0x40
[    3.433650]  [<ffffffff8149fd53>] match_location+0x93/0xa0
[    3.434313]  [<ffffffff81485e2c>] __each_dev+0x2c/0x30
[    3.434979]  [<ffffffff8141f2ab>] bus_for_each_dev+0x6b/0xb0
[    3.435622]  [<ffffffff81485a3e>] usb_for_each_dev+0x2e/0x30
[    3.436282]  [<ffffffff8149fcc0>] ? link_peers_report+0x280/0x280
[    3.436937]  [<ffffffff814a0007>] usb_hub_create_port_device+0x2a7/0x2b0
[    3.437609]  [<ffffffff8148d51f>] hub_probe+0x79f/0x990
[    3.438283]  [<ffffffff8149609a>] usb_probe_interface+0x1ca/0x2d0
[    3.438958]  [<ffffffff8142110f>] driver_probe_device+0x7f/0x250
[    3.439627]  [<ffffffff814212e0>] ? driver_probe_device+0x250/0x250
[    3.440302]  [<ffffffff8142131b>] __device_attach+0x3b/0x40
[    3.440979]  [<ffffffff8141f373>] bus_for_each_drv+0x63/0xa0
[    3.441667]  [<ffffffff81421040>] device_attach+0x90/0xb0
[    3.442342]  [<ffffffff81420598>] bus_probe_device+0xa8/0xd0
[    3.443024]  [<ffffffff8141e562>] device_add+0x4f2/0x610
[    3.443700]  [<ffffffff8149401d>] usb_set_configuration+0x50d/0x7f0
[    3.444381]  [<ffffffff8149e7ee>] generic_probe+0x2e/0xa0
[    3.445061]  [<ffffffff81495ea9>] usb_probe_device+0x29/0x50
[    3.445732]  [<ffffffff8142110f>] driver_probe_device+0x7f/0x250
[    3.446405]  [<ffffffff814212e0>] ? driver_probe_device+0x250/0x250
[    3.447082]  [<ffffffff8142131b>] __device_attach+0x3b/0x40
[    3.447756]  [<ffffffff8141f373>] bus_for_each_drv+0x63/0xa0
[    3.448431]  [<ffffffff81421040>] device_attach+0x90/0xb0
[    3.449106]  [<ffffffff81420598>] bus_probe_device+0xa8/0xd0
[    3.449746]  [<ffffffff8141e562>] device_add+0x4f2/0x610
[    3.450405]  [<ffffffff8148aa98>] usb_new_device+0x2a8/0x4c0
[    3.451062]  [<ffffffff81497ade>] ? usb_get_bos_descriptor+0xfe/0x260
[    3.451732]  [<ffffffff8148ef13>] usb_add_hcd+0x3e3/0x730
[    3.452405]  [<ffffffffa00b966c>] xhci_pci_probe+0x8c/0x170 [xhci_hcd]
[    3.453072]  [<ffffffff812d0265>] local_pci_probe+0x45/0xa0
[    3.453720]  [<ffffffff812d1425>] ? pci_match_device+0xe5/0x110
[    3.454345]  [<ffffffff812d1561>] pci_device_probe+0xd1/0x130
[    3.454953]  [<ffffffff8142110f>] driver_probe_device+0x7f/0x250
[    3.455502]  [<ffffffff814213b3>] __driver_attach+0x93/0xa0
[    3.456048]  [<ffffffff81421320>] ? __device_attach+0x40/0x40
[    3.456564]  [<ffffffff8141f2ab>] bus_for_each_dev+0x6b/0xb0
[    3.457098]  [<ffffffff81420c3e>] driver_attach+0x1e/0x20
[    3.457598]  [<ffffffff814208a8>] bus_add_driver+0x178/0x230
[    3.458121]  [<ffffffffa00c5000>] ? 0xffffffffa00c4fff
[    3.458615]  [<ffffffff81421bd4>] driver_register+0x64/0xf0
[    3.459128]  [<ffffffff812cfc0d>] __pci_register_driver+0x5d/0x60
[    3.459623]  [<ffffffffa00c52c2>] xhci_register_pci+0x1e/0xd5c [xhci_hcd]
[    3.460141]  [<ffffffffa00c5009>] xhci_hcd_init+0x9/0x14 [xhci_hcd]
[    3.460635]  [<ffffffff810002e0>] do_one_initcall+0xa0/0x1f0
[    3.461150]  [<ffffffff811626ba>] ? __vunmap+0xca/0x110
[    3.461643]  [<ffffffff810d1fee>] load_module+0x1cce/0x2410
[    3.462158]  [<ffffffff810ceae0>] ? symbol_put_addr+0x40/0x40
[    3.462649]  [<ffffffff810d287e>] SyS_finit_module+0x7e/0x80
[    3.463165]  [<ffffffff815fc556>] system_call_fastpath+0x1a/0x1f
[    3.463667] ---[ end trace 728d26e6b72a1bd2 ]---
[    3.464224] usb usb2-port3: failed to peer to usb1-port1 (-16)
[    3.466119] ------------[ cut here ]------------
[    3.468297] WARNING: CPU: 1 PID: 479 at drivers/usb/core/port.c:197 link_peers_report+0xfb/0x280()
[    3.468897] failed to peer usb2-port4 and usb1-port1 (usb2-port4 ->           (null)) (usb1-port1 -> ffff8802132d3800)
[    3.469520] Modules linked in: x86_pkg_temp_thermal coretemp kvm_intel kvm crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 glue_helper lrw arc4 gf128mul ablk_helper cryptd microcode iwldvm pcspkr mac80211 i2c_i801(+) sdhci_pci snd_hda_intel(+) snd_hda_controller snd_hda_codec thinkpad_acpi(+) snd_hwdep sdhci iwlwifi snd_pcm mmc_core nvram snd_timer cfg80211 lpc_ich(+) mfd_core ehci_pci(+) xhci_hcd(+) snd ehci_hcd e1000e wmi soundcore led_class battery ac(+) acpi_cpufreq processor thermal
[    3.472245] CPU: 1 PID: 479 Comm: modprobe Tainted: G        W     3.16.0-rc1+ #1
[    3.472898] Hardware name: LENOVO 2320CTO/2320CTO, BIOS G2ET86WW (2.06 ) 11/13/2012
[    3.473534]  0000000000000009 ffff880037a9b500 ffffffff815f2932 ffff880037a9b548
[    3.474207]  ffff880037a9b538 ffffffff8105175d ffff8802131d6800 ffff8802132d4800
[    3.474905]  ffffffff81485e00 ffff880213ac2400 ffff8802132d4800 ffff880037a9b598
[    3.475561] Call Trace:
[    3.476337]  [<ffffffff815f2932>] dump_stack+0x4e/0x7a
[    3.477146]  [<ffffffff8105175d>] warn_slowpath_common+0x7d/0xa0
[    3.477956]  [<ffffffff81485e00>] ? __find_interface+0x40/0x40
[    3.478710]  [<ffffffff810517cc>] warn_slowpath_fmt+0x4c/0x50
[    3.479489]  [<ffffffff815e8a20>] ? klist_next+0x20/0x100
[    3.480298]  [<ffffffff8149fb3b>] link_peers_report+0xfb/0x280
[    3.481096]  [<ffffffff81485e00>] ? __find_interface+0x40/0x40
[    3.481885]  [<ffffffff8149fd53>] match_location+0x93/0xa0
[    3.482538]  [<ffffffff81485e2c>] __each_dev+0x2c/0x30
[    3.483208]  [<ffffffff8141f2ab>] bus_for_each_dev+0x6b/0xb0
[    3.483936]  [<ffffffff81485a3e>] usb_for_each_dev+0x2e/0x30
[    3.484579]  [<ffffffff8149fcc0>] ? link_peers_report+0x280/0x280
[    3.485244]  [<ffffffff814a0007>] usb_hub_create_port_device+0x2a7/0x2b0
[    3.485908]  [<ffffffff8148d51f>] hub_probe+0x79f/0x990
[    3.486607]  [<ffffffff8149609a>] usb_probe_interface+0x1ca/0x2d0
[    3.487276]  [<ffffffff8142110f>] driver_probe_device+0x7f/0x250
[    3.487942]  [<ffffffff814212e0>] ? driver_probe_device+0x250/0x250
[    3.488585]  [<ffffffff8142131b>] __device_attach+0x3b/0x40
[    3.489288]  [<ffffffff8141f373>] bus_for_each_drv+0x63/0xa0
[    3.489959]  [<ffffffff81421040>] device_attach+0x90/0xb0
[    3.490602]  [<ffffffff81420598>] bus_probe_device+0xa8/0xd0
[    3.491274]  [<ffffffff8141e562>] device_add+0x4f2/0x610
[    3.492014]  [<ffffffff8149401d>] usb_set_configuration+0x50d/0x7f0
[    3.492670]  [<ffffffff8149e7ee>] generic_probe+0x2e/0xa0
[    3.493340]  [<ffffffff81495ea9>] usb_probe_device+0x29/0x50
[    3.494008]  [<ffffffff8142110f>] driver_probe_device+0x7f/0x250
[    3.494700]  [<ffffffff814212e0>] ? driver_probe_device+0x250/0x250
[    3.495372]  [<ffffffff8142131b>] __device_attach+0x3b/0x40
[    3.496039]  [<ffffffff8141f373>] bus_for_each_drv+0x63/0xa0
[    3.496685]  [<ffffffff81421040>] device_attach+0x90/0xb0
[    3.497407]  [<ffffffff81420598>] bus_probe_device+0xa8/0xd0
[    3.498077]  [<ffffffff8141e562>] device_add+0x4f2/0x610
[    3.498722]  [<ffffffff8148aa98>] usb_new_device+0x2a8/0x4c0
[    3.499388]  [<ffffffff81497ade>] ? usb_get_bos_descriptor+0xfe/0x260
[    3.500100]  [<ffffffff8148ef13>] usb_add_hcd+0x3e3/0x730
[    3.500826]  [<ffffffffa00b966c>] xhci_pci_probe+0x8c/0x170 [xhci_hcd]
[    3.501693]  [<ffffffff812d0265>] local_pci_probe+0x45/0xa0
[    3.502356]  [<ffffffff812d1425>] ? pci_match_device+0xe5/0x110
[    3.503055]  [<ffffffff812d1561>] pci_device_probe+0xd1/0x130
[    3.503665]  [<ffffffff8142110f>] driver_probe_device+0x7f/0x250
[    3.504256]  [<ffffffff814213b3>] __driver_attach+0x93/0xa0
[    3.504815]  [<ffffffff81421320>] ? __device_attach+0x40/0x40
[    3.505404]  [<ffffffff8141f2ab>] bus_for_each_dev+0x6b/0xb0
[    3.505957]  [<ffffffff81420c3e>] driver_attach+0x1e/0x20
[    3.506491]  [<ffffffff814208a8>] bus_add_driver+0x178/0x230
[    3.507026]  [<ffffffffa00c5000>] ? 0xffffffffa00c4fff
[    3.507550]  [<ffffffff81421bd4>] driver_register+0x64/0xf0
[    3.508125]  [<ffffffff812cfc0d>] __pci_register_driver+0x5d/0x60
[    3.508625]  [<ffffffffa00c52c2>] xhci_register_pci+0x1e/0xd5c [xhci_hcd]
[    3.509219]  [<ffffffffa00c5009>] xhci_hcd_init+0x9/0x14 [xhci_hcd]
[    3.509754]  [<ffffffff810002e0>] do_one_initcall+0xa0/0x1f0
[    3.510319]  [<ffffffff811626ba>] ? __vunmap+0xca/0x110
[    3.510840]  [<ffffffff810d1fee>] load_module+0x1cce/0x2410
[    3.511347]  [<ffffffff810ceae0>] ? symbol_put_addr+0x40/0x40
[    3.511864]  [<ffffffff810d287e>] SyS_finit_module+0x7e/0x80
[    3.512378]  [<ffffffff815fc556>] system_call_fastpath+0x1a/0x1f
[    3.512917] ---[ end trace 728d26e6b72a1bd3 ]---
[    3.513422] usb usb2-port4: failed to peer to usb1-port1 (-16)
[    3.514506] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    3.515320] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    3.516197] ehci-pci 0000:00:1a.0: debug port 2
[    3.521044] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[    3.522051] ehci-pci 0000:00:1a.0: irq 16, io mem 0xf153a000
[    3.528944] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    3.530161] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[    3.531627] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.532919] usb usb3: Product: EHCI Host Controller
[    3.534222] usb usb3: Manufacturer: Linux 3.16.0-rc1+ ehci_hcd
[    3.535609] usb usb3: SerialNumber: 0000:00:1a.0
[    3.536977] hub 3-0:1.0: USB hub found
[    3.537604] hub 3-0:1.0: 3 ports detected
[    3.538661] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    3.539227] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 4
[    3.539808] ehci-pci 0000:00:1d.0: debug port 2
[    3.544266] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[    3.544833] ehci-pci 0000:00:1d.0: irq 23, io mem 0xf1539000
[    3.550914] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    3.551883] usb usb4: New USB device found, idVendor=1d6b, idProduct=0002
[    3.552701] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.553555] usb usb4: Product: EHCI Host Controller
[    3.554389] usb usb4: Manufacturer: Linux 3.16.0-rc1+ ehci_hcd
[    3.555214] usb usb4: SerialNumber: 0000:00:1d.0
[    3.556596] hub 4-0:1.0: USB hub found
[    3.557596] hub 4-0:1.0: 3 ports detected

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751AbaLTHPm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 02:15:42 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:64265 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbaLTHPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 02:15:38 -0500
Date: Fri, 19 Dec 2014 23:15:33 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Dudley Du <dudl@cypress.com>
Cc: dmitry.torokhov@gmail.com, rydberg@euromail.se, bleung@google.com,
        dso@cypress.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v16 00/12] input: cyapa: instruction of cyapa patches
Message-ID: <20141220071533.GA1139@newt.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Dudley Du <dudl@cypress.com>, dmitry.torokhov@gmail.com,
	rydberg@euromail.se, bleung@google.com, dso@cypress.com,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1418896856-15766-1-git-send-email-dudl@cypress.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418896856-15766-1-git-send-email-dudl@cypress.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dudley,

On Thu, Dec 18, 2014 at 06:00:44PM +0800, Dudley Du wrote:
> V16 patches have below updates, details of other updates see history list:
[...]

This version has problems.  I am getting an oops (below) and then things
quit working and usually my machine hangs.

[    2.388284] input: HDA Intel PCH Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card1/input10
[    2.412938] FS-Cache: Netfs 'nfs' registered for caching
[    2.427645] [drm] Initialized i915 1.6.0 20141121 for 0000:00:02.0 on minor 0
[    2.428320] __add_probed_i2c_device failed to register device 1-4a
[    2.428331] platform chromeos_laptop: Driver chromeos_laptop requests probe deferral
[    2.429126] fbcon: inteldrmfb (fb0) is primary device
[    2.449066] BUG: unable to handle kernel NULL pointer dereference at 0000000000000160
[    2.449073] IP: [<ffffffff813f7b2b>] input_mt_sync_frame+0xb/0x60
[    2.449075] PGD 0 
[    2.449077] Oops: 0000 [#1] SMP 
[    2.449112] Modules linked in: ath9k_hw auth_rpcgss oid_registry nfs_acl nfs ath mac80211 lockd i915 tpm_infineon grace cyapatp(+) crc_itu_t fscache iTCO_wdt sunrpc iTCO_vendor_support crct10dif_pclmul crc32_pclmul crc32c_intel cfg80211 chromeos_laptop ghash_clmulni_intel cryptd snd_hda_codec_realtek snd_hda_codec_generic i2c_algo_bit snd_hda_intel rfkill snd_hda_controller xhci_pci evdev snd_hda_codec serio_raw xhci_hcd pcspkr drm_kms_helper snd_hwdep snd_pcm i2c_i801 usbcore snd_timer snd shpchp i2c_designware_pci lpc_ich i2c_designware_core mfd_core drm usb_common soundcore tpm_tis battery tpm ac video i2c_core processor button fuse autofs4 ext4 crc16 mbcache jbd2 sg sd_mod sdhci_acpi sdhci mmc_core ahci thermal libahci libata scsi_mod fan thermal_sys
[    2.449115] CPU: 0 PID: 448 Comm: irq/37-cyapa Not tainted 3.18.0-next-20141219+ #157
[    2.449116] Hardware name: Acer Peppy, BIOS          04/30/2014
[    2.449117] task: ffff8800364e6310 ti: ffff880068c9c000 task.ti: ffff880068c9c000
[    2.449121] RIP: 0010:[<ffffffff813f7b2b>]  [<ffffffff813f7b2b>] input_mt_sync_frame+0xb/0x60
[    2.449122] RSP: 0018:ffff880068c9fd88  EFLAGS: 00010296
[    2.449123] RAX: 0000000000000003 RBX: ffff88007050ac20 RCX: 0000000000000000
[    2.449124] RDX: 0000000000000083 RSI: ffff880068c9fd6a RDI: 0000000000000000
[    2.449125] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000001
[    2.449126] R10: 000000000000007c R11: 0000000000000067 R12: ffff88007050ac20
[    2.449127] R13: ffff880072fb2c18 R14: ffffffff810bd230 R15: ffff8800364e6310
[    2.449128] FS:  0000000000000000(0000) GS:ffff880100200000(0000) knlGS:0000000000000000
[    2.449129] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    2.449130] CR2: 0000000000000160 CR3: 00000000749a9000 CR4: 00000000000407f0
[    2.449131] Stack:
[    2.449134]  0000000000000000 ffff88007050ac20 0000000000000000 ffffffffa03f2c59
[    2.449135]  0008830000000092 0000000000000000 0000000000000000 0000000000000000
[    2.449137]  ffff88007541d000 ffff880072fb2c18 ffff88007050ac00 ffff88007050ac20
[    2.449138] Call Trace:
[    2.449146]  [<ffffffffa03f2c59>] ? cyapa_gen3_irq_handler+0x119/0x200 [cyapatp]
[    2.449151]  [<ffffffffa03f1502>] ? cyapa_irq+0xb2/0x120 [cyapatp]
[    2.449155]  [<ffffffff810bd24b>] ? irq_thread_fn+0x1b/0x40
[    2.449157]  [<ffffffff810bd81b>] ? irq_thread+0x13b/0x160
[    2.449160]  [<ffffffff810bd310>] ? wake_threads_waitq+0x40/0x40
[    2.449162]  [<ffffffff810bd6e0>] ? irq_thread_check_affinity+0xb0/0xb0
[    2.449165]  [<ffffffff81089013>] ? kthread+0xd3/0xf0
[    2.449168]  [<ffffffff81088f40>] ? kthread_create_on_node+0x1a0/0x1a0
[    2.449172]  [<ffffffff8154583c>] ? ret_from_fork+0x7c/0xb0
[    2.449174]  [<ffffffff81088f40>] ? kthread_create_on_node+0x1a0/0x1a0
[    2.449193] Code: 0f 1f 44 00 00 53 48 8b 9f 60 01 00 00 48 85 db 74 0c 48 89 de e8 76 ff ff ff 83 43 10 01 5b c3 0f 1f 44 00 00 55 53 48 83 ec 08 <48> 8b 9f 60 01 00 00 48 85 db 74 24 f6 43 0c 04 48 89 fd 75 28 
[    2.449195] RIP  [<ffffffff813f7b2b>] input_mt_sync_frame+0xb/0x60
[    2.449196]  RSP <ffff880068c9fd88>
[    2.449197] CR2: 0000000000000160
[    2.449199] ---[ end trace 3561783fbbc1b06d ]---
[    2.449211] BUG: unable to handle kernel paging request at ffffffffffffffc8
[    2.449214] IP: [<ffffffff8108966c>] kthread_data+0xc/0x20
[    2.449216] PGD 1816067 PUD 1818067 PMD 0 
[    2.449217] Oops: 0000 [#2] SMP 
[    2.449243] Modules linked in: ath9k_hw auth_rpcgss oid_registry nfs_acl nfs ath mac80211 lockd i915 tpm_infineon grace cyapatp(+) crc_itu_t fscache iTCO_wdt sunrpc iTCO_vendor_support crct10dif_pclmul crc32_pclmul crc32c_intel cfg80211 chromeos_laptop ghash_clmulni_intel cryptd snd_hda_codec_realtek snd_hda_codec_generic i2c_algo_bit snd_hda_intel rfkill snd_hda_controller xhci_pci evdev snd_hda_codec serio_raw xhci_hcd pcspkr drm_kms_helper snd_hwdep snd_pcm i2c_i801 usbcore snd_timer snd shpchp i2c_designware_pci lpc_ich i2c_designware_core mfd_core drm usb_common soundcore tpm_tis battery tpm ac video i2c_core processor button fuse autofs4 ext4 crc16 mbcache jbd2 sg sd_mod sdhci_acpi sdhci mmc_core ahci thermal libahci libata scsi_mod fan thermal_sys
[    2.449245] CPU: 0 PID: 448 Comm: irq/37-cyapa Tainted: G      D        3.18.0-next-20141219+ #157
[    2.449246] Hardware name: Acer Peppy, BIOS          04/30/2014
[    2.449247] task: ffff8800364e6310 ti: ffff880068c9c000 task.ti: ffff880068c9c000
[    2.449250] RIP: 0010:[<ffffffff8108966c>]  [<ffffffff8108966c>] kthread_data+0xc/0x20
[    2.449251] RSP: 0018:ffff880068c9fa70  EFLAGS: 00010202
[    2.449252] RAX: 0000000000000000 RBX: ffff8800364e6310 RCX: 000000000000000d
[    2.449253] RDX: 0000000000000000 RSI: 000000000000000d RDI: ffff8800364e6310
[    2.449254] RBP: ffffffff81a8ac30 R08: ffff880068c9ff28 R09: 0000000000000024
[    2.449254] R10: ffffffff81a9ab30 R11: 000000000001463c R12: ffff8800364e6998
[    2.449255] R13: ffff8800364e6310 R14: 0000000000000001 R15: 0000000000030001
[    2.449256] FS:  0000000000000000(0000) GS:ffff880100200000(0000) knlGS:0000000000000000
[    2.449257] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    2.449258] CR2: ffffffffffffffc8 CR3: 00000000749a9000 CR4: 00000000000407f0
[    2.449258] Stack:
[    2.449260]  ffffffff810bd33b ffff8800364e6310 0000000000000000 ffffffff81a8ac30
[    2.449262]  ffffffff81087707 ffff8800364e69c8 ffff8800364e6310 ffff880068c9faf8
[    2.449264]  ffff880068c9fcd8 0000000000000000 ffffffff8106e41d 0000000000030001
[    2.449264] Call Trace:
[    2.449267]  [<ffffffff810bd33b>] ? irq_thread_dtor+0x2b/0xc0
[    2.449269]  [<ffffffff81087707>] ? task_work_run+0xa7/0xe0
[    2.449271]  [<ffffffff8106e41d>] ? do_exit+0x2ed/0xac0
[    2.449276]  [<ffffffff810178e6>] ? oops_end+0x96/0xe0
[    2.449280]  [<ffffffff8105b016>] ? no_context+0x106/0x380
[    2.449283]  [<ffffffff8105b77e>] ? __do_page_fault+0xae/0x550
[    2.449289]  [<ffffffffa01ae871>] ? i2c_transfer+0x81/0xd0 [i2c_core]
[    2.449294]  [<ffffffffa01aea7e>] ? i2c_smbus_xfer_emulated+0x11e/0x550 [i2c_core]
[    2.449297]  [<ffffffff810bd230>] ? irq_finalize_oneshot.part.30+0xd0/0xd0
[    2.449301]  [<ffffffff815479e8>] ? page_fault+0x28/0x30
[    2.449303]  [<ffffffff810bd230>] ? irq_finalize_oneshot.part.30+0xd0/0xd0
[    2.449305]  [<ffffffff813f7b2b>] ? input_mt_sync_frame+0xb/0x60
[    2.449310]  [<ffffffffa03f2c59>] ? cyapa_gen3_irq_handler+0x119/0x200 [cyapatp]
[    2.449314]  [<ffffffffa03f1502>] ? cyapa_irq+0xb2/0x120 [cyapatp]
[    2.449316]  [<ffffffff810bd24b>] ? irq_thread_fn+0x1b/0x40
[    2.449318]  [<ffffffff810bd81b>] ? irq_thread+0x13b/0x160
[    2.449320]  [<ffffffff810bd310>] ? wake_threads_waitq+0x40/0x40
[    2.449322]  [<ffffffff810bd6e0>] ? irq_thread_check_affinity+0xb0/0xb0
[    2.449324]  [<ffffffff81089013>] ? kthread+0xd3/0xf0
[    2.449327]  [<ffffffff81088f40>] ? kthread_create_on_node+0x1a0/0x1a0
[    2.449329]  [<ffffffff8154583c>] ? ret_from_fork+0x7c/0xb0
[    2.449331]  [<ffffffff81088f40>] ? kthread_create_on_node+0x1a0/0x1a0
[    2.449349] Code: 40 04 00 00 48 8b 40 b8 48 c1 e8 02 83 e0 01 c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 8b 87 40 04 00 00 <48> 8b 40 c8 c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 0f 
[    2.449351] RIP  [<ffffffff8108966c>] kthread_data+0xc/0x20
[    2.449351]  RSP <ffff880068c9fa70>
[    2.449352] CR2: ffffffffffffffc8
[    2.449353] ---[ end trace 3561783fbbc1b06e ]---
[    2.449353] Fixing recursive fault but reboot is needed!
[    2.467991] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    2.471174] usb 1-3: new high-speed USB device number 2 using xhci_hcd
[    2.486523] ath: phy0: ASPM enabled: 0x43
[    2.486525] ath: EEPROM regdomain: 0x6c
[    2.486526] ath: EEPROM indicates we should expect a direct regpair map
[    2.486528] ath: Country alpha2 being used: 00
[    2.486528] ath: Regpair used: 0x6c
[    2.488258] cfg80211: World regulatory domain updated:
[    2.488260] cfg80211:  DFS Master region: unset

-- 
- Jeremiah Mahler

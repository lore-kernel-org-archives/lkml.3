Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933557AbaE2Ilw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 04:41:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49382 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755953AbaE2Ils (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 04:41:48 -0400
Message-ID: <5386F2C7.8080400@redhat.com>
Date: Thu, 29 May 2014 10:41:43 +0200
From: Zdenek Kabelac <zkabelac@redhat.com>
Organization: Red Hat
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: rafael.j.wysocki@intel.com, LKML <linux-kernel@vger.kernel.org>
Subject: WARNING: CPU: 0 PID: 2623 at drivers/pnp/pnpacpi/core.c:96 pnpacpi_set_resource
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi


I've noticed this message in my dmesg:
(Possibly related to this commit?:
a8d22396302b7e4e5f0a594c1c1594388c29edaf)

(My vanilla git commit number for my kernel:
cd79bde29f00a346eec3fe17c1c5073c37ed95e7)

Zdenek


[ 2174.058615] ata5: port disabled--ignoring
[ 2174.059460] sd 0:0:0:0: [sda] Starting disk
[ 2174.076342] ------------[ cut here ]------------
[ 2174.076350] WARNING: CPU: 0 PID: 2623 at drivers/pnp/pnpacpi/core.c:96 
pnpacpi_set_resources+0x14f/0x160()
[ 2174.076412] Modules linked in: dm_raid raid456 async_raid6_recov 
async_memcpy async_pq async_xor async_tx raid1 raid10 dm_mod md_mod xor 
raid6_pq i915 i2c_algo_bit drm_kms_helper drm xt_CHECKSUM iptable_mangle 
ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 
xt_conntrack nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables 
x_tables tun bridge stp llc ipv6 hid_generic usbhid hid snd_hda_codec_analog 
snd_hda_codec_generic iTCO_wdt iTCO_vendor_support coretemp kvm_intel kvm 
microcode psmouse serio_raw i2c_i801 i2c_core arc4 lpc_ich mfd_core r852 
iwl3945 sm_common nand r592 nand_ecc nand_ids iwlegacy mtd memstick mac80211 
sdhci_pci pcmcia sdhci snd_hda_intel mmc_core snd_hda_controller snd_hda_codec 
snd_hwdep snd_seq snd_seq_device snd_pcm cfg80211 e1000e ptp snd_timer
[ 2174.076433]  pps_core wmi thinkpad_acpi nvram snd soundcore evdev nfsd 
auth_rpcgss oid_registry nfs_acl lockd binfmt_misc loop sunrpc uhci_hcd sr_mod 
cdrom yenta_socket ehci_pci ehci_hcd usbcore usb_common video backlight autofs4
[ 2174.076436] CPU: 0 PID: 2623 Comm: systemd-sleep Not tainted 
3.15.0-rc7-00044-g887210a #209
[ 2174.076437] Hardware name: LENOVO 6464CTO/6464CTO, BIOS 7LETC9WW (2.29 ) 
03/18/2011
[ 2174.076440]  0000000000000009 ffff880095d55c40 ffffffff815db694 
0000000000000000
[ 2174.076444]  ffff880095d55c78 ffffffff8104e78d 0000000000000000 
ffff880136c3cd98
[ 2174.076447]  ffff8800bac2b000 ffffffff8180cb5a 0000000000000000 
ffff880095d55c88
[ 2174.076448] Call Trace:
[ 2174.076453]  [<ffffffff815db694>] dump_stack+0x4e/0x7a
[ 2174.076643]  [<ffffffff8104e78d>] warn_slowpath_common+0x7d/0xa0
[ 2174.076646]  [<ffffffff8104e86a>] warn_slowpath_null+0x1a/0x20
[ 2174.076648]  [<ffffffff814046cf>] pnpacpi_set_resources+0x14f/0x160
[ 2174.076651]  [<ffffffff81401db2>] pnp_start_dev+0x42/0x80
[ 2174.076655]  [<ffffffff81400858>] pnp_bus_resume+0x88/0xa0
[ 2174.076658]  [<ffffffff814007d0>] ? pnp_bus_suspend+0x20/0x20
[ 2174.076662]  [<ffffffff8145e919>] dpm_run_callback+0x49/0xa0
[ 2174.076664]  [<ffffffff8145ec18>] device_resume+0xc8/0x1f0
[ 2174.076667]  [<ffffffff81460639>] dpm_resume+0x119/0x250
[ 2174.076670]  [<ffffffff814609b1>] dpm_resume_end+0x11/0x20
[ 2174.076673]  [<ffffffff810b4b0f>] suspend_devices_and_enter+0xff/0x680
[ 2174.076676]  [<ffffffff810b5277>] pm_suspend+0x1e7/0x2a0
[ 2174.076678]  [<ffffffff810b3c2c>] state_store+0x7c/0xf0
[ 2174.076683]  [<ffffffff81359f2f>] kobj_attr_store+0xf/0x20
[ 2174.076686]  [<ffffffff8124b1b5>] sysfs_kf_write+0x45/0x60
[ 2174.076690]  [<ffffffff8124a4d9>] kernfs_fop_write+0xf9/0x180
[ 2174.076694]  [<ffffffff811c66bd>] vfs_write+0xbd/0x1e0
[ 2174.076696]  [<ffffffff811c7249>] SyS_write+0x49/0xb0
[ 2174.076700]  [<ffffffff815ecbd6>] system_call_fastpath+0x1a/0x1f
[ 2174.081587] ---[ end trace 32ffe1e61f685f01 ]---
[ 2174.082221] serial 00:09: activated
[ 2174.233290] thinkpad_acpi: ACPI backlight control delay disabled
[ 2174.323685] ata4.00: ACPI cmd ef/03:42:00:00:00:a0 (SET FEATURES) filtered out
[ 2174.323688] ata4.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
[ 2174.324671] ata4.00: ACPI cmd e3/00:79:00:00:00:a0 (IDLE) succeeded
[ 2174.325651] ata4.00: ACPI cmd e3/00:01:00:00:00:a0 (IDLE) succeeded
[ 2174.345266] ata4.00: configured for UDMA/33

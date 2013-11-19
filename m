Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976Ab3KSSEf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 13:04:35 -0500
Received: from claw.goop.org ([74.207.240.146]:51482 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464Ab3KSSEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 13:04:32 -0500
X-Greylist: delayed 390 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Nov 2013 13:04:32 EST
Message-ID: <528BA6A6.9050403@goop.org>
Date: Tue, 19 Nov 2013 09:57:58 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: xen-devel@lists.xenproject.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Xen S3 host resume: "Interrupts enabled after xen_acpi_processor_resume+0x0/0x34"
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After an S3 host resume, I'm seeing:

[48002.772629] ACPI: Low-level resume complete
[48002.772802] PM: Restoring platform NVS memory
[48002.776143] xen_acpi_processor: Uploading Xen processor PM info
[48002.776691] ------------[ cut here ]------------
[48002.776712] WARNING: CPU: 0 PID: 10235 at drivers/base/syscore.c:104 syscore_resume+0x9a/0xe0()
[48002.776751] Interrupts enabled after xen_acpi_processor_resume+0x0/0x34 [xen_acpi_processor]
[48002.776836] Modules linked in: tcp_lp btrfs zlib_deflate raid6_pq xor ufs hfsplus hfs
 minix vfat msdos fat jfs xfs libcrc32c reiserfs xt_CHECKSUM tun hidp fuse nf_conntrack_
netbios_ns nf_conntrack_broadcast ipt_MASQUERADE ip6t_REJECT xt_conntrack ebtable_nat eb
table_broute bridge stp llc ebtable_filter ebtables ip6table_nat nf_conntrack_ipv6 nf_de
frag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6
_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ipt
able_mangle iptable_security iptable_raw rfcomm bnep snd_hda_codec_hdmi snd_hda_codec_co
nexant iTCO_wdt iTCO_vendor_support arc4 x86_pkg_temp_thermal coretemp iwldvm microcode 
btusb snd_hda_intel mac80211 bluetooth joydev snd_hda_codec snd_hwdep snd_seq serio_raw 
iwlwifi i2c_i801 snd_seq_device
[48002.776894]  snd_pcm cfg80211 sdhci_pci sdhci mmc_core thinkpad_acpi wmi tpm_tis e100
0e rfkill snd_page_alloc tpm tpm_bios snd_timer ptp snd mei_me mei soundcore shpchp lpc_
ich pps_core mfd_core mperf xen_acpi_processor xen_netback xen_blkback xen_gntdev xen_ev
tchn xenfs xen_privcmd uinput binfmt_misc nfsd auth_rpcgss nfs_acl lockd sunrpc dm_crypt
 crc32_pclmul crc32c_intel i915 ghash_clmulni_intel i2c_algo_bit drm_kms_helper drm i2c_
core video
[48002.776903] CPU: 0 PID: 10235 Comm: systemd-sleep Not tainted 3.11.7-200.fc19.x86_64 #1
[48002.776905] Hardware name: LENOVO 4286CTO/4286CTO, BIOS 8DET59WW (1.29 ) 04/02/2012
[48002.776917]  0000000000000009 ffff8801c7697d30 ffffffff8164777b ffff8801c7697d78
[48002.776924]  ffff8801c7697d68 ffffffff8106715d ffffffffa01f6000 0000000000000003
[48002.776931]  ffff8801c7697e08 ffff8801fd970000 0000000000000000 ffff8801c7697dc8
[48002.776933] Call Trace:
[48002.776949]  [<ffffffff8164777b>] dump_stack+0x45/0x56
[48002.776959]  [<ffffffff8106715d>] warn_slowpath_common+0x7d/0xa0
[48002.776972]  [<ffffffff810671cc>] warn_slowpath_fmt+0x4c/0x50
[48002.776989]  [<ffffffffa01f4bb0>] ? xen_upload_processor_pm_data+0x300/0x300 [xen_acpi_processor]
[48002.776996]  [<ffffffff813f252a>] syscore_resume+0x9a/0xe0
[48002.777006]  [<ffffffff810abd7c>] suspend_devices_and_enter+0x40c/0x480
[48002.777014]  [<ffffffff810abf68>] pm_suspend+0x178/0x260
[48002.777020]  [<ffffffff810aae19>] state_store+0x79/0xf0
[48002.777033]  [<ffffffff812fc4af>] kobj_attr_store+0xf/0x20
[48002.777043]  [<ffffffff8121a226>] sysfs_write_file+0xc6/0x140
[48002.777054]  [<ffffffff811a819d>] vfs_write+0xbd/0x1e0
[48002.777062]  [<ffffffff811a8bd9>] SyS_write+0x49/0xa0
[48002.777073]  [<ffffffff81656999>] system_call_fastpath+0x16/0x1b
[48002.777077] ---[ end trace 15c5658c596be9f3 ]---
[48002.777081] Enabling non-boot CPUs ...


I wonder if this is a result of upload_pm_data()'s use of mutexes, which
being a sleeping synchronization operation, shouldn't be done in an
interrupt-off context.

I'm also having the machine hang in the suspended state on resume
sometimes (that is, I open the lid/hit a key/press power to resume the
laptop, but the sleep light keeps pulsing and I can't get it out of that
state without a forced power-off. I wonder if these are related.

This is with the stock Fedora 19 kernel, but I don't think there are any
differences from upstream in this area?

Thanks,
    J

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094AbaIFRmw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 13:42:52 -0400
Received: from mout.gmx.net ([212.227.15.19]:63373 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751532AbaIFRmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 13:42:50 -0400
Message-ID: <540B4797.9060309@gmx.de>
Date: Sat, 06 Sep 2014 19:42:47 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: 3.16.2: kernel BUG at fs/buffer.c:3018!
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:w5qRmlQTsGH409+GvVEEa9A5HGQ80wOyvO8lnc/ebGQFEzr2Zxk
 sqlof+2zA/huM6a3Bljgpg/F0qtGo/zfc8atbcCh5xn3TiFCByRzUbg8Vsbku+B8m1rlNj5
 h6nTTvaSsieedaew4jl9XnERMSpjNGfusnT+f6lA1zPGce0k3phOYOBp62f0gZLKNuzygVj
 8puzDRVmxLtPDl4Aa2HLQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well,

definitely I made a mistake during my first attempts to mount a qcow2 image file via a loop devices - but the BUG shouldn't occur, or ? :

System is a 32 bit stable Gentoo.


ep  6 19:37:05 n22 kernel: kernel BUG at fs/buffer.c:3018!
Sep  6 19:37:05 n22 kernel: invalid opcode: 0000 [#1] SMP
Sep  6 19:37:05 n22 kernel: Modules linked in: nbd nfsd auth_rpcgss oid_registry ip6t_REJECT ip6table_filter ip6_tables ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat xt_owner xt_LOG xt_limit xt_multiport ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 xt_tcpudp xt_recent xt_conntrack iptable_filter ip_tables x_tables nf_conntrack_ftp nf_conntrack ctr ccm af_packet bridge stp ipv6 llc tun x86_pkg_temp_thermal coretemp kvm_intel kvm snd_hda_codec_conexant snd_hda_codec_generic i915 snd_hda_intel snd_hda_controller sdhci_pci snd_hda_codec psmouse arc4 iwldvm sdhci mac80211 evdev uvcvideo videobuf2_vmalloc fbcon videobuf2_memops videobuf2_core bitblit cfbfillrect softcursor v4l2_common cfbimgblt font videodev i2c_algo_bit cfbcopyarea thinkpad_acpi snd_pcm atkbd drm_kms_helper snd_timer nvram mmc_core drm intel_gtt snd thermal iwlwifi agpgart wmi video 8250_pci 8250 serial_core soundcore e1000e ac battery cfg80211 tpm_tis i2c_i801 i2c_core fb fbdev rfkill ptp button tpm pps_core acpi_cpufreq p
rocessor thermal_sys hwmon aesni_intel xts aes_i586 lrw gf128mul ablk_helper cryptd cbc fuse nfs lockd sunrpc btrfs xor raid6_pq dm_crypt dm_mod hid_monterey hid_microsoft hid_logitech hid_ezkey hid_cypress hid_chicony hid_cherry hid_belkin hid_apple hid_a4tech hid_generic usbhid uhci_hcd hid sr_mod cdrom sg [last unloaded: microcode]
Sep  6 19:37:05 n22 kernel: CPU: 2 PID: 27864 Comm: umount Not tainted 3.16.2 #9
Sep  6 19:37:05 n22 kernel: Hardware name: LENOVO 4180F65/4180F65, BIOS 83ET75WW (1.45 ) 05/10/2013
Sep  6 19:37:05 n22 kernel: task: e38c0b30 ti: e3e5c000 task.ti: e3e5c000
Sep  6 19:37:05 n22 kernel: EIP: 0060:[<c1173c07>] EFLAGS: 00010246 CPU: 2
Sep  6 19:37:05 n22 kernel: EIP is at _submit_bh+0x257/0x260
Sep  6 19:37:05 n22 kernel: EAX: 00000005 EBX: 00000000 ECX: 00000000 EDX: e8b8bc78
Sep  6 19:37:05 n22 kernel: ESI: e8b8bc78 EDI: 00000411 EBP: e3e5de8c ESP: e3e5de60
Sep  6 19:37:05 n22 kernel: DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Sep  6 19:37:05 n22 kernel: CR0: 80050033 CR2: 093ef038 CR3: 30b54000 CR4: 000407f0
Sep  6 19:37:05 n22 kernel: Stack:
Sep  6 19:37:05 n22 kernel: 00000001 00000046 c12610b5 00000282 e6c878fc 00000282 e3e5de88 00000282
Sep  6 19:37:05 n22 kernel: e8b8bc78 00000411 e8b8bc78 e3e5dea0 c1173d8e 00007914 00000000 e6c85000
Sep  6 19:37:05 n22 kernel: e3e5dea8 c1173e12 e3e5dedc c11c6c2a c13ffe82 c15fa700 e3e5ded4 00000001
Sep  6 19:37:05 n22 kernel: Call Trace:
Sep  6 19:37:05 n22 kernel: [<c12610b5>] ? __percpu_counter_sum+0x85/0xa0
Sep  6 19:37:05 n22 kernel: [<c1173d8e>] __sync_dirty_buffer+0x5e/0xd0
Sep  6 19:37:05 n22 kernel: [<c1173e12>] sync_dirty_buffer+0x12/0x20
Sep  6 19:37:05 n22 kernel: [<c11c6c2a>] ext4_commit_super+0x19a/0x230
Sep  6 19:37:05 n22 kernel: [<c13ffe82>] ? _raw_spin_unlock+0x22/0x30
Sep  6 19:37:05 n22 kernel: [<c11c7520>] ext4_put_super+0xb0/0x300
Sep  6 19:37:05 n22 kernel: [<c115e412>] ? dispose_list+0x32/0x40
Sep  6 19:37:05 n22 kernel: [<c115f022>] ? evict_inodes+0xe2/0xf0
Sep  6 19:37:05 n22 kernel: [<c1147297>] generic_shutdown_super+0x67/0xe0
Sep  6 19:37:05 n22 kernel: [<c1108900>] ? unregister_shrinker+0x40/0x50
Sep  6 19:37:05 n22 kernel: [<c11475b2>] kill_block_super+0x22/0x70
Sep  6 19:37:05 n22 kernel: [<c114797d>] deactivate_locked_super+0x3d/0x50
Sep  6 19:37:05 n22 kernel: [<c1147ea3>] deactivate_super+0x43/0x60
Sep  6 19:37:05 n22 kernel: [<c11624b5>] mntput_no_expire+0xf5/0x180
Sep  6 19:37:05 n22 kernel: [<c11623d2>] ? mntput_no_expire+0x12/0x180
Sep  6 19:37:05 n22 kernel: [<c1163a65>] SyS_oldumount+0x75/0xb0
Sep  6 19:37:05 n22 kernel: [<c1400817>] sysenter_do_call+0x12/0x12
Sep  6 19:37:05 n22 kernel: Code: f0 80 66 01 f7 e9 1e fe ff ff 8d 76 00 8d bc 27 00 00 00 00 39 45 e8 76 8b e9 1e ff ff ff 0f 0b 0f 0b 0f 0b f3 90 e9 c2 fe ff ff <0f> 0b 0f 0b 90 8d 74 26 00 55 89 e5 66 66 66 66 90 31 c9 e8 91
Sep  6 19:37:05 n22 kernel: EIP: [<c1173c07>] _submit_bh+0x257/0x260 SS:ESP 0068:e3e5de60
Sep  6 19:37:05 n22 kernel: ---[ end trace d75285e0ad72f2d1 ]---
Sep  6 19:37:18 n22 kernel: block nbd0: NBD_DISCONNECT
S

FWIW my mistake was to to run the commands

$> qemu-nbd -c /dev/nbd0 -P 3 /var/lib/libvirt/images/Gentoo-clone.qcow2
$> mount /dev/nbd0 /mnt/ramdisk/n0
$> umount /mnt/ramdisk/n0

in the wrong order.

-- 
Toralf
pgp key: 0076 E94E


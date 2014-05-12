Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758433AbaELNV4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 09:21:56 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:36039 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758264AbaELNVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 09:21:54 -0400
MIME-Version: 1.0
Date: Mon, 12 May 2014 09:21:53 -0400
X-Google-Sender-Auth: wgDxT4vRK9PnH0hWH-gBnrO98OI
Message-ID: <CA+5PVA480wkD1xhWbhPVGoHeG=T3F3zeEwAPbEatUmmX_L5h-w@mail.gmail.com>
Subject: 3.15-rc5 soft-lockup in dentry_kill
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
        Miklos Szeredi <mszeredi@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

We got a report[1] of udevd hanging up in a soft lockup with 3.15-rc5
over the weekend.  The backtrace is below.  I know there were a number
of recent changes here, so hopefully this triggers someone's memory.

josh

[1] https://bugzilla.redhat.com/show_bug.cgi?id=1096572

BUG: soft lockup - CPU#6 stuck for 23s! [systemd-udevd:9995]
Modules linked in: des_generic md4 nls_utf8 cifs rpcsec_gss_krb5
auth_rpcgss nfsv4 dns_resolver nfs lockd fscache bnep bluetooth fuse
xt_CHECKSUM ipt_MASQUERADE ip6t_rpfilter ip6t_REJECT xt_conntrack
cfg80211 ebtable_nat ebtable_broute bridge stp llc ebtable_filter
ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6
ip6table_mangle ip6table_security ip6table_raw ip6table_filter
ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4
nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw
s5h1411 snd_virtuoso snd_oxygen_lib snd_hda_codec_hdmi
snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel
snd_hda_controller snd_hda_codec snd_mpu401_uart eeepc_wmi cx25840
asus_wmi cx23885 btcx_risc sparse_keymap rfkill iTCO_wdt altera_ci
videobuf_dvb tda18271 iTCO_vendor_support altera_stapl snd_usb_audio
tveeprom cx2341x snd_usbmidi_lib videobuf_dma_sg videobuf_core
dvb_core snd_rawmidi snd_hwdep snd_seq snd_seq_device snd_pcm
x86_pkg_temp_thermal rc_core coretemp v4l2_common r8169 videodev
ums_realtek kvm_intel uas usb_storage usblp ftdi_sio snd_timer media
mii joydev mei_me lpc_ich mfd_core snd i2c_i801 shpchp serio_raw mei
soundcore kvm crct10dif_pclmul crc32_pclmul crc32c_intel
ghash_clmulni_intel microcode binfmt_misc sunrpc nouveau mxm_wmi
i2c_algo_bit drm_kms_helper ttm drm i2c_core wmi video
CPU: 6 PID: 9995 Comm: systemd-udevd Not tainted
3.15.0-0.rc5.git0.1.fc21.x86_64 #1
Hardware name: System manufacturer System Product Name/P8Z77-V LE
PLUS, BIOS 0908 12/10/2013
task: ffff8807c0e3ce80 ti: ffff8807c148c000 task.ti: ffff8807c148c000
RIP: 0010:[<ffffffff81206e82>]  [<ffffffff81206e82>] dentry_kill+0x22/0x2b0
RSP: 0018:ffff8807c148dba8  EFLAGS: 00000246
RAX: 00000000004000c4 RBX: fefefefefefefeff RCX: dead000000200200
RDX: ffff8807e2922c80 RSI: 0000000000000000 RDI: ffff8807e2922840
RBP: ffff8807c148dbc8 R08: ffff8807e29228c0 R09: 8080808080808080
R10: fefefefefefefeff R11: ffff880751bdf840 R12: ffff880751bdfb40
R13: ffff8807c148db98 R14: ffff8807c148db30 R15: ffffffff810bbfa7
FS:  00007fe8074d0880(0000) GS:ffff88081ed80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe807504000 CR3: 000000079a2ea000 CR4: 00000000001407e0
Stack:
 ffff8807e29228c0 ffff8807e2922780 ffff8807c148dc10 ffff8807e2922840
 ffff8807c148dbf8 ffffffff8120734b ffff8807c148dc10 ffff880751bdf840
 0000000000000024 ffff8807c148de50 ffff8807c148dc48 ffffffff8120767c
Call Trace:
 [<ffffffff8120734b>] shrink_dentry_list+0x7b/0x120
 [<ffffffff8120767c>] check_submounts_and_drop+0x7c/0xb0
 [<ffffffff8126a96d>] kernfs_dop_revalidate+0x5d/0xd0
 [<ffffffff811f9f06>] lookup_fast+0x276/0x2f0
 [<ffffffff812f043c>] ? security_inode_permission+0x1c/0x30
 [<ffffffff811fb057>] link_path_walk+0x1d7/0xec0
 [<ffffffff8120fc24>] ? mntput+0x24/0x40
 [<ffffffff811fbe4e>] ? path_lookupat+0x10e/0xd70
 [<ffffffff811fa716>] ? getname_flags+0x56/0x1b0
 [<ffffffff811fbda7>] path_lookupat+0x67/0xd70
 [<ffffffff811fa692>] ? final_putname+0x22/0x50
 [<ffffffff81200f32>] ? user_path_at_empty+0x72/0xd0
 [<ffffffff811d2225>] ? kmem_cache_alloc+0x35/0x1f0
 [<ffffffff811fa716>] ? getname_flags+0x56/0x1b0
 [<ffffffff811fcada>] filename_lookup+0x2a/0xd0
 [<ffffffff81200f27>] user_path_at_empty+0x67/0xd0
 [<ffffffff811f492b>] SyS_readlink+0x5b/0x130
 [<ffffffff817119e9>] system_call_fastpath+0x16/0x1b
Code: 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 89 e5 41 56 41
55 41 54 53 48 89 fb 8b 07 f6 c4 80 0f 85 1a 02 00 00 4c 8b 6f 30 <41>
89 f6 4d 85 ed 74 2e 49 8d bd 88 00 00 00 e8 4a 13 50 00 85

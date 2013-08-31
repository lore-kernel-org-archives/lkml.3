Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537Ab3HaRl3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 13:41:29 -0400
Received: from plane.gmane.org ([80.91.229.3]:33341 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753901Ab3HaRl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 13:41:28 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: ael <law_ence.dev@ntlworld.com>
Subject: Re: Crashes on 3.0.11-rc7: skge Oops
Date: Sat, 31 Aug 2013 18:41:12 +0100
Message-ID: <kvt9rg$bc1$1@ger.gmane.org>
References: <kvsve9$5ou$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: cpc2-oxfd23-2-0-cust674.4-3.cable.virginmedia.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
In-Reply-To: <kvsve9$5ou$1@ger.gmane.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A related Oops when I gave an "ifdown eth0" command - but that was in 
response to a failing nfs mount command, so the underlying error had 
presumably already occurred :-

-------- extract from /var/log/messages -------------------
Aug 31 18:16:17 conquest2 kernel: NFSD: Using /var/lib/nfs/v4recovery as 
the NFSv4 state recovery di
rectory
Aug 31 18:16:17 conquest2 kernel: NFSD: starting 90-second grace period 
(net ffffffff81511f20)
Aug 31 18:17:05 conquest2 kernel: NFS: Registering the id_resolver key type
Aug 31 18:17:05 conquest2 kernel: Key type id_resolver registered
Aug 31 18:17:05 conquest2 kernel: Key type id_legacy registered
Aug 31 18:17:20 conquest2 kernel: RPC: AUTH_GSS upcall timed out.
Aug 31 18:17:20 conquest2 kernel: Please check user daemon is running.
Aug 31 18:18:10 conquest2 kernel: NFS: nfs4_discover_server_trunking 
unhandled error -512. Exiting w
ith error EIO
Aug 31 18:18:23 conquest2 kernel: skge 0000:05:0c.0 eth0: disabling 
interface
Aug 31 18:18:23 conquest2 kernel: PGD 7b8dc067 PUD 73463067 PMD 0
Aug 31 18:18:23 conquest2 kernel: Oops: 0000 [#1]
Aug 31 18:18:23 conquest2 kernel: Modules linked in: rpcsec_gss_krb5 
nfsv4 snd_hrtimer cpufreq_users
pace cpufreq_stats cpufreq_powersave lp hwmon_vid nfsd auth_rpcgss 
oid_registry exportfs nfs_acl nfs
  lockd sunrpc ipv6 analog joydev dm_crypt dm_mod snd_intel8x0 
snd_ac97_codec fbcon ac97_bus bitblit
snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy softcursor nouveau video 
backlight mxm_wmi wmi ttm s
nd_page_alloc font snd_mpu401 snd_mpu401_uart snd_seq_oss snd_seq_midi 
sg snd_rawmidi drm_kms_helper
  snd_seq_midi_event sr_mod snd_seq snd_seq_device drm cdrom snd_timer 
forcedeth k8temp snd parport_p
c ohci_pci ohci_hcd ns558 hwmon ehci_pci gameport ehci_hcd parport evdev 
i2c_algo_bit psmouse pcspkr
  serio_raw soundcore i2c_nforce2 processor thermal i2c_core floppy 
button unix
Aug 31 18:18:23 conquest2 kernel: CPU: 0 PID: 4669 Comm: ip Not tainted 
3.11.0-rc7_c2+ #100
Aug 31 18:18:23 conquest2 kernel: Hardware name: System manufacturer 
System name/A8N-SLI DELUXE, BIO
S ASUS A8N-SLI DELUXE ACPI BIOS Revision 1805 09/29/2006
Aug 31 18:18:23 conquest2 kernel: task: ffff88007341cdb0 ti: 
ffff88007353a000 task.ti: ffff88007353a
000
Aug 31 18:18:23 conquest2 kernel: RIP: 0010:[<ffffffff810e098a>] 
[<ffffffff810e098a>] kfree+0x6a/0x
d0
Aug 31 18:18:23 conquest2 kernel: RSP: 0018:ffff88007353b6c8  EFLAGS: 
00010046
Aug 31 18:18:23 conquest2 kernel: RAX: 0000000000000000 RBX: 
ffff880073498cc0 RCX: 4000000000000000
Aug 31 18:18:23 conquest2 kernel: RDX: ffffea0001938140 RSI: 
0000000000000001 RDI: 0000000000000001
Aug 31 18:18:23 conquest2 kernel: RBP: ffff88007353b6e0 R08: 
0000000000000304 R09: 0000000000000000
Aug 31 18:18:23 conquest2 kernel: R10: ffffc90000018434 R11: 
ffffc90000018000 R12: 0000000000000286
Aug 31 18:18:23 conquest2 kernel: R13: ffff880073498c00 R14: 
0000000000000000 R15: ffff88007c85c000
Aug 31 18:18:23 conquest2 kernel: FS:  00007effcca8a700(0000) 
GS:ffffffff814df000(0000) knlGS:0000000000000000
Aug 31 18:18:23 conquest2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 
000000008005003b
Aug 31 18:18:23 conquest2 kernel: CR2: 0000000000000081 CR3: 
0000000079894000 CR4: 00000000000007f0
Aug 31 18:18:23 conquest2 kernel: Stack:
Aug 31 18:18:23 conquest2 kernel: ffff880073498cc0 ffff88007c85c660 
ffff880078de7bc0 ffff88007353b6f0
Aug 31 18:18:23 conquest2 kernel: ffffffff81300a7c ffff88007353b718 
ffffffff81302b22 ffff880078de7bc0
Aug 31 18:18:23 conquest2 kernel: ffff88007c85c660 ffff88007c80ea40 
ffff88007353b730 ffffffff81302b4f
Aug 31 18:18:23 conquest2 kernel: Call Trace:
Aug 31 18:18:23 conquest2 kernel: [<ffffffff81300a7c>] 
skb_free_head+0x6c/0x80
Aug 31 18:18:23 conquest2 kernel: [<ffffffff81302b22>] 
skb_release_data+0xe2/0xf0
Aug 31 18:18:23 conquest2 kernel: [<ffffffff81302b4f>] 
skb_release_all+0x1f/0x30
Aug 31 18:18:23 conquest2 kernel: [<ffffffff81302b6d>] __kfree_skb+0xd/0x90
Aug 31 18:18:23 conquest2 kernel: [<ffffffff81302c08>] consume_skb+0x18/0x40
Aug 31 18:18:23 conquest2 kernel: [<ffffffff812b4dab>] 
skge_rx_clean+0x4b/0xa0
Aug 31 18:18:23 conquest2 kernel: [<ffffffff812b8a45>] skge_down+0x3f5/0x520
Aug 31 18:18:23 conquest2 kernel: [<ffffffff8130a955>] 
__dev_close_many+0x75/0xc0
Aug 31 18:18:23 conquest2 kernel: [<ffffffff8130a9c8>] __dev_close+0x28/0x40
Aug 31 18:18:23 conquest2 kernel: [<ffffffff8130e6cc>] 
__dev_change_flags+0x9c/0x180
Aug 31 18:18:23 conquest2 kernel: [<ffffffff8130e863>] 
dev_change_flags+0x23/0x70
Aug 31 18:18:23 conquest2 kernel: [<ffffffff8131a729>] 
do_setlink+0x339/0x910
Aug 31 18:18:23 conquest2 kernel: [<ffffffff810ba6b9>] ? 
lru_cache_add+0x9/0x10
Aug 31 18:18:23 conquest2 kernel: [<ffffffff810d5847>] ? 
page_add_new_anon_rmap+0x77/0x100
Aug 31 18:18:23 conquest2 kernel: [<ffffffff810cc590>] ? 
handle_pte_fault+0x5f0/0x6c0
Aug 31 18:18:23 conquest2 kernel: [<ffffffff811f8901>] ? nla_parse+0x31/0xd0
Aug 31 18:18:23 conquest2 kernel: [<ffffffff8131bb49>] 
rtnl_newlink+0x359/0x520
Aug 31 18:18:23 conquest2 kernel: [<ffffffff810cd979>] ? 
handle_mm_fault+0x1f9/0x2d0
Aug 31 18:18:23 conquest2 kernel: [<ffffffff8105304c>] ? 
__do_page_fault+0x1ac/0x470
Aug 31 18:18:23 conquest2 kernel: [<ffffffff8131b640>] 
rtnetlink_rcv_msg+0xa0/0x250
Aug 31 18:18:23 conquest2 kernel: [<ffffffff8131b5a0>] ? 
__rtnl_unlock+0x20/0x20
Aug 31 18:18:23 conquest2 kernel: [<ffffffff813270f9>] 
netlink_rcv_skb+0xa9/0xc0
Aug 31 18:18:23 conquest2 kernel: [<ffffffff8131a1c1>] 
rtnetlink_rcv+0x21/0x30
Aug 31 18:18:23 conquest2 kernel: [<ffffffff81326a29>] 
netlink_unicast+0x149/0x1c0
Aug 31 18:18:23 conquest2 kernel: [<ffffffff81326e72>] 
netlink_sendmsg+0x322/0x3e0
Aug 31 18:18:23 conquest2 kernel: [<ffffffff812f7489>] 
sock_sendmsg+0x79/0xa0
Aug 31 18:18:23 conquest2 kernel: [<ffffffff810b205a>] ? 
filemap_fault+0xba/0x400
Aug 31 18:18:23 conquest2 kernel: [<ffffffff812f78b4>] 
___sys_sendmsg+0x344/0x350
Aug 31 18:18:23 conquest2 kernel: [<ffffffff810cc590>] ? 
handle_pte_fault+0x5f0/0x6c0
Aug 31 18:18:23 conquest2 kernel: [<ffffffff810cd979>] ? 
handle_mm_fault+0x1f9/0x2d0
Aug 31 18:18:23 conquest2 kernel: [<ffffffff8105304c>] ? 
__do_page_fault+0x1ac/0x470
Aug 31 18:18:23 conquest2 kernel: [<ffffffff81103c1f>] ? mntput+0x1f/0x30
Aug 31 18:18:23 conquest2 kernel: [<ffffffff810eb0a8>] ? __fput+0x128/0x230
Aug 31 18:18:23 conquest2 kernel: [<ffffffff812fa914>] 
__sys_sendmsg+0x44/0x80
Aug 31 18:18:23 conquest2 kernel: [<ffffffff812fa95d>] SyS_sendmsg+0xd/0x20
Aug 31 18:18:23 conquest2 kernel: [<ffffffff81388bd0>] 
system_call_fastpath+0x16/0x1b
Aug 31 18:18:23 conquest2 kernel: Code: c1 ea 0c 48 8d 0c d5 00 00 00 00 
48 c1 e2 06 48 29 ca 48 b9 00 00 00 00 00 ea ff ff 48 01 ca 48 8b 0a 80 
e5 80 75 5c 48 8b 7a 30 <48> 8b 9f 80 00 00 00 8b 43 04 39 03 73 3e 66 
66 66 66 90 8b 13
Aug 31 18:18:23 conquest2 kernel: RSP <ffff88007353b6c8>
Aug 31 18:18:23 conquest2 kernel: CR2: 0000000000000081
Aug 31 18:18:23 conquest2 kernel: ---[ end trace f7170d2c01528cff ]---

=============================================================================

That really was 3.11.0-rc7. config as attached to first post in this thread.

ael


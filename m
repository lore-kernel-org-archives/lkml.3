Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756327Ab3BALkA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 06:40:00 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:41743 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044Ab3BALj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 06:39:58 -0500
Date: Fri, 1 Feb 2013 13:39:48 +0200 (EET)
From: Tero Roponen <tero.roponen@gmail.com>
X-X-Sender: terrop@terrop.lan
To: miklos@szeredi.hu
cc: fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: User-triggerable WARNING with fuse
Message-ID: <alpine.LFD.2.03.1302011328410.6240@gmail.com>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463792895-1291152302-1359718795=:6240"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463792895-1291152302-1359718795=:6240
Content-Type: TEXT/PLAIN; charset=US-ASCII


Using the attached program I can trigger the following WARNING
reliably as a normal user. This happens at least both in 3.8-rc6
and 3.7.5.

The kernel is tainted by proprietary NVIDIA module, but I don't
thinks it matters in this case.

[ 4390.882323] ------------[ cut here ]------------
[ 4390.882342] WARNING: at fs/inode.c:280 drop_nlink+0x41/0x50()
[ 4390.882345] Hardware name: M50Vm               
[ 4390.882347] Modules linked in: fuse rfcomm bnep snd_hda_codec_hdmi 
nvidia(PO) snd_hda_codec_realtek snd_hda_intel iwldvm snd_hda_codec 
snd_hwdep uvcvideo btusb videobuf2_vmalloc videobuf2_memops videobuf2_core 
mac80211 bluetooth snd_seq snd_seq_device snd_pcm asus_laptop iwlwifi 
cfg80211 snd_page_alloc snd_timer videodev r8169 input_polldev 
sparse_keymap snd soundcore kvm_intel kvm microcode rfkill i2c_core mii 
pcspkr uinput hid_generic firewire_ohci sdhci_pci sdhci mmc_core 
firewire_core crc_itu_t
[ 4390.882438] Pid: 6040, comm: rm Tainted: P        W  O 3.8.0-rc6 #1
[ 4390.882442] Call Trace:
[ 4390.882453]  [<ffffffff81032eca>] warn_slowpath_common+0x7a/0xb0
[ 4390.882460]  [<ffffffff81032f15>] warn_slowpath_null+0x15/0x20
[ 4390.882466]  [<ffffffff81101dd1>] drop_nlink+0x41/0x50
[ 4390.882478]  [<ffffffffa00d261f>] fuse_unlink+0xdf/0x130 [fuse]
[ 4390.882486]  [<ffffffff810f6cfd>] vfs_unlink+0x8d/0x100
[ 4390.882493]  [<ffffffff810f6f09>] do_unlinkat+0x199/0x220
[ 4390.882501]  [<ffffffff81092e82>] ? call_rcu_sched+0x12/0x20
[ 4390.882508]  [<ffffffff81057c2a>] ? __put_cred+0x3a/0x50
[ 4390.882516]  [<ffffffff810e9977>] ? sys_faccessat+0x137/0x1e0
[ 4390.882524]  [<ffffffff810f94b6>] sys_unlinkat+0x16/0x40
[ 4390.882532]  [<ffffffff81490c16>] system_call_fastpath+0x1a/0x1f
[ 4390.882536] ---[ end trace 372eef394febff4c ]---
---1463792895-1291152302-1359718795=:6240
Content-Type: TEXT/plain; name=warn.c
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.LFD.2.03.1302011339480.6240@gmail.com>
Content-Description: 
Content-Disposition: attachment; filename=warn.c

LyoNCiAqICQgZ2NjIHdhcm4uYyAtbyB3YXJuIC1EX0ZJTEVfT0ZGU0VUX0JJ
VFM9NjQgLURGVVNFX1VTRV9WRVJTSU9OPTI2IC1sZnVzZQ0KICoNCiAqICQg
bWtkaXIgbW50DQogKiAkIC4vd2FybiBtbnQNCiAqICQgcm0gbW50L2Zvbw0K
ICovDQoNCiNpbmNsdWRlIDxmdXNlL2Z1c2UuaD4NCg0Kc3RhdGljIGludCBy
ZWFkZGlyX29wKGNvbnN0IGNoYXIgKnBhdGgsIHZvaWQgKmJ1ZiwNCglmdXNl
X2ZpbGxfZGlyX3QgZmlsbGVyLCBvZmZfdCBvZmZzZXQsDQoJc3RydWN0IGZ1
c2VfZmlsZV9pbmZvICpmaSkNCnsNCglzdHJ1Y3Qgc3RhdCBzdCA9IHsuc3Rf
bW9kZSA9IFNfSUZSRUcgfCAwNjY2fTsNCglmaWxsZXIoYnVmLCAiZm9vIiwg
JnN0LCAwKTsNCglyZXR1cm4gMDsNCn0NCg0Kc3RhdGljIGludCBnZXRhdHRy
X29wKGNvbnN0IGNoYXIgKnBhdGgsIHN0cnVjdCBzdGF0ICpzdCkNCnsNCglp
ZiAoc3RyY21wKHBhdGgsICIvIikgPT0gMCkNCgkJc3QtPnN0X21vZGUgPSBT
X0lGRElSIHwgMDc3NzsNCgllbHNlDQoJCXN0LT5zdF9tb2RlID0gU19JRlJF
RyB8IDA2NjY7DQoJcmV0dXJuIDA7DQp9DQoNCnN0YXRpYyBpbnQgdW5saW5r
X29wKGNvbnN0IGNoYXIgKnBhdGgpDQp7DQoJcmV0dXJuIDA7DQp9DQoNCnN0
YXRpYyBzdHJ1Y3QgZnVzZV9vcGVyYXRpb25zIG9wcyA9IHsNCgkucmVhZGRp
ciA9IHJlYWRkaXJfb3AsDQoJLmdldGF0dHIgPSBnZXRhdHRyX29wLA0KCS51
bmxpbmsgPSB1bmxpbmtfb3AsDQp9Ow0KDQppbnQgbWFpbihpbnQgYXJnYywg
Y2hhciAqYXJndltdKQ0Kew0KCXJldHVybiBmdXNlX21haW4oYXJnYywgYXJn
diwgJm9wcywgTlVMTCk7DQp9DQo=

---1463792895-1291152302-1359718795=:6240--

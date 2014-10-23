Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961AbaJWNtZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 09:49:25 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:35426 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270AbaJWNtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 09:49:14 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-2a-544907571fd0
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, linux-security-module@vger.kernel.org,
        linux-ima-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, dmitry.kasatkin@gmail.com,
        Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH 1/2] ima: check xattr value length in ima_inode_setxattr()
Date: Thu, 23 Oct 2014 16:47:17 +0300
Message-id: <5b1f234e8515c10c96a16868ff4341f29460f38f.1414071910.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <cover.1414071910.git.d.kasatkin@samsung.com>
References: <cover.1414071910.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1414071910.git.d.kasatkin@samsung.com>
References: <cover.1414071910.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplluLIzCtJLcpLzFFi42I5/e/4Nd1wds8Qg8+LNC1u/d3LbPFlaZ3F
	7OnNTBYvZ8xjt7i8aw6bxYeeR2wWn1ZMYnZg99g56y67x4NDm1k8di/4zOTRt2UVo8eZBUfY
	PT5vkgtgi+KySUnNySxLLdK3S+DK6F6ZXHBJpmL6o/fsDYxzJboYOTgkBEwkTt1Q6WLkBDLF
	JC7cW8/WxcjFISSwlFHi3+UbTCAJIYFOJolT7QkgNpuAnsSG5h/sILaIQI7Eoz+vwWxmgVKJ
	D98vMoPYwgJeEo+WnGIFsVkEVCU2/LwJVsMrECdxeNodZohlchInj01mBbmBU8BKYvX2YohV
	lhKPTvax4BCewMi/gJFhFaNoamlyQXFSeq6hXnFibnFpXrpecn7uJkZIEH7Zwbj4mNUhRgEO
	RiUe3opkjxAh1sSy4srcQ4wSHMxKIrzxrJ4hQrwpiZVVqUX58UWlOanFhxiZODilGhjbbt6d
	yPX3yJlnvqZOr7+sqfc8WmEpOz13QU/XYSbhkjn6LiUMU59e6QhztrSxV+PO3Llze5TQxq/S
	/Ifroq7efFdZdlI8xVPu1ZQ0z46fRVV3k6WNrW38fV9KfblfqFHD/m/xuUdiu06zLJLc/XNb
	7pebkn57lZ7v3W0qsoIjm+fMnmvzOoWUWIozEg21mIuKEwFjk5J+IAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ima_inode_setxattr() can be called with no value. Function does not
check the length so that following command can be used to produce
kernel oops: setfattr -n security.ima FOO. This patch fixes it.

[  261.562522] BUG: unable to handle kernel NULL pointer dereference at           (null)
[  261.564109] IP: [<ffffffff812af272>] ima_inode_setxattr+0x3e/0x5a
[  261.564109] PGD 3112f067 PUD 42965067 PMD 0
[  261.564109] Oops: 0000 [#1] SMP
[  261.564109] Modules linked in: bridge stp llc evdev serio_raw i2c_piix4 button fuse
[  261.564109] CPU: 0 PID: 3299 Comm: setxattr Not tainted 3.16.0-kds+ #2924
[  261.564109] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  261.564109] task: ffff8800428c2430 ti: ffff880042be0000 task.ti: ffff880042be0000
[  261.564109] RIP: 0010:[<ffffffff812af272>]  [<ffffffff812af272>] ima_inode_setxattr+0x3e/0x5a
[  261.564109] RSP: 0018:ffff880042be3d50  EFLAGS: 00010246
[  261.564109] RAX: 0000000000000001 RBX: 0000000000000000 RCX: 0000000000000015
[  261.564109] RDX: 0000001500000000 RSI: 0000000000000000 RDI: ffff8800375cc600
[  261.564109] RBP: ffff880042be3d68 R08: 0000000000000000 R09: 00000000004d6256
[  261.564109] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88002149ba00
[  261.564109] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  261.564109] FS:  00007f6c1e219740(0000) GS:ffff88005da00000(0000) knlGS:0000000000000000
[  261.564109] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  261.564109] CR2: 0000000000000000 CR3: 000000003b35a000 CR4: 00000000000006f0
[  261.564109] Stack:
[  261.564109]  ffff88002149ba00 ffff880042be3df8 0000000000000000 ffff880042be3d98
[  261.564109]  ffffffff812a101b ffff88002149ba00 ffff880042be3df8 0000000000000000
[  261.564109]  0000000000000000 ffff880042be3de0 ffffffff8116d08a ffff880042be3dc8
[  261.564109] Call Trace:
[  261.564109]  [<ffffffff812a101b>] security_inode_setxattr+0x48/0x6a
[  261.564109]  [<ffffffff8116d08a>] vfs_setxattr+0x6b/0x9f
[  261.564109]  [<ffffffff8116d1e0>] setxattr+0x122/0x16c
[  261.564109]  [<ffffffff811687e8>] ? mnt_want_write+0x21/0x45
[  261.564109]  [<ffffffff8114d011>] ? __sb_start_write+0x10f/0x143
[  261.564109]  [<ffffffff811687e8>] ? mnt_want_write+0x21/0x45
[  261.564109]  [<ffffffff811687c0>] ? __mnt_want_write+0x48/0x4f
[  261.564109]  [<ffffffff8116d3e6>] SyS_setxattr+0x6e/0xb0
[  261.564109]  [<ffffffff81529da9>] system_call_fastpath+0x16/0x1b
[  261.564109] Code: 48 89 f7 48 c7 c6 58 36 81 81 53 31 db e8 73 27 04 00 85 c0 75 28 bf 15 00 00 00 e8 8a a5 d9 ff 84 c0 75 05 83 cb ff eb 15 31 f6 <41> 80 7d 00 03 49 8b 7c 24 68 40 0f 94 c6 e8 e1 f9 ff ff 89 d8
[  261.564109] RIP  [<ffffffff812af272>] ima_inode_setxattr+0x3e/0x5a
[  261.564109]  RSP <ffff880042be3d50>
[  261.564109] CR2: 0000000000000000
[  261.599998] ---[ end trace 39a89a3fc267e652 ]---

Reported-by: Jan Kara <jack@suse.cz>
Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 security/integrity/ima/ima_appraise.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index 5b845af..f07aacd 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -378,6 +378,8 @@ int ima_inode_setxattr(struct dentry *dentry, const char *xattr_name,
 	result = ima_protect_xattr(dentry, xattr_name, xattr_value,
 				   xattr_value_len);
 	if (result == 1) {
+		if (!xattr_value_len)
+			return -EINVAL;
 		ima_reset_appraise_flags(dentry->d_inode,
 			 (xvalue->type == EVM_IMA_XATTR_DIGSIG) ? 1 : 0);
 		result = 0;
-- 
1.9.1


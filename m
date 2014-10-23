Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944AbaJWNtW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 09:49:22 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:56311 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbaJWNtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 09:49:14 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-7a-5449075818b6
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, linux-security-module@vger.kernel.org,
        linux-ima-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, dmitry.kasatkin@gmail.com,
        Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH 2/2] evm: check xattr value length in evm_inode_setxattr()
Date: Thu, 23 Oct 2014 16:47:18 +0300
Message-id: <c0b90b414d97903e73760a1d5085569ac3c8e2fc.1414071910.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <cover.1414071910.git.d.kasatkin@samsung.com>
References: <cover.1414071910.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1414071910.git.d.kasatkin@samsung.com>
References: <cover.1414071910.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnluLIzCtJLcpLzFFi42I5/e/4Nd0Ids8Qg65XEha3/u5ltviytM5i
	9vRmJouXM+axW1zeNYfN4kPPIzaLTysmMTuwe+ycdZfd48GhzSweuxd8ZvLo27KK0ePMgiPs
	Hp83yQWwRXHZpKTmZJalFunbJXBlTPkmUfBbtmLV50ssDYxnJbsYOTkkBEwktp/5xgphi0lc
	uLeerYuRi0NIYCmjxMUlB1ghnE4miQ8/ZzGDVLEJ6ElsaP7BDmKLCORIPPrzGsxmFiiV+PD9
	IliNsICXxM2zM8DiLAKqEi9vtLGB2LwCcRLXnv1khtgmJ3Hy2GSgBRwcnAJWEqu3F4OEhQQs
	JR6d7GPBITyBkX8BI8MqRtHU0uSC4qT0XCO94sTc4tK8dL3k/NxNjJBA/LqDcekxq0OMAhyM
	Sjy8FckeIUKsiWXFlbmHGCU4mJVEeONZPUOEeFMSK6tSi/Lji0pzUosPMTJxcEo1MG4LvfDv
	jdi0/huzo0ObzqhPvZQ5z1rvX0m9dKNOh+Sh/Wc3T+RvDXX5pWYe52xVXbxb/57YurDWkh1P
	74v++X3m9o4/x45NaV0bOCltbmPuP1W+tmaxp8+ueT610pwc3lar8+3/g/RNu08lsPcarfGI
	Dz2yrC/W87Xi60/HTf7u2/f5B7/XzDlKLMUZiYZazEXFiQBqD5y1IgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

evm_inode_setxattr() can be called with no value. Function does not
check the length so that following command can be used to produce
kernel oops: setfattr -n security.evm FOO. This patch fixes it.

[ 1106.396921] BUG: unable to handle kernel NULL pointer dereference at           (null)
[ 1106.398192] IP: [<ffffffff812af7b8>] evm_inode_setxattr+0x2a/0x48
[ 1106.399244] PGD 29048067 PUD 290d7067 PMD 0
[ 1106.399953] Oops: 0000 [#1] SMP
[ 1106.400020] Modules linked in: bridge stp llc evdev serio_raw i2c_piix4 button fuse
[ 1106.400020] CPU: 0 PID: 3635 Comm: setxattr Not tainted 3.16.0-kds+ #2936
[ 1106.400020] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[ 1106.400020] task: ffff8800291a0000 ti: ffff88002917c000 task.ti: ffff88002917c000
[ 1106.400020] RIP: 0010:[<ffffffff812af7b8>]  [<ffffffff812af7b8>] evm_inode_setxattr+0x2a/0x48
[ 1106.400020] RSP: 0018:ffff88002917fd50  EFLAGS: 00010246
[ 1106.400020] RAX: 0000000000000000 RBX: ffff88002917fdf8 RCX: 0000000000000000
[ 1106.400020] RDX: 0000000000000000 RSI: ffffffff818136d3 RDI: ffff88002917fdf8
[ 1106.400020] RBP: ffff88002917fd68 R08: 0000000000000000 R09: 00000000003ec1df
[ 1106.400020] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8800438a0a00
[ 1106.400020] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[ 1106.400020] FS:  00007f7dfa7d7740(0000) GS:ffff88005da00000(0000) knlGS:0000000000000000
[ 1106.400020] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1106.400020] CR2: 0000000000000000 CR3: 000000003763e000 CR4: 00000000000006f0
[ 1106.400020] Stack:
[ 1106.400020]  ffff8800438a0a00 ffff88002917fdf8 0000000000000000 ffff88002917fd98
[ 1106.400020]  ffffffff812a1030 ffff8800438a0a00 ffff88002917fdf8 0000000000000000
[ 1106.400020]  0000000000000000 ffff88002917fde0 ffffffff8116d08a ffff88002917fdc8
[ 1106.400020] Call Trace:
[ 1106.400020]  [<ffffffff812a1030>] security_inode_setxattr+0x5d/0x6a
[ 1106.400020]  [<ffffffff8116d08a>] vfs_setxattr+0x6b/0x9f
[ 1106.400020]  [<ffffffff8116d1e0>] setxattr+0x122/0x16c
[ 1106.400020]  [<ffffffff811687e8>] ? mnt_want_write+0x21/0x45
[ 1106.400020]  [<ffffffff8114d011>] ? __sb_start_write+0x10f/0x143
[ 1106.400020]  [<ffffffff811687e8>] ? mnt_want_write+0x21/0x45
[ 1106.400020]  [<ffffffff811687c0>] ? __mnt_want_write+0x48/0x4f
[ 1106.400020]  [<ffffffff8116d3e6>] SyS_setxattr+0x6e/0xb0
[ 1106.400020]  [<ffffffff81529da9>] system_call_fastpath+0x16/0x1b
[ 1106.400020] Code: c3 0f 1f 44 00 00 55 48 89 e5 41 55 49 89 d5 41 54 49 89 fc 53 48 89 f3 48 c7 c6 d3 36 81 81 48 89 df e8 18 22 04 00 85 c0 75 07 <41> 80 7d 00 02 74 0d 48 89 de 4c 89 e7 e8 5a fe ff ff eb 03 83
[ 1106.400020] RIP  [<ffffffff812af7b8>] evm_inode_setxattr+0x2a/0x48
[ 1106.400020]  RSP <ffff88002917fd50>
[ 1106.400020] CR2: 0000000000000000
[ 1106.428061] ---[ end trace ae08331628ba3050 ]---

Reported-by: Jan Kara <jack@suse.cz>
Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 security/integrity/evm/evm_main.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
index b392fe6..5ca72a4 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -324,9 +324,12 @@ int evm_inode_setxattr(struct dentry *dentry, const char *xattr_name,
 {
 	const struct evm_ima_xattr_data *xattr_data = xattr_value;
 
-	if ((strcmp(xattr_name, XATTR_NAME_EVM) == 0)
-	    && (xattr_data->type == EVM_XATTR_HMAC))
-		return -EPERM;
+	if (strcmp(xattr_name, XATTR_NAME_EVM) == 0) {
+		if (!xattr_value_len)
+			return -EINVAL;
+		if (xattr_data->type == EVM_XATTR_HMAC)
+			return -EPERM;
+	}
 	return evm_protect_xattr(dentry, xattr_name, xattr_value,
 				 xattr_value_len);
 }
-- 
1.9.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757AbaJXHIT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 03:08:19 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:57509 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbaJXHHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 03:07:46 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-82-5449fabf1362
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, linux-security-module@vger.kernel.org,
        linux-ima-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, jmorris@namei.org,
        dmitry.kasatkin@gmail.com, Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH v2 2/2] evm: check xattr value length in evm_inode_setxattr()
Date: Fri, 24 Oct 2014 10:07:06 +0300
Message-id: <90e21d2f988495cd9f122906482cb96b154ff792.1414134113.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <cover.1414134113.git.d.kasatkin@samsung.com>
References: <cover.1414134113.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1414134113.git.d.kasatkin@samsung.com>
References: <cover.1414134113.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFLMWRmVeSWpSXmKPExsVy+t/xa7r7f3mGGLw9xGZx6+9eZosvS+ss
	Zk9vZrJYt34xk8XLGfPYLS7vmsNm8aHnEZvFpxWTmB04PHbOusvu8eDQZhaP3Qs+M3n0fE/2
	6NuyitHjzIIj7B6fN8kFsEdx2aSk5mSWpRbp2yVwZdxdMI+94K9cxatfzxkbGLdIdTFycEgI
	mEhM+h/RxcgJZIpJXLi3nq2LkYtDSGApo8SuY0+YIZxOJokfS66xgFSxCehJbGj+wQ5iiwjk
	SDz685odpIhZoINRYuOP60wgU4UFfCUauzhAalgEVCW2tT8H6+UViJPY8HAhO8Q2OYmTxyaz
	gticAlYSz74cA7OFBCwl5vd9YsclPoGRfwEjwypG0dTS5ILipPRcQ73ixNzi0rx0veT83E2M
	kPD8soNx8TGrQ4wCHIxKPLwVyR4hQqyJZcWVuYcYJTiYlUR4Ez96hgjxpiRWVqUW5ccXleak
	Fh9iZOLglGpgXDTb6FDJahO1I6ujNu1sSeBtf6766bLmSQdZg50OrSdCmiawVCYXfp6f7fhp
	90SWn91LJloo60U1JWa7Cy4IO6Uq/iustzNia8BVEb4IDsaapZ3GW49vbzu44UnNR89F8zNa
	DBf2Hrob0fMprPXQtYzjyy9MsWGrlSpTYBf+7cvi3sEQeVhHiaU4I9FQi7moOBEAm5M5ty0C	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

evm_inode_setxattr() can be called with no value. Function does not
check the length so that following command can be used to produce
kernel oops: setfattr -n security.evm FOO. This patch fixes it.

Changes in v2:
* testing for validity of xattr type

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
 security/integrity/evm/evm_main.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
index b392fe6..1384e4b 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -324,9 +324,14 @@ int evm_inode_setxattr(struct dentry *dentry, const char *xattr_name,
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
+		if (xattr_data->type != EVM_IMA_XATTR_DIGSIG)
+			return -EINVAL;
+	}
 	return evm_protect_xattr(dentry, xattr_name, xattr_value,
 				 xattr_value_len);
 }
-- 
1.9.1


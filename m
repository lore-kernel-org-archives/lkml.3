Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752237AbaEGTxV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 15:53:21 -0400
Received: from mout.gmx.net ([212.227.17.20]:65438 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062AbaEGTxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 15:53:18 -0400
Date: Wed, 7 May 2014 21:44:53 +0200
From: Christian Engelmayer <cengelma@gmx.at>
To: devel@driverdev.osuosl.org
Cc: john.stultz@linaro.org, serban.constantinescu@arm.com, arve@android.com,
        ccross@android.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] staging: binder: fix usage of uninit scalar in
 binder_transaction()
Message-ID: <20140507214453.25f4bef6@spike>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:yUsoZ3k3ODgLah2RF1vMNFY6aKNU/Kduwj3C+0GcUux70EhKM3Z
 UwO+22fTWuqQEnOlhdDgJ8K/3DTru9jnEoT1XK4vPqUx/DE20sf6c+P7iB7jWAz73Qce23O
 zqlm7oCnrW7Tgymnggo7fH874MpbRr8sP+SkEwXPfcuLT9Lzqa7IpRK2TfjNA0jIxLNpCKv
 9utS6sfeMdJcjzBYJ5ogQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the error path when a cookie mismatch is detected. In that case the
function jumps to the exit label without setting the uninitialized, local
variable 'return_error'. Detected by Coverity - CID 201453.

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
---
v2: Resend after v1 failed to apply

   * rebased against staging-next - commit 09c3fbba (staging: rtl8188eu:
     Remove 'u8 *pbuf' from struct recv_buf)
   * fixed mua: no multipart, 7bit text/plain us-ascii

Compile tested and applies against branch staging-next of tree
git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
---
 drivers/staging/android/binder.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index 35c00ab..de8e2a3 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -1546,6 +1546,7 @@ static void binder_transaction(struct binder_proc *proc,
 					proc->pid, thread->pid,
 					(u64)fp->binder, node->debug_id,
 					(u64)fp->cookie, (u64)node->cookie);
+				return_error = BR_FAILED_REPLY;
 				goto err_binder_get_ref_for_node_failed;
 			}
 			ref = binder_get_ref_for_node(target_proc, node);
-- 
1.9.1


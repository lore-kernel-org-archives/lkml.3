Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456AbaLZAGU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 19:06:20 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:57284 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360AbaLZAGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 19:06:15 -0500
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Oleg Drokin <oleg.drokin@intel.com>
Cc: Andreas Dilger <andreas.dilger@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peng Tao <bergwolf@gmail.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Kirill Tkhai <ktkhai@parallels.com>, Joe Perches <joe@perches.com>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Dmitry Eremin <dmitry.eremin@intel.com>,
        Masaru Nomura <massa.nomura@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        James A Shackleford <shack@linux.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Jeremiah Mahler <jmmahler@gmail.com>
Subject: [PATCH 4/6] staging: lustre: replace MIN with min, cast (__kernel_size_t)
Date: Thu, 25 Dec 2014 16:04:44 -0800
Message-Id: <1419552286-8492-5-git-send-email-jmmahler@gmail.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1419552286-8492-1-git-send-email-jmmahler@gmail.com>
References: <1419552286-8492-1-git-send-email-jmmahler@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch from MIN to min and fix the new type warning.  The
warning is produced because a comparison between iov_len,
which is a __kernel_size_t, is made to kiov_len, which is an
unsigned int (include/linux/lnet/types.h).  Fix the warning
by casting kiov_len to __kernel_size_t.

Signed-off-by: Jeremiah Mahler <jmmahler@gmail.com>
---
 drivers/staging/lustre/lnet/lnet/lib-move.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/lustre/lnet/lnet/lib-move.c b/drivers/staging/lustre/lnet/lnet/lib-move.c
index 706c5ee..76eb238 100644
--- a/drivers/staging/lustre/lnet/lnet/lib-move.c
+++ b/drivers/staging/lustre/lnet/lnet/lib-move.c
@@ -403,8 +403,8 @@ lnet_copy_kiov2iov(unsigned int niov, struct iovec *iov, unsigned int iovoffset,
 	do {
 		LASSERT(niov > 0);
 		LASSERT(nkiov > 0);
-		this_nob = MIN(iov->iov_len - iovoffset,
-			       kiov->kiov_len - kiovoffset);
+		this_nob = min(iov->iov_len - iovoffset,
+			       (__kernel_size_t) kiov->kiov_len - kiovoffset);
 		this_nob = min(this_nob, nob);
 
 		if (addr == NULL)
@@ -474,7 +474,7 @@ lnet_copy_iov2kiov(unsigned int nkiov, lnet_kiov_t *kiov,
 	do {
 		LASSERT(nkiov > 0);
 		LASSERT(niov > 0);
-		this_nob = MIN(kiov->kiov_len - kiovoffset,
+		this_nob = min((__kernel_size_t) kiov->kiov_len - kiovoffset,
 			       iov->iov_len - iovoffset);
 		this_nob = min(this_nob, nob);
 
-- 
2.1.4


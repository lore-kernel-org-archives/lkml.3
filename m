Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562AbaLZAGr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 19:06:47 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:35634 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397AbaLZAGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 19:06:19 -0500
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
Subject: [PATCH 5/6] staging: lustre: replace MIN with min_t, remove cast
Date: Thu, 25 Dec 2014 16:04:45 -0800
Message-Id: <1419552286-8492-6-git-send-email-jmmahler@gmail.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1419552286-8492-1-git-send-email-jmmahler@gmail.com>
References: <1419552286-8492-1-git-send-email-jmmahler@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch from MIN to min_t and remove the previous cast of the second
argument to int.

Signed-off-by: Jeremiah Mahler <jmmahler@gmail.com>
---
 drivers/staging/lustre/lnet/lnet/lib-move.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lnet/lnet/lib-move.c b/drivers/staging/lustre/lnet/lnet/lib-move.c
index 76eb238..d11686f 100644
--- a/drivers/staging/lustre/lnet/lnet/lib-move.c
+++ b/drivers/staging/lustre/lnet/lnet/lib-move.c
@@ -1530,7 +1530,7 @@ lnet_parse_reply(lnet_ni_t *ni, lnet_msg_t *msg)
 	LASSERT(md->md_offset == 0);
 
 	rlength = hdr->payload_length;
-	mlength = MIN(rlength, (int)md->md_length);
+	mlength = min_t(int, rlength, md->md_length);
 
 	if (mlength < rlength &&
 	    (md->md_options & LNET_MD_TRUNCATE) == 0) {
-- 
2.1.4


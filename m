Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385AbaLZAGP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 19:06:15 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:48536 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbaLZAGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 19:06:10 -0500
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
Subject: [PATCH 3/6] staging: lustre: replace MIN/MAX with min_t/max_t
Date: Thu, 25 Dec 2014 16:04:43 -0800
Message-Id: <1419552286-8492-4-git-send-email-jmmahler@gmail.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1419552286-8492-1-git-send-email-jmmahler@gmail.com>
References: <1419552286-8492-1-git-send-email-jmmahler@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch from MIN/MAX to min_t/max_t with a size_t type.  The size_t type
was chosen because one operand is a size_t and all the others are
immediate integer values.

Signed-off-by: Jeremiah Mahler <jmmahler@gmail.com>
---
 drivers/staging/lustre/lnet/lnet/router_proc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lnet/lnet/router_proc.c b/drivers/staging/lustre/lnet/lnet/router_proc.c
index 46cde70..c055afc 100644
--- a/drivers/staging/lustre/lnet/lnet/router_proc.c
+++ b/drivers/staging/lustre/lnet/lnet/router_proc.c
@@ -49,7 +49,7 @@ enum {
  */
 #define LNET_PROC_CPT_BITS	(LNET_CPT_BITS + 1)
 /* change version, 16 bits or 8 bits */
-#define LNET_PROC_VER_BITS	MAX(((MIN(LNET_LOFFT_BITS, 64)) / 4), 8)
+#define LNET_PROC_VER_BITS	max_t(size_t, min_t(size_t, LNET_LOFFT_BITS, 64) / 4, 8)
 
 #define LNET_PROC_HASH_BITS	LNET_PEER_HASH_BITS
 /*
-- 
2.1.4


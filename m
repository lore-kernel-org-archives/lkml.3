Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751607AbaHVUI1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 16:08:27 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:56698 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbaHVUI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 16:08:26 -0400
From: Marco Cyriacks <marco@cyriacks.net>
To: gregkh@linuxfoundation.org
Cc: bergwolf@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Marco Cyriacks <marco@cyriacks.net>
Subject: [PATCH] socklnd: Remove static initialization to NULL or 0
Date: Fri, 22 Aug 2014 22:08:06 +0200
Message-Id: <1408738086-19854-2-git-send-email-marco@cyriacks.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408738086-19854-1-git-send-email-marco@cyriacks.net>
References: <1408738086-19854-1-git-send-email-marco@cyriacks.net>
X-Provags-ID: V02:K0:kh3J2hSDg/CdfdfYUhu91oIAlEx8cT6Tw1G+tQwSV4h
 4pTYiZx1GLMfXqAINcQFBfgje/Ec2ERvB7c+BEqLd85l6L+z5S
 VxmWRh/5Zs7FYJlCppIvjOWJYGPdBvZE6mu6GKlxlie++6/UuQ
 2KYBjk+5lklD0TJ5PtezCaeB7h+5NYrxp02QOd39RXVlaINw0X
 nPBmbJDfsZdlKie1dlUR2Eeo0jYy8xoPOBTaFSaqvdtT3Md6Ej
 C7udO1efjjG7b08yayXwFjhFevsD7r4+ldf6fY0V91+xo0kRv0
 wmpACHubZCZAhprbxX1zJ+b5+xfF4FSeYy4TZeo9Ebdq3K3BDy
 bCHRdIQ8CSLn6Szf2EavAK5KynOenYPfgpMDlI/MjAUbl/HqoV
 JmVymnyTc7wZQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following coding style issue:
ERROR: do not initialise statics to 0 or NULL

Signed-off-by: Marco Cyriacks <marco@cyriacks.net>
---
 drivers/staging/lustre/lnet/klnds/socklnd/socklnd_modparams.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_modparams.c b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_modparams.c
index 54c0019..66d78c9 100644
--- a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_modparams.c
+++ b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_modparams.c
@@ -33,7 +33,7 @@ static int peer_credits = 8;
 module_param(peer_credits, int, 0444);
 MODULE_PARM_DESC(peer_credits, "# concurrent sends to 1 peer");
 
-static int peer_buffer_credits = 0;
+static int peer_buffer_credits;
 module_param(peer_buffer_credits, int, 0444);
 MODULE_PARM_DESC(peer_buffer_credits, "# per-peer router buffer credits");
 
@@ -85,7 +85,7 @@ static int rx_buffer_size = DEFAULT_BUFFER_SIZE;
 module_param(rx_buffer_size, int, 0644);
 MODULE_PARM_DESC(rx_buffer_size, "socket rx buffer size (0 for system default)");
 
-static int nagle = 0;
+static int nagle;
 module_param(nagle, int, 0644);
 MODULE_PARM_DESC(nagle, "enable NAGLE?");
 
@@ -110,11 +110,11 @@ static int keepalive_intvl = 5;
 module_param(keepalive_intvl, int, 0644);
 MODULE_PARM_DESC(keepalive_intvl, "seconds between probes");
 
-static int enable_csum = 0;
+static int enable_csum;
 module_param(enable_csum, int, 0644);
 MODULE_PARM_DESC(enable_csum, "enable check sum");
 
-static int inject_csum_error = 0;
+static int inject_csum_error;
 module_param(inject_csum_error, int, 0644);
 MODULE_PARM_DESC(inject_csum_error, "set non-zero to inject a checksum error");
 
@@ -126,7 +126,7 @@ static unsigned int zc_min_payload = (16 << 10);
 module_param(zc_min_payload, int, 0644);
 MODULE_PARM_DESC(zc_min_payload, "minimum payload size to zero copy");
 
-static unsigned int zc_recv = 0;
+static unsigned int zc_recv;
 module_param(zc_recv, int, 0644);
 MODULE_PARM_DESC(zc_recv, "enable ZC recv for Chelsio driver");
 
-- 
1.9.3


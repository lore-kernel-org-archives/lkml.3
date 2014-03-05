Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839AbaCEBY3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 20:24:29 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:44244 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755033AbaCEBY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 20:24:27 -0500
From: Daeseok Youn <daeseok.youn@gmail.com>
To: gregkh@linuxfoundation.org
Cc: davem@davemloft.net, sachin.kamat@linaro.org, shaun@xresource.ca,
        dulshani.gunawardhana89@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, ying.xue@windriver.com
Subject: [PATCH 7/7] staging: cxt1e1: remove unneeded a value
Date: Wed, 05 Mar 2014 10:24:22 +0900
Message-ID: <4401309.KAOCJ1Tfb2@daeseok-laptop.cloud.net>
User-Agent: KMail/4.8.5 (Linux/3.2.0-58-generic; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It doesn't need to assign name array address to np pointer.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/cxt1e1/linux.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/cxt1e1/linux.c b/drivers/staging/cxt1e1/linux.c
index 5bb42ae..cae8c66 100644
--- a/drivers/staging/cxt1e1/linux.c
+++ b/drivers/staging/cxt1e1/linux.c
@@ -205,15 +205,14 @@ status_t
 c4_wq_port_init(mpi_t *pi)
 {
 
-	char        name[16], *np;  /* NOTE: name of the queue limited by system
+	char        name[16];  /* NOTE: name of the queue limited by system
 				     * to 10 characters */
 
 	if (pi->wq_port)
 		return 0;                   /* already initialized */
 
-	np = name;
 	memset(name, 0, 16);
-	sprintf(np, "%s%d", pi->up->devname, pi->portnum); /* IE pmcc4-01) */
+	sprintf(name, "%s%d", pi->up->devname, pi->portnum); /* IE pmcc4-01) */
 
 #ifdef RLD_RESTART_DEBUG
 	pr_info(">> %s: creating workqueue <%s> for Port %d.\n",
-- 
1.7.4.4



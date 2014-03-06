Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352AbaCFIMy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 03:12:54 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:44350 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbaCFIMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 03:12:52 -0500
From: Daeseok Youn <daeseok.youn@gmail.com>
To: gregkh@linuxfoundation.org
Cc: sachin.kamat@linaro.org, shaun@xresource.ca,
        dulshani.gunawardhana89@gmail.com, davem@davemloft.net,
        ying.xue@windriver.com, dan.carpenter@oracle.com, tklauser@distanz.ch,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 7/7] staging: cxt1e1: remove unneeded a value
Date: Thu, 06 Mar 2014 17:12:48 +0900
Message-ID: <6282871.ckfvQvsDb4@daeseok-laptop.cloud.net>
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
v2: replace sprintf() with snprintf() and remove memset() call
because snprintf() adds a terminating '\0'

 drivers/staging/cxt1e1/linux.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/cxt1e1/linux.c b/drivers/staging/cxt1e1/linux.c
index 5bb42ae..9ac48ee 100644
--- a/drivers/staging/cxt1e1/linux.c
+++ b/drivers/staging/cxt1e1/linux.c
@@ -205,15 +205,13 @@ status_t
 c4_wq_port_init(mpi_t *pi)
 {
 
-	char        name[16], *np;  /* NOTE: name of the queue limited by system
+	char        name[16];  /* NOTE: name of the queue limited by system
 				     * to 10 characters */
-
 	if (pi->wq_port)
 		return 0;                   /* already initialized */
 
-	np = name;
-	memset(name, 0, 16);
-	sprintf(np, "%s%d", pi->up->devname, pi->portnum); /* IE pmcc4-01) */
+	/* IE pmcc4-01 */
+	snprintf(name, sizeof(name), "%s%d", pi->up->devname, pi->portnum);
 
 #ifdef RLD_RESTART_DEBUG
 	pr_info(">> %s: creating workqueue <%s> for Port %d.\n",
-- 
1.7.4.4



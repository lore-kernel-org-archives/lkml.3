Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494AbaCIX5A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 19:57:00 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:36816 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbaCIX47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 19:56:59 -0400
From: Daeseok Youn <daeseok.youn@gmail.com>
To: gregkh@linuxfoundation.org
Cc: shaun@xresource.ca, sachin.kamat@linaro.org, davem@davemloft.net,
        ying.xue@windriver.com, dulshani.gunawardhana89@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        tklauser@distanz.ch
Subject: [PATCH 2/2] staging: cxt1e1: remove redundant memset() call
Date: Mon, 10 Mar 2014 08:56:55 +0900
Message-ID: <6581653.mbbbbAh2at@daeseok-laptop.cloud.net>
User-Agent: KMail/4.8.5 (Linux/3.2.0-58-generic; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The name array doens't need to set to 0. Because
sprintf/snprintf adds a terminating '\0'.

And also it doesn't need to assign name array
address to np pointer.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/cxt1e1/linux.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/cxt1e1/linux.c b/drivers/staging/cxt1e1/linux.c
index 5d7ddd4..efd3eb8 100644
--- a/drivers/staging/cxt1e1/linux.c
+++ b/drivers/staging/cxt1e1/linux.c
@@ -204,15 +204,13 @@ status_t
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



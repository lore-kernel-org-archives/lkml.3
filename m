Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051AbaFBA1J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 20:27:09 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:40659 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbaFBA1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 20:27:07 -0400
From: James A Shackleford <shack@linux.com>
To: forest@alittletooquiet.net, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: James A Shackleford <shack@linux.com>
Subject: [PATCH] staging: vt6655: fix sparse warning for static declarations
Date: Sun,  1 Jun 2014 20:26:55 -0400
Message-Id: <1401668815-18807-1-git-send-email-shack@linux.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following sparse warnings:

dpc.c:65:21: warning: symbol 'acbyRxRate' was not declared. Should it be static?
dpc.c:272:9: warning: symbol 'MngWorkItem' was not declared. Should it be static?
dpc.c:288:1: warning: symbol 'device_receive_frame' was not declared. Should it be static?

Signed-off-by: James A Shackleford <shack@linux.com>
---
 drivers/staging/vt6655/dpc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/vt6655/dpc.c b/drivers/staging/vt6655/dpc.c
index 7ddaf26..696564b 100644
--- a/drivers/staging/vt6655/dpc.c
+++ b/drivers/staging/vt6655/dpc.c
@@ -54,6 +54,7 @@
 #include "rf.h"
 #include "iowpa.h"
 #include "aes_ccmp.h"
+#include "dpc.h"
 
 /*---------------------  Static Definitions -------------------------*/
 
@@ -62,7 +63,7 @@
 /*---------------------  Static Variables  --------------------------*/
 static int msglevel = MSG_LEVEL_INFO;
 
-const unsigned char acbyRxRate[MAX_RATE] =
+static const unsigned char acbyRxRate[MAX_RATE] =
 {2, 4, 11, 22, 12, 18, 24, 36, 48, 72, 96, 108};
 
 /*---------------------  Static Functions  --------------------------*/
-- 
1.7.9.5


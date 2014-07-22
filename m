Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837AbaGVUJE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 16:09:04 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:52115 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756777AbaGVUJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 16:09:00 -0400
X-Originating-IP: 78.210.48.61
From: Guillaume Clement <gclement@baobob.org>
To: Forest Bond <forest@alittletooquiet.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Guillaume Clement <gclement@baobob.org>
Subject: [PATCH 2/5] staging: vt6655:fix warning for unexported non-static functions
Date: Tue, 22 Jul 2014 22:08:27 +0200
Message-Id: <1406059710-30903-3-git-send-email-gclement@baobob.org>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1406059710-30903-1-git-send-email-gclement@baobob.org>
References: <1406059710-30903-1-git-send-email-gclement@baobob.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is one function in aes_ccmp.c which is exported, but sparse sees
it unexported because it doesn't include the header that exports it.

Signed-off-by: Guillaume Clement <gclement@baobob.org>
---
 drivers/staging/vt6655/aes_ccmp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/vt6655/aes_ccmp.c b/drivers/staging/vt6655/aes_ccmp.c
index 4ccfe06..a25e6cf 100644
--- a/drivers/staging/vt6655/aes_ccmp.c
+++ b/drivers/staging/vt6655/aes_ccmp.c
@@ -35,6 +35,7 @@
 
 #include "device.h"
 #include "80211hdr.h"
+#include "aes_ccmp.h"
 
 /*---------------------  Static Definitions -------------------------*/
 
-- 
1.8.5.5


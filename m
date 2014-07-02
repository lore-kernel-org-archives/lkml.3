Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953AbaGBNuG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 09:50:06 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:44262 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324AbaGBNuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 09:50:05 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH] staging: omap4iss: Fix type of struct iss_device::crashed
Date: Wed,  2 Jul 2014 15:49:46 +0200
Message-Id: <1404308986-21761-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The crashed member of struct iss_device is documented to be a bitmask,
but a bool doesn't hold that many (usable) bits. Lines 589 and 659 of
iss.c strongly suggest that "unsigned int" was meant (the same type as
struct iss_pipeline::entities). Currently, any crashed entity will be
blamed on index 0, which is unlikely to be what was intended.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/staging/media/omap4iss/iss.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/omap4iss/iss.h b/drivers/staging/media/omap4iss/iss.h
index 05cd9bf..734cfee 100644
--- a/drivers/staging/media/omap4iss/iss.h
+++ b/drivers/staging/media/omap4iss/iss.h
@@ -97,7 +97,7 @@ struct iss_device {
 	u64 raw_dmamask;
 
 	struct mutex iss_mutex;	/* For handling ref_count field */
-	bool crashed;
+	unsigned int crashed;
 	int has_context;
 	int ref_count;
 
-- 
1.9.2


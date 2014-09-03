Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932975AbaICMvi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 08:51:38 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:44730 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932710AbaICMqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 08:46:23 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 23/37] staging: comedi: 8253.h: use CMDF_ROUND_...
Date: Wed,  3 Sep 2014 13:45:46 +0100
Message-Id: <1409748360-17063-24-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1409748360-17063-1-git-send-email-abbotti@mev.co.uk>
References: <1409748360-17063-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace use of the `TRIG_ROUND_...` macros with the new names
`CMDF_ROUND_...`.  The numeric values are unchanged.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/8253.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/8253.h b/drivers/staging/comedi/drivers/8253.h
index f8e1eba..9f4c141 100644
--- a/drivers/staging/comedi/drivers/8253.h
+++ b/drivers/staging/comedi/drivers/8253.h
@@ -90,8 +90,8 @@ static inline void i8253_cascade_ns_to_timer(int i8253_osc_base,
 		}
 	}
 
-	switch (flags & TRIG_ROUND_MASK) {
-	case TRIG_ROUND_NEAREST:
+	switch (flags & CMDF_ROUND_MASK) {
+	case CMDF_ROUND_NEAREST:
 	default:
 		ns_high = div1_lub * div2_lub * i8253_osc_base;
 		ns_low = div1_glb * div2_glb * i8253_osc_base;
@@ -103,11 +103,11 @@ static inline void i8253_cascade_ns_to_timer(int i8253_osc_base,
 			div2 = div2_glb;
 		}
 		break;
-	case TRIG_ROUND_UP:
+	case CMDF_ROUND_UP:
 		div1 = div1_lub;
 		div2 = div2_lub;
 		break;
-	case TRIG_ROUND_DOWN:
+	case CMDF_ROUND_DOWN:
 		div1 = div1_glb;
 		div2 = div2_glb;
 		break;
-- 
2.1.0


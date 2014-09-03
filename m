Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932961AbaICMup (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 08:50:45 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:44685 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932711AbaICMqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 08:46:23 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 24/37] staging: comedi: addi_apci_3xxx: use CMDF_ROUND_...
Date: Wed,  3 Sep 2014 13:45:47 +0100
Message-Id: <1409748360-17063-25-git-send-email-abbotti@mev.co.uk>
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
 drivers/staging/comedi/drivers/addi_apci_3xxx.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi_apci_3xxx.c b/drivers/staging/comedi/drivers/addi_apci_3xxx.c
index 57e6f88..f26e4ec 100644
--- a/drivers/staging/comedi/drivers/addi_apci_3xxx.c
+++ b/drivers/staging/comedi/drivers/addi_apci_3xxx.c
@@ -496,15 +496,15 @@ static int apci3xxx_ai_ns_to_timer(struct comedi_device *dev,
 			break;
 		}
 
-		switch (flags & TRIG_ROUND_MASK) {
-		case TRIG_ROUND_NEAREST:
+		switch (flags & CMDF_ROUND_MASK) {
+		case CMDF_ROUND_NEAREST:
 		default:
 			timer = (*ns + base / 2) / base;
 			break;
-		case TRIG_ROUND_DOWN:
+		case CMDF_ROUND_DOWN:
 			timer = *ns / base;
 			break;
-		case TRIG_ROUND_UP:
+		case CMDF_ROUND_UP:
 			timer = (*ns + base - 1) / base;
 			break;
 		}
-- 
2.1.0


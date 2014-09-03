Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932530AbaICMtc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 08:49:32 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:44730 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932743AbaICMqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 08:46:24 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 27/37] staging: comedi: cb_pcidas64: use CMDF_ROUND_...
Date: Wed,  3 Sep 2014 13:45:50 +0100
Message-Id: <1409748360-17063-28-git-send-email-abbotti@mev.co.uk>
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
 drivers/staging/comedi/drivers/cb_pcidas64.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas64.c b/drivers/staging/comedi/drivers/cb_pcidas64.c
index f1b2744..56069d6 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas64.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas64.c
@@ -1958,14 +1958,14 @@ static unsigned int get_divisor(unsigned int ns, unsigned int flags)
 {
 	unsigned int divisor;
 
-	switch (flags & TRIG_ROUND_MASK) {
-	case TRIG_ROUND_UP:
+	switch (flags & CMDF_ROUND_MASK) {
+	case CMDF_ROUND_UP:
 		divisor = (ns + TIMER_BASE - 1) / TIMER_BASE;
 		break;
-	case TRIG_ROUND_DOWN:
+	case CMDF_ROUND_DOWN:
 		divisor = ns / TIMER_BASE;
 		break;
-	case TRIG_ROUND_NEAREST:
+	case CMDF_ROUND_NEAREST:
 	default:
 		divisor = (ns + TIMER_BASE / 2) / TIMER_BASE;
 		break;
-- 
2.1.0


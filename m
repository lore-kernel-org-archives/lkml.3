Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932897AbaICMsW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 08:48:22 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:44690 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932749AbaICMqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 08:46:25 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 29/37] staging: comedi: dt282x: use CMDF_ROUND_...
Date: Wed,  3 Sep 2014 13:45:52 +0100
Message-Id: <1409748360-17063-30-git-send-email-abbotti@mev.co.uk>
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
 drivers/staging/comedi/drivers/dt282x.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dt282x.c b/drivers/staging/comedi/drivers/dt282x.c
index b989691..4017fcb 100644
--- a/drivers/staging/comedi/drivers/dt282x.c
+++ b/drivers/staging/comedi/drivers/dt282x.c
@@ -403,15 +403,15 @@ static unsigned int dt282x_ns_to_timer(unsigned int *ns, unsigned int flags)
 		if (prescale == 1)
 			continue;
 		base = 250 * (1 << prescale);
-		switch (flags & TRIG_ROUND_MASK) {
-		case TRIG_ROUND_NEAREST:
+		switch (flags & CMDF_ROUND_MASK) {
+		case CMDF_ROUND_NEAREST:
 		default:
 			divider = (*ns + base / 2) / base;
 			break;
-		case TRIG_ROUND_DOWN:
+		case CMDF_ROUND_DOWN:
 			divider = (*ns) / base;
 			break;
-		case TRIG_ROUND_UP:
+		case CMDF_ROUND_UP:
 			divider = (*ns + base - 1) / base;
 			break;
 		}
-- 
2.1.0


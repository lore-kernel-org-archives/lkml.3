Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932991AbaICMvj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 08:51:39 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:44698 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932636AbaICMqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 08:46:23 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 22/37] staging: comedi: add CMDF_ROUND_... as synonyms for TRIG_ROUND_...
Date: Wed,  3 Sep 2014 13:45:45 +0100
Message-Id: <1409748360-17063-23-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1409748360-17063-1-git-send-email-abbotti@mev.co.uk>
References: <1409748360-17063-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The `TRIG_ROUND_...` macros are some of the values that can be OR-ed
into the `flags` member of `struct comedi_cmd`.  They may influence the
rounding of sample timings during operation of the asynchronous command.

The names are a bit of a left-over from earlier times.  It would be
better to use the names `CMDF_ROUND_...` to match various other command
flags.

Define `CMDF_ROUND_MASK`, `CMDF_ROUND_NEAREST`, `CMDF_ROUND_DOWN`,
`CMDF_ROUND_UP` and `CMDF_ROUND_UP_NEXT` with the same numeric values as
`TRIG_ROUND_MASK`, `TRIG_ROUND_NEAREST`, `TRIG_ROUND_DOWN`,
`TRIG_ROUND_UP` and `TRIG_ROUND_UP_NEXT`, and redefine the
`TRIG_ROUND_...` macros as synonyms of the `CMDF_ROUND_...` macros.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/comedi.h | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/comedi.h b/drivers/staging/comedi/comedi.h
index 3d2801d..c8c99e6 100644
--- a/drivers/staging/comedi/comedi.h
+++ b/drivers/staging/comedi/comedi.h
@@ -142,23 +142,29 @@
 
 #define CMDF_RAWDATA		0x00000080
 
+/* timer rounding definitions */
+#define CMDF_ROUND_MASK		0x00030000
+#define CMDF_ROUND_NEAREST	0x00000000
+#define CMDF_ROUND_DOWN		0x00010000
+#define CMDF_ROUND_UP		0x00020000
+#define CMDF_ROUND_UP_NEXT	0x00030000
+
 #define COMEDI_EV_START		0x00040000
 #define COMEDI_EV_SCAN_BEGIN	0x00080000
 #define COMEDI_EV_CONVERT	0x00100000
 #define COMEDI_EV_SCAN_END	0x00200000
 #define COMEDI_EV_STOP		0x00400000
 
-#define TRIG_ROUND_MASK		0x00030000
-#define TRIG_ROUND_NEAREST	0x00000000
-#define TRIG_ROUND_DOWN		0x00010000
-#define TRIG_ROUND_UP		0x00020000
-#define TRIG_ROUND_UP_NEXT	0x00030000
-
 /* compatibility definitions */
 #define TRIG_BOGUS		CMDF_BOGUS
 #define TRIG_RT			CMDF_PRIORITY
 #define TRIG_WAKE_EOS		CMDF_WAKE_EOS
 #define TRIG_WRITE		CMDF_WRITE
+#define TRIG_ROUND_MASK		CMDF_ROUND_MASK
+#define TRIG_ROUND_NEAREST	CMDF_ROUND_NEAREST
+#define TRIG_ROUND_DOWN		CMDF_ROUND_DOWN
+#define TRIG_ROUND_UP		CMDF_ROUND_UP
+#define TRIG_ROUND_UP_NEXT	CMDF_ROUND_UP_NEXT
 
 /* trigger sources */
 
-- 
2.1.0


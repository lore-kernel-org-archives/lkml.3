Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932145AbaICM4u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 08:56:50 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:44685 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932502AbaICMqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 08:46:15 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 06/37] staging: comedi: add CMDF_WAKE_EOS as synonym for TRIG_WAKE_EOS
Date: Wed,  3 Sep 2014 13:45:29 +0100
Message-Id: <1409748360-17063-7-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1409748360-17063-1-git-send-email-abbotti@mev.co.uk>
References: <1409748360-17063-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

`TRIG_WAKE_EOS` is one of the values that can be OR-ed into the `flags`
member of `struct comedi_cmd`.  It's intended action is tune the
asynchronous command to interrupt at the end of every "scan".  The name
is a bit of a left-over from earlier times.  A better name would be
`CMDF_WAKE_EOS` to match various other command flags.

Define `CMDF_WAKE_EOS` with the same numeric value as the old
`TRIG_WAKE_EOS` and redefine `TRIG_WAKE_EOS` as a synonym of it.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/comedi.h | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/comedi.h b/drivers/staging/comedi/comedi.h
index 217baf8..dfaa935 100644
--- a/drivers/staging/comedi/comedi.h
+++ b/drivers/staging/comedi/comedi.h
@@ -126,10 +126,7 @@
 #define TRIG_BOGUS	0x0001	/* do the motions */
 #define TRIG_DITHER	0x0002	/* enable dithering */
 #define TRIG_DEGLITCH	0x0004	/* enable deglitching */
-	/*#define TRIG_RT       0x0008 *//* perform op in real time */
 #define TRIG_CONFIG	0x0010	/* perform configuration, not triggering */
-#define TRIG_WAKE_EOS	0x0020	/* wake up on end-of-scan events */
-	/*#define TRIG_WRITE    0x0040*//* write to bidirectional devices */
 
 /* command flags */
 /* These flags are used in comedi_cmd structures */
@@ -137,10 +134,10 @@
 /* try to use a real-time interrupt while performing command */
 #define CMDF_PRIORITY		0x00000008
 
-#define TRIG_RT		CMDF_PRIORITY	/* compatibility definition */
+/* wake up on end-of-scan events */
+#define CMDF_WAKE_EOS		0x00000020
 
 #define CMDF_WRITE		0x00000040
-#define TRIG_WRITE	CMDF_WRITE	/* compatibility definition */
 
 #define CMDF_RAWDATA		0x00000080
 
@@ -156,6 +153,11 @@
 #define TRIG_ROUND_UP		0x00020000
 #define TRIG_ROUND_UP_NEXT	0x00030000
 
+/* compatibility definitions */
+#define TRIG_RT			CMDF_PRIORITY
+#define TRIG_WAKE_EOS		CMDF_WAKE_EOS
+#define TRIG_WRITE		CMDF_WRITE
+
 /* trigger sources */
 
 #define TRIG_ANY	0xffffffff
-- 
2.1.0


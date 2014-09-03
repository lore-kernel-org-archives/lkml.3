Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932766AbaICMq0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 08:46:26 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:44685 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932692AbaICMqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 08:46:22 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 20/37] staging: comedi: add CMDF_BOGUS as synonym for TRIG_BOGUS
Date: Wed,  3 Sep 2014 13:45:43 +0100
Message-Id: <1409748360-17063-21-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1409748360-17063-1-git-send-email-abbotti@mev.co.uk>
References: <1409748360-17063-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

`TRIG_BOGUS` is one of the values that can be OR-ed into the `flags`
member of `struct comedi_cmd`.  It causes the comedi core to go through
some of the motions of setting up an asynchronous command without
actually setting it up.  If all goes well, it causes the command set-up
to fail with an `EAGAIN` error.

The name `TRIG_BOGUS` is a bit of a left-over from earlier times.  A
better name would be `CMDF_BOGUS` to match various other command flags.

Define `CMDF_BOGUS` with the same numeric value as the old `TRIG_BOGUS`
and redefine `TRIG_BOGUS` as a synonym of it.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/comedi.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/comedi.h b/drivers/staging/comedi/comedi.h
index dfaa935..3d2801d 100644
--- a/drivers/staging/comedi/comedi.h
+++ b/drivers/staging/comedi/comedi.h
@@ -123,7 +123,6 @@
 /* trigger flags */
 /* These flags are used in comedi_trig structures */
 
-#define TRIG_BOGUS	0x0001	/* do the motions */
 #define TRIG_DITHER	0x0002	/* enable dithering */
 #define TRIG_DEGLITCH	0x0004	/* enable deglitching */
 #define TRIG_CONFIG	0x0010	/* perform configuration, not triggering */
@@ -131,6 +130,8 @@
 /* command flags */
 /* These flags are used in comedi_cmd structures */
 
+#define CMDF_BOGUS		0x00000001	/* do the motions */
+
 /* try to use a real-time interrupt while performing command */
 #define CMDF_PRIORITY		0x00000008
 
@@ -154,6 +155,7 @@
 #define TRIG_ROUND_UP_NEXT	0x00030000
 
 /* compatibility definitions */
+#define TRIG_BOGUS		CMDF_BOGUS
 #define TRIG_RT			CMDF_PRIORITY
 #define TRIG_WAKE_EOS		CMDF_WAKE_EOS
 #define TRIG_WRITE		CMDF_WRITE
-- 
2.1.0


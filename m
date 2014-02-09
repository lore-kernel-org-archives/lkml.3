Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060AbaBIPJk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 10:09:40 -0500
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:58915 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751434AbaBIPJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 10:09:38 -0500
X-Greylist: delayed 799 seconds by postgrey-1.27 at vger.kernel.org; Sun, 09 Feb 2014 10:09:38 EST
Message-ID: <1391958577.25424.22.camel@x220>
Subject: [PATCH] [media] v4l: omap4iss: Remove VIDEO_OMAP4_DEBUG
From: Paul Bolle <pebolle@tiscali.nl>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Sun, 09 Feb 2014 16:09:37 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Feb 2014 15:09:37.0201 (UTC) FILETIME=[F29AFA10:01CF25A8]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit d632dfefd36f ("[media] v4l: omap4iss: Add support for OMAP4
camera interface - Build system") added a Kconfig entry for
VIDEO_OMAP4_DEBUG. But nothing uses that symbol.

This entry was apparently copied from a similar entry for "OMAP 3
Camera debug messages". But a corresponding Makefile line is missing.
Besides, the debug code also depends on a mysterious ISS_ISR_DEBUG
macro. This Kconfig entry can be removed.

Someone familiar with the code might be able to say what to do with the
code depending on the DEBUG and ISS_ISR_DEBUG macros.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

 drivers/staging/media/omap4iss/Kconfig | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/staging/media/omap4iss/Kconfig b/drivers/staging/media/omap4iss/Kconfig
index b9fe753..78b0fba 100644
--- a/drivers/staging/media/omap4iss/Kconfig
+++ b/drivers/staging/media/omap4iss/Kconfig
@@ -4,9 +4,3 @@ config VIDEO_OMAP4
 	select VIDEOBUF2_DMA_CONTIG
 	---help---
 	  Driver for an OMAP 4 ISS controller.
-
-config VIDEO_OMAP4_DEBUG
-	bool "OMAP 4 Camera debug messages"
-	depends on VIDEO_OMAP4
-	---help---
-	  Enable debug messages on OMAP 4 ISS controller driver.
-- 
1.8.5.3


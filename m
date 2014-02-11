Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751763AbaBKLRK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 06:17:10 -0500
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:62783 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750878AbaBKLRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 06:17:05 -0500
Message-ID: <1392117421.5686.4.camel@x220>
Subject: [PATCH v2] [media] v4l: omap4iss: Add DEBUG compiler flag
From: Paul Bolle <pebolle@tiscali.nl>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Tue, 11 Feb 2014 12:17:01 +0100
In-Reply-To: <1409428.L7JLLEda5C@avalon>
References: <1391958577.25424.22.camel@x220> <3300576.MqDnfacnEA@avalon>
	 <1392045231.3585.33.camel@x220> <1409428.L7JLLEda5C@avalon>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Feb 2014 11:17:02.0150 (UTC) FILETIME=[C992AE60:01CF271A]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit d632dfefd36f ("[media] v4l: omap4iss: Add support for OMAP4
camera interface - Build system") added a Kconfig entry for
VIDEO_OMAP4_DEBUG. But nothing uses that symbol.

This entry was apparently copied from a similar entry for "OMAP 3
Camera debug messages". The OMAP 3 entry is used to set the DEBUG
compiler flag, which enables calls of dev_dbg().

So add a Makefile line to do that for omap4iss too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) v1 was called "[media] v4l: omap4iss: Remove VIDEO_OMAP4_DEBUG". This
versions implements Laurent's alternative (which is much better).

1) Still untested.

 drivers/staging/media/omap4iss/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/media/omap4iss/Makefile b/drivers/staging/media/omap4iss/Makefile
index a716ce9..f46c6bd 100644
--- a/drivers/staging/media/omap4iss/Makefile
+++ b/drivers/staging/media/omap4iss/Makefile
@@ -1,5 +1,7 @@
 # Makefile for OMAP4 ISS driver
 
+ccflags-$(CONFIG_VIDEO_OMAP4_DEBUG) += -DDEBUG
+
 omap4-iss-objs += \
 	iss.o iss_csi2.o iss_csiphy.o iss_ipipeif.o iss_ipipe.o iss_resizer.o iss_video.o
 
-- 
1.8.5.3


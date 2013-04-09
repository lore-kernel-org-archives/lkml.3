Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936456Ab3DIJQF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 05:16:05 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:65323 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935178Ab3DIJQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 05:16:00 -0400
Message-ID: <1365498958.1830.157.camel@x61.thuisdomein>
Subject: [PATCH v2] [media] soc-camera: remove two unused configs
From: Paul Bolle <pebolle@tiscali.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 09 Apr 2013 11:15:58 +0200
In-Reply-To: <1365453268.1830.137.camel@x61.thuisdomein>
References: <1365453268.1830.137.camel@x61.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Apr 2013 09:15:58.0805 (UTC) FILETIME=[D90D3050:01CE3502]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The last users of Kconfig symbols MX3_VIDEO and VIDEO_MX2_HOSTSUPPORT
were removed in v3.2. Their Kconfig entries can be removed now.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
v1 was called "[...] remove "config MX3_VIDEO"". But it turned out that
v3.2, through commit 389d12cc7f ("ARM: mxc: Remove setting of consistent
dma size"), also removed the last user of VIDEO_MX2_HOSTSUPPORT. Still
tested with "git grep" only.

 drivers/media/platform/soc_camera/Kconfig | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/media/platform/soc_camera/Kconfig b/drivers/media/platform/soc_camera/Kconfig
index b139b52..ffd0010 100644
--- a/drivers/media/platform/soc_camera/Kconfig
+++ b/drivers/media/platform/soc_camera/Kconfig
@@ -27,14 +27,10 @@ config VIDEO_MX1
 	---help---
 	  This is a v4l2 driver for the i.MX1/i.MXL CMOS Sensor Interface
 
-config MX3_VIDEO
-	bool
-
 config VIDEO_MX3
 	tristate "i.MX3x Camera Sensor Interface driver"
 	depends on VIDEO_DEV && MX3_IPU && SOC_CAMERA
 	select VIDEOBUF2_DMA_CONTIG
-	select MX3_VIDEO
 	---help---
 	  This is a v4l2 driver for the i.MX3x Camera Sensor Interface
 
@@ -66,14 +62,10 @@ config VIDEO_OMAP1
 	---help---
 	  This is a v4l2 driver for the TI OMAP1 camera interface
 
-config VIDEO_MX2_HOSTSUPPORT
-	bool
-
 config VIDEO_MX2
 	tristate "i.MX27 Camera Sensor Interface driver"
 	depends on VIDEO_DEV && SOC_CAMERA && MACH_MX27
 	select VIDEOBUF2_DMA_CONTIG
-	select VIDEO_MX2_HOSTSUPPORT
 	---help---
 	  This is a v4l2 driver for the i.MX27 Camera Sensor Interface
 
-- 
1.7.11.7


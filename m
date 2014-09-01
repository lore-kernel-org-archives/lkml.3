Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982AbaIANSM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 09:18:12 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:14220 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282AbaIANSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 09:18:09 -0400
X-AuditID: cbfee61a-f79e46d00000134f-53-5404720ee907
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] v4l: vsp1: fix driver dependencies
Date: Mon, 01 Sep 2014 15:18:02 +0200
Message-id: <25174054.f3JtKIKjvH@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPLMWRmVeSWpSXmKPExsVy+t9jAV2+IpYQg2vrRCyat35ltDjb9Ibd
	4vKuOWwWPRu2slrM+TOF2eLiOnmLB6vfsjmwe+ycdZfdo2/LKkaPOT+/sXh83iQXwBLFZZOS
	mpNZllqkb5fAlXFneidrwTX2ipvfX7A1MJ5i62Lk5JAQMJFYffUwE4QtJnHh3nqgOBeHkMAi
	RonlD1axQzgtTBJPz2wH62ATsJKY2L6KEcQWETCQeLzoJFgRs8A5RoknbzvYQRLCAsYSZza2
	MIPYLAKqEq+nHweL8wpoSSz9soQVxBYV8JTYsX0lG0RcUOLH5HssIDazgLzEvv1TWSFsLYn1
	O48zTWDkm4WkbBaSsllIyhYwMq9iFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECA7WZ1I7GFc2
	WBxiFOBgVOLhfTCLOUSINbGsuDL3EKMEB7OSCG9qBkuIEG9KYmVValF+fFFpTmrxIUZpDhYl
	cd4DrdaBQgLpiSWp2ampBalFMFkmDk6pBkaztq2xx+Q7m0oO77nCXRsye9nWi8JhS3uX3d6z
	sYOJO0pk6yOFtTsjY4L5yg7oLTon8/zqpWP/FlpciPp85XStiM1ts3VMk4oWXNkYtW7SFq4F
	PSurarIX34hwqG3YZxXHFJx16cXLCa67epY7TxAq1fC7LStZuK6nZK/CTiMvmfjqZN1j59Yr
	sRRnJBpqMRcVJwIAt0mj51ICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Renesas VSP1 Video Processing Engine support should be available
only on Renesas ARM SoCs.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Simon Horman <horms@verge.net.au>
Cc: Magnus Damm <magnus.damm@gmail.com>
---
 drivers/media/platform/Kconfig |    1 +
 1 file changed, 1 insertion(+)

Index: b/drivers/media/platform/Kconfig
===================================================================
--- a/drivers/media/platform/Kconfig	2014-09-01 14:51:37.024553544 +0200
+++ b/drivers/media/platform/Kconfig	2014-09-01 15:17:34.284594657 +0200
@@ -213,6 +213,7 @@ config VIDEO_SH_VEU
 config VIDEO_RENESAS_VSP1
 	tristate "Renesas VSP1 Video Processing Engine"
 	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && HAS_DMA
+	depends on ARCH_SHMOBILE || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
 	---help---
 	  This is a V4L2 driver for the Renesas VSP1 video processing engine.


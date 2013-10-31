Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092Ab3JaSHf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 14:07:35 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49336 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599Ab3JaSHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 14:07:34 -0400
Message-ID: <52729C60.6000408@infradead.org>
Date: Thu, 31 Oct 2013 11:07:28 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        linux-media <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH -next] media/platform/marvell-ccic: fix cafe_ccic build error
References: <20131031210027.cb3604b9589e0b7a1599dbd2@canb.auug.org.au>
In-Reply-To: <20131031210027.cb3604b9589e0b7a1599dbd2@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

The cafe_ccic driver (the mcam-core.c part of it) uses dma_sg
interfaces so it needs to select VIDEOBUF2_DMA_SG to prevent
build errors.

drivers/built-in.o: In function `mcam_v4l_open':
mcam-core.c:(.text+0x14643e): undefined reference to `vb2_dma_sg_memops'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/platform/marvell-ccic/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20131031.orig/drivers/media/platform/marvell-ccic/Kconfig
+++ linux-next-20131031/drivers/media/platform/marvell-ccic/Kconfig
@@ -4,6 +4,7 @@ config VIDEO_CAFE_CCIC
 	select VIDEO_OV7670
 	select VIDEOBUF2_VMALLOC
 	select VIDEOBUF2_DMA_CONTIG
+	select VIDEOBUF2_DMA_SG
 	---help---
 	  This is a video4linux2 driver for the Marvell 88ALP01 integrated
 	  CMOS camera controller.  This is the controller found on first-

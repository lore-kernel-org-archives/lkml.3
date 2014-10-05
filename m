Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908AbaJEJCU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 05:02:20 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:39336 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbaJEJAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 05:00:16 -0400
From: "=?UTF-8?q?=D0=91=D1=83=D0=B4=D0=B8=20=D0=A0=D0=BE=D0=BC=D0=B0=D0=BD=D1=82=D0=BE=2C=20AreMa=20Inc?=" 
	<info@are.ma>
X-Google-Original-From: =?UTF-8?q?=D0=91=D1=83=D0=B4=D0=B8=20=D0=A0=D0=BE=D0=BC=D0=B0=D0=BD=D1=82=D0=BE=2C=20AreMa=20Inc?= <knightrider@are.ma>
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, crope@iki.fi, m.chehab@samsung.com,
        mchehab@osg.samsung.com, hdegoede@redhat.com,
        laurent.pinchart@ideasonboard.com, mkrufky@linuxtv.org,
        sylvester.nawrocki@gmail.com, g.liakhovetski@gmx.de,
        peter.senna@gmail.com
Subject: [PATCH 05/11] pt3: merge I2C & DMA handlers
Date: Sun,  5 Oct 2014 17:59:41 +0900
Message-Id: <ef2898c4479c9749d33769353cecbbe3410efeae.1412497399.git.knightrider@are.ma>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <cover.1412497399.git.knightrider@are.ma>
References: <cover.1412497399.git.knightrider@are.ma>
In-Reply-To: <cover.1412497399.git.knightrider@are.ma>
References: <cover.1412497399.git.knightrider@are.ma>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I2C & DMA handlers are merged into single file.

Signed-off-by: Буди Романто, AreMa Inc <knightrider@are.ma>
---
 drivers/media/pci/pt3/Makefile | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/media/pci/pt3/Makefile b/drivers/media/pci/pt3/Makefile
index 396f146..56ebc9b 100644
--- a/drivers/media/pci/pt3/Makefile
+++ b/drivers/media/pci/pt3/Makefile
@@ -1,8 +1,4 @@
+obj-$(CONFIG_DVB_PT3) += pt3.o
 
-earth-pt3-objs += pt3.o pt3_i2c.o pt3_dma.o
+ccflags-y += -Idrivers/media/dvb-core -Idrivers/media/dvb-frontends -Idrivers/media/tuners
 
-obj-$(CONFIG_DVB_PT3) += earth-pt3.o
-
-ccflags-y += -Idrivers/media/dvb-core
-ccflags-y += -Idrivers/media/dvb-frontends
-ccflags-y += -Idrivers/media/tuners
-- 
1.8.4.5


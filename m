Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060AbaCZPkQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 11:40:16 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:15725 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbaCZPkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 11:40:12 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-38-5332f4d9efc6
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Tejun Heo <tj@kernel.org>
Cc: Mark Langsdorf <mark.langsdorf@calxeda.com>, Rob Herring <robh@kernel.org>,
        linux-ide@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ata: fix Calxeda Highbank SATA driver dependencies
Date: Wed, 26 Mar 2014 16:39:50 +0100
Message-id: <2920312.TnoQcCR5HX@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJLMWRmVeSWpSXmKPExsVy+t9jAd2bX4yCDfb8sbHY9Pgaq8WxHY+Y
	LC7vmsNmcb3tFLvF/z072C1+LT/K6MDmseDzFXaPTas62Tw2L6n3+LxJLoAlissmJTUnsyy1
	SN8ugSvj1MlTrAWP2CuOrzvE3MB4iK2LkZNDQsBEYvm+z0wQtpjEhXvrweJCAosYJSbuq+xi
	5AKyW5gkujaeYQVJsAlYSUxsX8UIYosIyEpcmfaQEaSIWWAjo8SqE/9ZQBLCAs4SF/eeYQex
	WQRUJeYseQm2gVdAU2Luq71gtqiAp8SO7SvZIOKCEj8m3wPrZRaQl9i3fyorhK0lsX7ncaYJ
	jHyzkJTNQlI2C0nZAkbmVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjBAfpMegfjqgaLQ4wC
	HIxKPLw77hsFC7EmlhVX5h5ilOBgVhLh1X0GFOJNSaysSi3Kjy8qzUktPsQozcGiJM57sNU6
	UEggPbEkNTs1tSC1CCbLxMEp1cC4QCEvqrO98L6XqsXylro13/Suzz/kf6lUY1OS/vqfIjqs
	35S6t/kFZOT1tBetSNzy++VLhWIWg18RLKfUVTW/aSdnObyLqhL6pxJ08tnSKmstY2Xp+VKf
	ZO84zjV9tX5B8FNZE56Hsp8E081KHiSrLn1rIccwY82D44zCrH8fa/20OZx0tFCJpTgj0VCL
	uag4EQAk/fuXTAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sata_highbank host driver depend on ARCH_HIGHBANK config option
as Calxeda Highbank SATA support is specific to Calxeda Highbank
SoCs and the driver to work requires suitable device tree node to
be defined.  Additionally allow the driver build if COMPILE_TEST
config option is set.

Cc: Mark Langsdorf <mark.langsdorf@calxeda.com>
Cc: Rob Herring <robh@kernel.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
---
 drivers/ata/Kconfig |    1 +
 1 file changed, 1 insertion(+)

Index: b/drivers/ata/Kconfig
===================================================================
--- a/drivers/ata/Kconfig	2014-03-26 15:32:57.455119357 +0100
+++ b/drivers/ata/Kconfig	2014-03-26 15:49:59.919101924 +0100
@@ -264,6 +264,7 @@ config SATA_DWC_VDEBUG
 
 config SATA_HIGHBANK
 	tristate "Calxeda Highbank SATA support"
+	depends on ARCH_HIGHBANK || COMPILE_TEST
 	help
 	  This option enables support for the Calxeda Highbank SoC's
 	  onboard SATA.


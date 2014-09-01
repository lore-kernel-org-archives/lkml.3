Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978AbaIAOYt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 10:24:49 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:18926 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965AbaIAOYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 10:24:47 -0400
X-AuditID: cbfee61b-f79f86d00000144c-18-540481ad534a
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, linux-usb@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] usb: renesas_usbhs: fix driver dependencies
Date: Mon, 01 Sep 2014 16:24:40 +0200
Message-id: <1601192.oClrOJlUe8@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMLMWRmVeSWpSXmKPExsVy+t9jAd21jSwhBl8vqFo0L17PZtG89Suj
	xdmmN+wWl3fNYbOY82cKs8WiZa3MFg9Wv2VzYPfYOesuu8f+uWvYPfq2rGL0mPPzG4vH501y
	AaxRXDYpqTmZZalF+nYJXBmLbv9mLDjPXtE3Xa2BcR9bFyMnh4SAicSCWY2sELaYxIV768Hi
	QgKLGCVedCh2MXIB2S1MEo1ty8ESbAJWEhPbVzGC2CICxhL9Z2exgxQxC5xhlJj7tYUZJCEs
	YC/x61AHO4jNIqAq0Tj9Flgzr4CmxNxHv1lAbFEBT4kd21dCxQUlfky+BxZnFpCX2Ld/KiuE
	rSWxfudxpgmMfLOQlM1CUjYLSdkCRuZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMFB+0x6
	B+OqBotDjAIcjEo8vA9mMYcIsSaWFVfmHmKU4GBWEuFNzWAJEeJNSaysSi3Kjy8qzUktPsQo
	zcGiJM57sNU6UEggPbEkNTs1tSC1CCbLxMEp1cC4oVg7wemyf91sP56snWol523nNouov9uW
	JescGnf11OSDK7eXrNXKW8z68dVWzr/1D9l85BiPKdRLxF1JfnK0S+W08qT76j6umS8Tp4Tf
	jM6u+7E+UcNA8cPO2DcBF4Riutq2KEya97d8pmnT+is+GSceRs+7GCKxo0JCfu2rSJvK98nZ
	vJxKLMUZiYZazEXFiQB6/V5RVgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Renesas USBHS controller support should be available only on
Renesas ARM SoCs and SuperH architecture.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Simon Horman <horms@verge.net.au>
Cc: Magnus Damm <magnus.damm@gmail.com>
---
v2:
- s/ARCH_SH/SUPERH/ (thanks to Sergei Shtylyov)

 drivers/usb/renesas_usbhs/Kconfig |    1 +
 1 file changed, 1 insertion(+)

Index: b/drivers/usb/renesas_usbhs/Kconfig
===================================================================
--- a/drivers/usb/renesas_usbhs/Kconfig	2014-07-30 14:31:51.883523522 +0200
+++ b/drivers/usb/renesas_usbhs/Kconfig	2014-09-01 14:25:42.028512490 +0200
@@ -5,6 +5,7 @@
 config USB_RENESAS_USBHS
 	tristate 'Renesas USBHS controller'
 	depends on USB_GADGET
+	depends on ARCH_SHMOBILE || SUPERH || COMPILE_TEST
 	default n
 	help
 	  Renesas USBHS is a discrete USB host and peripheral controller chip


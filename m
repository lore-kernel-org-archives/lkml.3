Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756AbaIANOK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 09:14:10 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:26554 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376AbaIANOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 09:14:08 -0400
X-AuditID: cbfee61b-f79f86d00000144c-35-5404711e1959
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, linux-usb@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] usb: renesas_usbhs: fix driver dependencies
Date: Mon, 01 Sep 2014 15:14:02 +0200
Message-id: <8246169.KgpDT6Hn5J@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t9jAV25QpYQgzNH2S2aF69ns2je+pXR
	4mzTG3aLy7vmsFnM+TOF2WLRslZmiwer37I5sHvsnHWX3WP/3DXsHn1bVjF6zPn5jcXj8ya5
	ANYoLpuU1JzMstQifbsEroz7TZ+ZCmawVxx7+YyxgXESWxcjJ4eEgInErMUnmSFsMYkL99YD
	xbk4hAQWMUo8fXKYHcJpYZL4e3ITWAebgJXExPZVjCC2iICxRP/ZWWBFzAJnGCXmfm0BGyUs
	YCOxYMslIJuDg0VAVWLuk1SQMK+ApsTh3S/ASkQFPCV2bF/JBhEXlPgx+R4LiM0sIC+xb/9U
	VghbS2L9zuNMExj5ZiEpm4WkbBaSsgWMzKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxgsP2
	mfQOxlUNFocYBTgYlXh4H8xiDhFiTSwrrsw9xCjBwawkwpuawRIixJuSWFmVWpQfX1Sak1p8
	iFGag0VJnPdgq3WgkEB6YklqdmpqQWoRTJaJg1OqgTGbT6J/xY+tWwueCPTd2BIQMiFbeX+U
	5AQL92vtlw69zazJn8iTNntXXT/HkZ177sW8eBYQqur83W7FxukTOaYKmWxn2LzTI9H56+95
	rldn8L88nhTlLxAx98uPsnWTBbkdQnm4fnd+O3HszPvOr+IuC+qfvzz+L3lXlzHPUj2Gk66c
	Kyce85JVYinOSDTUYi4qTgQAqYHaKVcCAAA=
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
+	depends on ARCH_SHMOBILE || ARCH_SH || COMPILE_TEST
 	default n
 	help
 	  Renesas USBHS is a discrete USB host and peripheral controller chip


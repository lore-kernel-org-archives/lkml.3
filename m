Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861AbaC0PRR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 11:17:17 -0400
Received: from vsp-authed02.binero.net ([195.74.38.226]:28982 "EHLO
	vsp-authed-02-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755862AbaC0PRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 11:17:09 -0400
From: Andreas Larsson <andreas@gaisler.com>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mark Rutland <mark.rutland@arm.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        software@gaisler.com
Subject: [PATCH v2 2/7] usb: gadget: gr_udc: Expand devicetree documentation
Date: Thu, 27 Mar 2014 16:15:54 +0100
Message-Id: <1395933359-7109-3-git-send-email-andreas@gaisler.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1395933359-7109-1-git-send-email-andreas@gaisler.com>
References: <1395933359-7109-1-git-send-email-andreas@gaisler.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide more information on the two different interrupt cases and more
information of endpoint buffer sizes. Suggested by Mark Rutland.

Signed-off-by: Andreas Larsson <andreas@gaisler.com>
---
Differences since v1: none

 Documentation/devicetree/bindings/usb/gr-udc.txt |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/Documentation/devicetree/bindings/usb/gr-udc.txt b/Documentation/devicetree/bindings/usb/gr-udc.txt
index 0c5118f..e944522 100644
--- a/Documentation/devicetree/bindings/usb/gr-udc.txt
+++ b/Documentation/devicetree/bindings/usb/gr-udc.txt
@@ -12,17 +12,23 @@ Required properties:
 
 - reg : Address and length of the register set for the device
 
-- interrupts : Interrupt numbers for this device
+- interrupts : Interrupt numbers for this device. Either one interrupt number
+	for all interrupts, or one for status related interrupts, one for IN
+	endpoint related interrupts and one for OUT endpoint related interrupts.
 
 Optional properties:
 
-- epobufsizes : An array of buffer sizes for OUT endpoints. If the property is
-	not present, or for endpoints outside of the array, 1024 is assumed by
-	the driver.
-
-- epibufsizes : An array of buffer sizes for IN endpoints. If the property is
-	not present, or for endpoints outside of the array, 1024 is assumed by
-	the driver.
+- epobufsizes : Array of buffer sizes for OUT endpoints when they differ
+	from the default size of 1024. The array is indexed by the OUT endpoint
+	number. If the property is present it typically contains one entry for
+	each OUT endpoint of the core. Fewer entries overrides the default sizes
+	only for as many endpoints as the array contains.
+
+- epibufsizes : Array of buffer sizes for IN endpoints when they differ
+	from the default size of 1024. The array is indexed by the IN endpoint
+	number. If the property is present it typically contains one entry for
+	each IN endpoint of the core. Fewer entries overrides the default sizes
+	only for as many endpoints as the array contains.
 
 For further information look in the documentation for the GLIB IP core library:
 http://www.gaisler.com/products/grlib/grip.pdf
-- 
1.7.10.4


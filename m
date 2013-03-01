Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336Ab3CAUWs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 15:22:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51366 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500Ab3CATpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:45:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>
Subject: [ 15/77] usb: dwc3: gadget: change HIRD threshold to 12
Date: Fri,  1 Mar 2013 11:44:00 -0800
Message-Id: <20130301194353.619404924@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130301194351.913471337@linuxfoundation.org>
References: <20130301194351.913471337@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felipe Balbi <balbi@ti.com>

commit 1a947746dbe1486d0e305ab512ddf085b7874cb3 upstream.

First of all, that 28 value makes no sense as
HIRD threshold is a 4-bit value, second of all
it's causing issues for OMAP5.

Using 12 because commit cbc725b3 (usb: dwc3:
keep default hird threshold value as 4b1100)
had the intention of setting the maximum allowed
value of 0xc.

Also, original code has been wrong forever, so
this should be backported as far back as
possible.

Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/dwc3/gadget.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2190,8 +2190,11 @@ static void dwc3_gadget_conndone_interru
 		reg = dwc3_readl(dwc->regs, DWC3_DCTL);
 		reg &= ~(DWC3_DCTL_HIRD_THRES_MASK | DWC3_DCTL_L1_HIBER_EN);
 
-		/* TODO: This should be configurable */
-		reg |= DWC3_DCTL_HIRD_THRES(28);
+		/*
+		 * TODO: This should be configurable. For now using
+		 * maximum allowed HIRD threshold value of 0b1100
+		 */
+		reg |= DWC3_DCTL_HIRD_THRES(12);
 
 		dwc3_writel(dwc->regs, DWC3_DCTL, reg);
 	}



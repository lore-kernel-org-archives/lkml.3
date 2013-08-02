Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838Ab3HBKu7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:50:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37158 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759415Ab3HBKJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:09:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ruchika Kharwar <ruchika@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: [ 27/99] usb: dwc3: fix the error returned with usb3_phy failure
Date: Fri,  2 Aug 2013 18:07:40 +0800
Message-Id: <20130802100229.841086435@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.4.841.g1a3f60e
In-Reply-To: <20130802100225.478715166@linuxfoundation.org>
References: <20130802100225.478715166@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruchika Kharwar <ruchika@ti.com>

commit 315955d707b50c8aad20a32ec0dd4c9fe243cabe upstream.

When there is an error with the usb3_phy probe or absence, the error returned
is erroneously for usb2_phy.

Signed-off-by: Ruchika Kharwar <ruchika@ti.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/dwc3/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -450,7 +450,7 @@ static int dwc3_probe(struct platform_de
 	}
 
 	if (IS_ERR(dwc->usb3_phy)) {
-		ret = PTR_ERR(dwc->usb2_phy);
+		ret = PTR_ERR(dwc->usb3_phy);
 
 		/*
 		 * if -ENXIO is returned, it means PHY layer wasn't



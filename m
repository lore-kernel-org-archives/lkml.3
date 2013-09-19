Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab3ISJvB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 05:51:01 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:58010 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375Ab3ISJu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 05:50:56 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-1f-523ac8ff5da9
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com,
        m.szyprowski@samsung.com, Robert Baldyga <r.baldyga@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH v3 5/7] USB: gadget: s3c-hsotg: fix "halted" property updating
Date: Thu, 19 Sep 2013 11:50:21 +0200
Message-id: <1379584223-15232-6-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1379584223-15232-1-git-send-email-r.baldyga@samsung.com>
References: <1379584223-15232-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprELMWRmVeSWpSXmKPExsVy+t9jQd3/J6yCDJb807fYOGM9q8XB+/UW
	zYvXs1mcbXrDbnF51xw2i0XLWpkt1h65y27x4PBOdgcOj/1z17B79G1Zxehx/MZ2Jo/Pm+QC
	WKK4bFJSczLLUov07RK4Mha+285WsJ+94sKjo4wNjLPYuhg5OSQETCQ+995ngbDFJC7cWw8U
	5+IQEpjOKHGt/QpYkZBAO5PEwv/OIDabgI7Elu8TGEFsEQEBifUvLrGDNDALPGGUmHrkFTtI
	QljAT2LatS9gU1kEVCX+/GsBi/MKuEpsefcHqJkDaJuCxJxJNiBhTgE3iYnnX7NA7HKVeLzp
	C9sERt4FjAyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYJD6pn0DsZVDRaHGAU4GJV4eCMu
	WAYJsSaWFVfmHmKU4GBWEuGdc8gqSIg3JbGyKrUoP76oNCe1+BCjNAeLkjjvwVbrQCGB9MSS
	1OzU1ILUIpgsEwenVANjRyM375aLfCsTtsa8uzThYsmDwxe7vO8f27RkwdXLH+K+/T15L/1Q
	tuDeD54Pvp+RZ2NbxVR65aaSyiwNHR/jrF9NOX3ffksfMj6/TbCbU1920lGNWpkK1ekXPlqb
	G/ZO3nclXezE/gyGb4eDw1ZeFBGf5FrSbPvg/Ndd+2ryKxes2O1ZpLyiQImlOCPRUIu5qDgR
	ADezUvElAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Property "halted" of s3c_hsotg_ep structure is actually initialised when ep
enabled, and changed when halt is set/cleared.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/usb/gadget/s3c-hsotg.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-hsotg.c
index e32f868..23eec8f 100644
--- a/drivers/usb/gadget/s3c-hsotg.c
+++ b/drivers/usb/gadget/s3c-hsotg.c
@@ -2605,6 +2605,7 @@ static int s3c_hsotg_ep_enable(struct usb_ep *ep,
 
 	/* default, set to non-periodic */
 	hs_ep->periodic = 0;
+	hs_ep->halted = 0;
 
 	switch (desc->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) {
 	case USB_ENDPOINT_XFER_ISOC:
@@ -2800,6 +2801,8 @@ static int s3c_hsotg_ep_sethalt(struct usb_ep *ep, int value)
 
 	writel(epctl, hs->regs + epreg);
 
+	hs_ep->halted = value;
+
 	return 0;
 }
 
-- 
1.7.9.5


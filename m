Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680Ab3IRKWN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 06:22:13 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:16364 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636Ab3IRKWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 06:22:10 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-29-52397ed1aabe
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com,
        m.szyprowski@samsung.com, Robert Baldyga <r.baldyga@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH v2 5/6] USB: gadget: s3c-hsotg: fix "halted" property updating
Date: Wed, 18 Sep 2013 12:21:34 +0200
Message-id: <1379499695-5279-6-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1379499695-5279-1-git-send-email-r.baldyga@samsung.com>
References: <1379499695-5279-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprILMWRmVeSWpSXmKPExsVy+t9jAd2LdZZBBq2LLSw2zljPanHwfr1F
	8+L1bBZnm96wW1zeNYfNYtGyVmaLtUfusls8OLyT3YHDY//cNewefVtWMXocv7GdyePzJrkA
	ligum5TUnMyy1CJ9uwSujIXvtrMV7GevuPDoKGMD4yy2LkZODgkBE4mOUxuYIWwxiQv31gPF
	uTiEBBYxSjz7cp0Jwmlnkrj9YBM7SBWbgI7Elu8TGEFsEQEBifUvLrGDFDELPGGUmHrkFZDD
	wSEs4CexsU0HxGQRUJW4+jgYpJxXwEVi+s1uZpCwhICCxJxJNiBhTgFXiV1/7rCC2EJAJTP7
	57FOYORdwMiwilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4oJ5J7WBc2WBxiFGAg1GJh/dC
	uUWQEGtiWXFl7iFGCQ5mJRFelzLLICHelMTKqtSi/Pii0pzU4kOM0hwsSuK8B1qtA4UE0hNL
	UrNTUwtSi2CyTBycUg2MQpciHxwInJB0Ye/FQ8tvOiw/o8I4uZJBXpIl+77LPQkJVcaoQ2kB
	SrGlOxqX6104MEv82qr6stn1/w8c9fhb0vjx45umeXNN1hSKZW5x0+MI2vCuUG9FS+DWV3un
	/TVY1n+s9menJff/iDwBiQ08dzuWHVvhn/1/uZHy9ogF4g8Ezcqc1fZGKLEUZyQaajEXFScC
	APe1tVYkAgAA
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


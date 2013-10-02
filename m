Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab3JBJR6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 05:17:58 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:35524 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185Ab3JBJR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 05:17:56 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-82-524be4c2aebd
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com,
        m.szyprowski@samsung.com, andrzej.p@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v2] USB: gadget: s3c-hsotg: fix maxpacket size
Date: Wed, 02 Oct 2013 11:17:29 +0200
Message-id: <1380705449-6969-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <20131001135630.GN1476@radagast>
References: <20131001135630.GN1476@radagast>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMLMWRmVeSWpSXmKPExsVy+t9jQd1DT7yDDPYcN7SY9bKdxWLjjPWs
	Fgfv11s0L17PZnF51xw2i0XLWpkt1h65y27x4PBOdgcOj/1z17B79G1Zxehx/MZ2Jo/Pm+QC
	WKK4bFJSczLLUov07RK4MjrbV7IVdPJVbNu5h6mB8RB3FyMnh4SAicS8xb+ZIWwxiQv31rN1
	MXJxCAlMZ5SYeXEpO4TTziSx69EdFpAqNgEdiS3fJzCC2CICAhLrX1wCK2IWuMAo8X7BOnaQ
	hLCAncSpdX1MIDaLgKrEondP2EBsXgEXiUkP9wPZHEDrFCTmTLIBCXMK6Eqcm38W7AohoPlz
	lixjm8DIu4CRYRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcFA9k97BuKrB4hCjAAejEg+v
	xEOvICHWxLLiytxDjBIczEoivBXHvYOEeFMSK6tSi/Lji0pzUosPMUpzsCiJ8x5stQ4UEkhP
	LEnNTk0tSC2CyTJxcEo1MFodj71+d+K/VRc3r936Yv2HwxMnGfLc7pUWvS/umB24/Koh87dL
	C34t8Lp4cTFT6dqiFxcPzWFhuny30mPRoTl+Fxdrt/yZeGx/6o7guE8n+N7/Sf9wcF/5j0oL
	k/nXd0/+wnRfRHS6299ve60OKDn1drpkbbT7Z/Pi7E7/5GaNzbKLtsVfu95wS4mlOCPRUIu5
	qDgRAJrtBf4mAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes ep maxpacket value from 512 to 1024, because it's needed
to handle interupt and isochronous endpoints in high-speed mode. This change
doesn't affect on driver functioning, because fifo size (3072) is still enough
for the maximum transaction payload (3*1024 for high-speed high-bandwidtch
endpoints).

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---

Hello,

This is update for my patch. From last version I have fixed typos
pointed out by Felipe Balbi.

On 10/01/2013 03:56 PM, Felipe Balbi wrote:> Hi,
> 
> On Fri, Sep 27, 2013 at 12:31:09PM +0200, Robert Baldyga wrote:
>> This patch changes ep maxpacket value from 512 to 1024, becouse it's needed
> 
> shouldn't you use 3072 instead to cope with high bandwidth ISO
> endpoints ?
> 

No, because this value indicates maximum size of single transaction.
In high bandwidth transfers there are up to three transactions per
microframe which gives up to 3072 bytes. Number of additional
transactions per microframe is indicated by bits 11 and 12 of
wMaxPacketSize field of endpoint descriptor and does not depend on
endpoint maxpacket value.

Best regards
Robert Baldyga
Samsung R&D Institute Poland

 drivers/usb/gadget/s3c-hsotg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-hsotg.c
index 8a9e2c6..0d1dcbd 100644
--- a/drivers/usb/gadget/s3c-hsotg.c
+++ b/drivers/usb/gadget/s3c-hsotg.c
@@ -3146,7 +3146,7 @@ static void s3c_hsotg_initep(struct s3c_hsotg *hsotg,
 
 	hs_ep->parent = hsotg;
 	hs_ep->ep.name = hs_ep->name;
-	hs_ep->ep.maxpacket = epnum ? 512 : EP0_MPS_LIMIT;
+	hs_ep->ep.maxpacket = epnum ? 1024 : EP0_MPS_LIMIT;
 	hs_ep->ep.ops = &s3c_hsotg_ep_ops;
 
 	/*
-- 
1.7.9.5


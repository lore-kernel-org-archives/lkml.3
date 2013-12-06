Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757964Ab3LFMEH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 07:04:07 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:57497 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757670Ab3LFMED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 07:04:03 -0500
X-AuditID: cbfee61a-b7f796d000004313-0e-52a1bd327227
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com,
        m.szyprowski@samsung.com, andrzej.p@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 1/2] USB: gadget: s3c-hsotg: fix maxpacket size in
 s3c_hsotg_irq_enumdone
Date: Fri, 06 Dec 2013 13:03:44 +0100
Message-id: <1386331425-16594-2-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1386331425-16594-1-git-send-email-r.baldyga@samsung.com>
References: <1386331425-16594-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOLMWRmVeSWpSXmKPExsVy+t9jAV2jvQuDDCY1yFrMetnOYrFxxnpW
	i4P36y2aF69nszjb9Ibd4vKuOWwWi5a1MlusPXKX3eLB4Z3sDpwe++euYffo27KK0eP4je1M
	Hp83yQWwRHHZpKTmZJalFunbJXBl3J/2mbFgNUdFT+cq5gbGJ2xdjJwcEgImEk8+fGWFsMUk
	LtxbDxTn4hASWMQosWbRFlYIp51JYte29UwgVWwCOhJbvk9gBLFFBAQk1r+4xA5SxCzwl1Hi
	9sNOsLHCAtES7XdPsIDYLAKqEtfPLAVbwSvgKvF/214gmwNonYLEnEk2ICangJvEueVyIBVC
	QBXHpm5gmsDIu4CRYRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcHA9k9rBuLLB4hCjAAej
	Eg8vx6oFQUKsiWXFlbmHGCU4mJVEeG2WLwwS4k1JrKxKLcqPLyrNSS0+xCjNwaIkznug1TpQ
	SCA9sSQ1OzW1ILUIJsvEwSnVwFgSYJ9oz7XV5OyDNfeeuJkebtRKkBS6qTn5jwT7NsZqBssV
	qe3iN+s/rPzx0Pf5pdXvC3MtuTg3zOwyefVHbM8i01OfQi7FHleVbTdWbBeXm/VX5bvB2n1h
	MtLy1lKN5v08upWcK5lClcL9PqV7Nc0T28xvb/DmwJLiB+9Mf5Vwb7y9OpH3rhJLcUaioRZz
	UXEiADGCMM8qAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set maximum possible maxpacket value for each speed. Previous
values didn't allow to use maxpacket sizes greater than 64 in full speed
and 512 in high speed, although hardware is able to handle up to 1023 in fs
and 1024 in hs.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

---
 drivers/usb/gadget/s3c-hsotg.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-hsotg.c
index e20bc10..ad9a4ed 100644
--- a/drivers/usb/gadget/s3c-hsotg.c
+++ b/drivers/usb/gadget/s3c-hsotg.c
@@ -2086,13 +2086,13 @@ static void s3c_hsotg_irq_enumdone(struct s3c_hsotg *hsotg)
 	case DSTS_EnumSpd_FS48:
 		hsotg->gadget.speed = USB_SPEED_FULL;
 		ep0_mps = EP0_MPS_LIMIT;
-		ep_mps = 64;
+		ep_mps = 1023;
 		break;
 
 	case DSTS_EnumSpd_HS:
 		hsotg->gadget.speed = USB_SPEED_HIGH;
 		ep0_mps = EP0_MPS_LIMIT;
-		ep_mps = 512;
+		ep_mps = 1024;
 		break;
 
 	case DSTS_EnumSpd_LS:
-- 
1.7.9.5


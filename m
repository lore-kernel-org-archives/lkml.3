Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492AbaDYBw1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 21:52:27 -0400
Received: from smtprelay0047.hostedemail.com ([216.40.44.47]:42924 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751511AbaDYBvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 21:51:22 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1534:1542:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3353:3870:3871:3876:4321:4605:5007:6119:6261:7809:9040:10004:10026:10848:11026:11232:11473:11657:11658:11914:12043:12296:12438:12517:12519:12555,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: salt57_62fcefedec515
X-Filterd-Recvd-Size: 3638
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Subject: [PATCH 3/5] staging: rtl<foo>: Convert /n to \n
Date: Thu, 24 Apr 2014 18:51:01 -0700
Message-Id: <bdd6aed5239212161e5734c4821243d499b78d33.1398390579.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1398390579.git.joe@perches.com>
References: <cover.1398390579.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a newline character appropriately.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/rtl8188eu/hal/usb_ops_linux.c | 2 +-
 drivers/staging/rtl8188eu/os_dep/usb_intf.c   | 2 +-
 drivers/staging/rtl8723au/hal/usb_ops_linux.c | 4 ++--
 drivers/staging/rtl8723au/os_dep/usb_intf.c   | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/usb_ops_linux.c b/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
index 1fa5370..e94c689 100644
--- a/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
+++ b/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
@@ -559,7 +559,7 @@ static void usb_read_port_complete(struct urb *purb, struct pt_regs *regs)
 			rtw_read_port(adapt, precvpriv->ff_hwaddr, 0, (unsigned char *)precvbuf);
 			break;
 		case -EINPROGRESS:
-			DBG_88E("ERROR: URB IS IN PROGRESS!/n");
+			DBG_88E("ERROR: URB IS IN PROGRESS!\n");
 			break;
 		default:
 			break;
diff --git a/drivers/staging/rtl8188eu/os_dep/usb_intf.c b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
index 49a4ce4..b899191 100644
--- a/drivers/staging/rtl8188eu/os_dep/usb_intf.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
@@ -128,7 +128,7 @@ static u8 rtw_init_intf_priv(struct dvobj_priv *dvobj)
 
 	dvobj->usb_alloc_vendor_req_buf = rtw_zmalloc(MAX_USB_IO_CTL_SIZE);
 	if (dvobj->usb_alloc_vendor_req_buf == NULL) {
-		DBG_88E("alloc usb_vendor_req_buf failed... /n");
+		DBG_88E("alloc usb_vendor_req_buf failed...\n");
 		rst = _FAIL;
 		goto exit;
 	}
diff --git a/drivers/staging/rtl8723au/hal/usb_ops_linux.c b/drivers/staging/rtl8723au/hal/usb_ops_linux.c
index 0311cdf..f5a6e61 100644
--- a/drivers/staging/rtl8723au/hal/usb_ops_linux.c
+++ b/drivers/staging/rtl8723au/hal/usb_ops_linux.c
@@ -415,7 +415,7 @@ urb_submit:
 		case -EPROTO:
 			break;
 		case -EINPROGRESS:
-			DBG_8723A("ERROR: URB IS IN PROGRESS!/n");
+			DBG_8723A("ERROR: URB IS IN PROGRESS!\n");
 			break;
 		default:
 			break;
@@ -711,7 +711,7 @@ static void usb_read_port_complete(struct urb *purb, struct pt_regs *regs)
 				      0, precvbuf);
 			break;
 		case -EINPROGRESS:
-			DBG_8723A("ERROR: URB IS IN PROGRESS!/n");
+			DBG_8723A("ERROR: URB IS IN PROGRESS!\n");
 			break;
 		default:
 			break;
diff --git a/drivers/staging/rtl8723au/os_dep/usb_intf.c b/drivers/staging/rtl8723au/os_dep/usb_intf.c
index 31ab346..287439a 100644
--- a/drivers/staging/rtl8723au/os_dep/usb_intf.c
+++ b/drivers/staging/rtl8723au/os_dep/usb_intf.c
@@ -109,7 +109,7 @@ static u8 rtw_init_intf_priv(struct dvobj_priv *dvobj)
 	dvobj->usb_alloc_vendor_req_buf = kzalloc(MAX_USB_IO_CTL_SIZE,
 						  GFP_KERNEL);
 	if (dvobj->usb_alloc_vendor_req_buf == NULL) {
-		DBG_8723A("alloc usb_vendor_req_buf failed... /n");
+		DBG_8723A("alloc usb_vendor_req_buf failed...\n");
 		rst = _FAIL;
 		goto exit;
 	}
-- 
1.8.1.2.459.gbcd45b4.dirty


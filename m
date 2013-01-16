Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670Ab3APP54 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 10:57:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35631 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756636Ab3APP5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 10:57:52 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tatyana Brokhman <tlinder@codeaurora.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Felipe Balbi <balbi@ti.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 007/222] usb: gadget: network: fix bind() error path
Date: Wed, 16 Jan 2013 13:53:27 -0200
Message-Id: <1358351822-7675-8-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

commit e79cc615a9bb44da72c499ccfa2c9c4bbea3aa84 upstream.

I think this is wrong since 72c973dd ("usb: gadget: add
usb_endpoint_descriptor to struct usb_ep"). If we fail to allocate an ep
or bail out early we shouldn't check for the descriptor which is
assigned at ep_enable() time.

Cc: Tatyana Brokhman <tlinder@codeaurora.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/gadget/f_ecm.c    |    4 ++--
 drivers/usb/gadget/f_eem.c    |    5 ++---
 drivers/usb/gadget/f_ncm.c    |    4 ++--
 drivers/usb/gadget/f_rndis.c  |    4 ++--
 drivers/usb/gadget/f_subset.c |    4 ++--
 5 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/usb/gadget/f_ecm.c b/drivers/usb/gadget/f_ecm.c
index 30b908f..672c66a 100644
--- a/drivers/usb/gadget/f_ecm.c
+++ b/drivers/usb/gadget/f_ecm.c
@@ -808,9 +808,9 @@ fail:
 	/* we might as well release our claims on endpoints */
 	if (ecm->notify)
 		ecm->notify->driver_data = NULL;
-	if (ecm->port.out_ep->desc)
+	if (ecm->port.out_ep)
 		ecm->port.out_ep->driver_data = NULL;
-	if (ecm->port.in_ep->desc)
+	if (ecm->port.in_ep)
 		ecm->port.in_ep->driver_data = NULL;
 
 	ERROR(cdev, "%s: can't bind, err %d\n", f->name, status);
diff --git a/drivers/usb/gadget/f_eem.c b/drivers/usb/gadget/f_eem.c
index 1a7b2dd..a9cf2052 100644
--- a/drivers/usb/gadget/f_eem.c
+++ b/drivers/usb/gadget/f_eem.c
@@ -319,10 +319,9 @@ fail:
 	if (f->hs_descriptors)
 		usb_free_descriptors(f->hs_descriptors);
 
-	/* we might as well release our claims on endpoints */
-	if (eem->port.out_ep->desc)
+	if (eem->port.out_ep)
 		eem->port.out_ep->driver_data = NULL;
-	if (eem->port.in_ep->desc)
+	if (eem->port.in_ep)
 		eem->port.in_ep->driver_data = NULL;
 
 	ERROR(cdev, "%s: can't bind, err %d\n", f->name, status);
diff --git a/drivers/usb/gadget/f_ncm.c b/drivers/usb/gadget/f_ncm.c
index aab8ede..d7811ae 100644
--- a/drivers/usb/gadget/f_ncm.c
+++ b/drivers/usb/gadget/f_ncm.c
@@ -1259,9 +1259,9 @@ fail:
 	/* we might as well release our claims on endpoints */
 	if (ncm->notify)
 		ncm->notify->driver_data = NULL;
-	if (ncm->port.out_ep->desc)
+	if (ncm->port.out_ep)
 		ncm->port.out_ep->driver_data = NULL;
-	if (ncm->port.in_ep->desc)
+	if (ncm->port.in_ep)
 		ncm->port.in_ep->driver_data = NULL;
 
 	ERROR(cdev, "%s: can't bind, err %d\n", f->name, status);
diff --git a/drivers/usb/gadget/f_rndis.c b/drivers/usb/gadget/f_rndis.c
index b1681e4..47953fe 100644
--- a/drivers/usb/gadget/f_rndis.c
+++ b/drivers/usb/gadget/f_rndis.c
@@ -803,9 +803,9 @@ fail:
 	/* we might as well release our claims on endpoints */
 	if (rndis->notify)
 		rndis->notify->driver_data = NULL;
-	if (rndis->port.out_ep->desc)
+	if (rndis->port.out_ep)
 		rndis->port.out_ep->driver_data = NULL;
-	if (rndis->port.in_ep->desc)
+	if (rndis->port.in_ep)
 		rndis->port.in_ep->driver_data = NULL;
 
 	ERROR(cdev, "%s: can't bind, err %d\n", f->name, status);
diff --git a/drivers/usb/gadget/f_subset.c b/drivers/usb/gadget/f_subset.c
index 21ab474..e5bb966 100644
--- a/drivers/usb/gadget/f_subset.c
+++ b/drivers/usb/gadget/f_subset.c
@@ -370,9 +370,9 @@ fail:
 		usb_free_descriptors(f->hs_descriptors);
 
 	/* we might as well release our claims on endpoints */
-	if (geth->port.out_ep->desc)
+	if (geth->port.out_ep)
 		geth->port.out_ep->driver_data = NULL;
-	if (geth->port.in_ep->desc)
+	if (geth->port.in_ep)
 		geth->port.in_ep->driver_data = NULL;
 
 	ERROR(cdev, "%s: can't bind, err %d\n", f->name, status);
-- 
1.7.9.5


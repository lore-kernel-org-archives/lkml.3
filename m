Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053AbbAMI4h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 03:56:37 -0500
Received: from mga11.intel.com ([192.55.52.93]:16794 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734AbbAMI4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 03:56:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,748,1413270000"; 
   d="scan'208";a="650296438"
Date: Tue, 13 Jan 2015 16:55:38 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Cc: kbuild-all@01.org, Felipe Balbi <balbi@ti.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH next] usb: gadget: uvc: to_uvcg_control_header() can be static
Message-ID: <20150113085538.GA9785@lkp-sb04>
References: <201501131627.qyQasDGL%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201501131627.qyQasDGL%fengguang.wu@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: fengguang.wu@intel.com
X-SA-Exim-Scanned: No (on bee); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/usb/gadget/function/uvc_configfs.c:46:28: sparse: symbol 'to_uvcg_control_header' was not declared. Should it be static?
drivers/usb/gadget/function/uvc_configfs.c:138:25: sparse: symbol 'uvcg_control_header_type' was not declared. Should it be static?
drivers/usb/gadget/function/uvc_configfs.c:164:6: sparse: symbol 'uvcg_control_header_drop' was not declared. Should it be static?
drivers/usb/gadget/function/uvc_configfs.c:721:20: sparse: symbol 'to_uvcg_format' was not declared. Should it be static?
drivers/usb/gadget/function/uvc_configfs.c:798:30: sparse: symbol 'to_uvcg_streaming_header' was not declared. Should it be static?
drivers/usb/gadget/function/uvc_configfs.c:950:25: sparse: symbol 'uvcg_streaming_header_type' was not declared. Should it be static?
drivers/usb/gadget/function/uvc_configfs.c:976:6: sparse: symbol 'uvcg_streaming_header_drop' was not declared. Should it be static?
drivers/usb/gadget/function/uvc_configfs.c:1020:19: sparse: symbol 'to_uvcg_frame' was not declared. Should it be static?
drivers/usb/gadget/function/uvc_configfs.c:1265:25: sparse: symbol 'uvcg_frame_type' was not declared. Should it be static?
drivers/usb/gadget/function/uvc_configfs.c:1315:6: sparse: symbol 'uvcg_frame_drop' was not declared. Should it be static?
drivers/usb/gadget/function/uvc_configfs.c:1338:26: sparse: symbol 'to_uvcg_uncompressed' was not declared. Should it be static?
drivers/usb/gadget/function/uvc_configfs.c:1548:25: sparse: symbol 'uvcg_uncompressed_type' was not declared. Should it be static?
drivers/usb/gadget/function/uvc_configfs.c:1586:6: sparse: symbol 'uvcg_uncompressed_drop' was not declared. Should it be static?
drivers/usb/gadget/function/uvc_configfs.c:1610:19: sparse: symbol 'to_uvcg_mjpeg' was not declared. Should it be static?
drivers/usb/gadget/function/uvc_configfs.c:1761:25: sparse: symbol 'uvcg_mjpeg_type' was not declared. Should it be static?
drivers/usb/gadget/function/uvc_configfs.c:1793:6: sparse: symbol 'uvcg_mjpeg_drop' was not declared. Should it be static?

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 uvc_configfs.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/usb/gadget/function/uvc_configfs.c b/drivers/usb/gadget/function/uvc_configfs.c
index 33d92ab..f69f47a 100644
--- a/drivers/usb/gadget/function/uvc_configfs.c
+++ b/drivers/usb/gadget/function/uvc_configfs.c
@@ -43,7 +43,7 @@ struct uvcg_control_header {
 	unsigned			linked;
 };
 
-struct uvcg_control_header *to_uvcg_control_header(struct config_item *item)
+static struct uvcg_control_header *to_uvcg_control_header(struct config_item *item)
 {
 	return container_of(item, struct uvcg_control_header, item);
 }
@@ -135,7 +135,7 @@ static struct configfs_attribute *uvcg_control_header_attrs[] = {
 	NULL,
 };
 
-struct config_item_type uvcg_control_header_type = {
+static struct config_item_type uvcg_control_header_type = {
 	.ct_item_ops	= &uvcg_control_header_item_ops,
 	.ct_attrs	= uvcg_control_header_attrs,
 	.ct_owner	= THIS_MODULE,
@@ -161,7 +161,7 @@ static struct config_item *uvcg_control_header_make(struct config_group *group,
 	return &h->item;
 }
 
-void uvcg_control_header_drop(struct config_group *group,
+static void uvcg_control_header_drop(struct config_group *group,
 			      struct config_item *item)
 {
 	struct uvcg_control_header *h = to_uvcg_control_header(item);
@@ -718,7 +718,7 @@ struct uvcg_format {
 	__u8			bmaControls[UVCG_STREAMING_CONTROL_SIZE];
 };
 
-struct uvcg_format *to_uvcg_format(struct config_item *item)
+static struct uvcg_format *to_uvcg_format(struct config_item *item)
 {
 	return container_of(to_config_group(item), struct uvcg_format, group);
 }
@@ -795,7 +795,7 @@ struct uvcg_streaming_header {
 	unsigned					num_fmt;
 };
 
-struct uvcg_streaming_header *to_uvcg_streaming_header(struct config_item *item)
+static struct uvcg_streaming_header *to_uvcg_streaming_header(struct config_item *item)
 {
 	return container_of(item, struct uvcg_streaming_header, item);
 }
@@ -947,7 +947,7 @@ static struct configfs_attribute *uvcg_streaming_header_attrs[] = {
 	NULL,
 };
 
-struct config_item_type uvcg_streaming_header_type = {
+static struct config_item_type uvcg_streaming_header_type = {
 	.ct_item_ops	= &uvcg_streaming_header_item_ops,
 	.ct_attrs	= uvcg_streaming_header_attrs,
 	.ct_owner	= THIS_MODULE,
@@ -973,7 +973,7 @@ static struct config_item
 	return &h->item;
 }
 
-void uvcg_streaming_header_drop(struct config_group *group,
+static void uvcg_streaming_header_drop(struct config_group *group,
 			      struct config_item *item)
 {
 	struct uvcg_streaming_header *h = to_uvcg_streaming_header(item);
@@ -1017,7 +1017,7 @@ struct uvcg_frame {
 	struct config_item	item;
 };
 
-struct uvcg_frame *to_uvcg_frame(struct config_item *item)
+static struct uvcg_frame *to_uvcg_frame(struct config_item *item)
 {
 	return container_of(item, struct uvcg_frame, item);
 }
@@ -1262,7 +1262,7 @@ static struct configfs_attribute *uvcg_frame_attrs[] = {
 	NULL,
 };
 
-struct config_item_type uvcg_frame_type = {
+static struct config_item_type uvcg_frame_type = {
 	.ct_item_ops	= &uvcg_frame_item_ops,
 	.ct_attrs	= uvcg_frame_attrs,
 	.ct_owner	= THIS_MODULE,
@@ -1312,7 +1312,7 @@ static struct config_item *uvcg_frame_make(struct config_group *group,
 	return &h->item;
 }
 
-void uvcg_frame_drop(struct config_group *group, struct config_item *item)
+static void uvcg_frame_drop(struct config_group *group, struct config_item *item)
 {
 	struct uvcg_frame *h = to_uvcg_frame(item);
 	struct uvcg_format *fmt;
@@ -1335,7 +1335,7 @@ struct uvcg_uncompressed {
 	struct uvc_format_uncompressed	desc;
 };
 
-struct uvcg_uncompressed *to_uvcg_uncompressed(struct config_item *item)
+static struct uvcg_uncompressed *to_uvcg_uncompressed(struct config_item *item)
 {
 	return container_of(
 		container_of(to_config_group(item), struct uvcg_format, group),
@@ -1545,7 +1545,7 @@ static struct configfs_attribute *uvcg_uncompressed_attrs[] = {
 	NULL,
 };
 
-struct config_item_type uvcg_uncompressed_type = {
+static struct config_item_type uvcg_uncompressed_type = {
 	.ct_item_ops	= &uvcg_uncompressed_item_ops,
 	.ct_group_ops	= &uvcg_uncompressed_group_ops,
 	.ct_attrs	= uvcg_uncompressed_attrs,
@@ -1583,7 +1583,7 @@ static struct config_group *uvcg_uncompressed_make(struct config_group *group,
 	return &h->fmt.group;
 }
 
-void uvcg_uncompressed_drop(struct config_group *group,
+static void uvcg_uncompressed_drop(struct config_group *group,
 			    struct config_item *item)
 {
 	struct uvcg_uncompressed *h = to_uvcg_uncompressed(item);
@@ -1607,7 +1607,7 @@ struct uvcg_mjpeg {
 	struct uvc_format_mjpeg		desc;
 };
 
-struct uvcg_mjpeg *to_uvcg_mjpeg(struct config_item *item)
+static struct uvcg_mjpeg *to_uvcg_mjpeg(struct config_item *item)
 {
 	return container_of(
 		container_of(to_config_group(item), struct uvcg_format, group),
@@ -1758,7 +1758,7 @@ static struct configfs_attribute *uvcg_mjpeg_attrs[] = {
 	NULL,
 };
 
-struct config_item_type uvcg_mjpeg_type = {
+static struct config_item_type uvcg_mjpeg_type = {
 	.ct_item_ops	= &uvcg_mjpeg_item_ops,
 	.ct_group_ops	= &uvcg_mjpeg_group_ops,
 	.ct_attrs	= uvcg_mjpeg_attrs,
@@ -1790,7 +1790,7 @@ static struct config_group *uvcg_mjpeg_make(struct config_group *group,
 	return &h->fmt.group;
 }
 
-void uvcg_mjpeg_drop(struct config_group *group,
+static void uvcg_mjpeg_drop(struct config_group *group,
 			    struct config_item *item)
 {
 	struct uvcg_mjpeg *h = to_uvcg_mjpeg(item);

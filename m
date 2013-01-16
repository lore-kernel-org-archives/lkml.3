Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600Ab3APP5u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 10:57:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35625 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756472Ab3APP5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 10:57:48 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Felipe Balbi <balbi@ti.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 006/222] usb: gadget: tcm_usb_gadget: NULL terminate the FS descriptor list
Date: Wed, 16 Jan 2013 13:53:26 -0200
Message-Id: <1358351822-7675-7-git-send-email-herton.krzesinski@canonical.com>
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

commit fad8deb274edcef1c8ca38946338f5f4f8126fe2 upstream.

The descriptor list for FS speed was not NULL terminated. This patch
fixes this.

While here one of the twe two bAlternateSetting assignments for the BOT
interface. Both assign 0, one is enough.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/gadget/tcm_usb_gadget.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/gadget/tcm_usb_gadget.c b/drivers/usb/gadget/tcm_usb_gadget.c
index cdfbac7..514366b 100644
--- a/drivers/usb/gadget/tcm_usb_gadget.c
+++ b/drivers/usb/gadget/tcm_usb_gadget.c
@@ -2161,6 +2161,7 @@ static struct usb_descriptor_header *uasp_fs_function_desc[] = {
 	(struct usb_descriptor_header *) &uasp_status_pipe_desc,
 	(struct usb_descriptor_header *) &uasp_fs_cmd_desc,
 	(struct usb_descriptor_header *) &uasp_cmd_pipe_desc,
+	NULL,
 };
 
 static struct usb_descriptor_header *uasp_hs_function_desc[] = {
-- 
1.7.9.5


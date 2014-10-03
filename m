Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444AbaJCVh2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 17:37:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45128 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755316AbaJCVfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:35:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michal Nazarewicz <mina86@mina86.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 3.16 108/357] usb: gadget: f_rndis: fix interface id for OS descriptors
Date: Fri,  3 Oct 2014 14:28:14 -0700
Message-Id: <20141003212936.719315592@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>

commit 4546527350c3c508554dff53e9086e9d3de0b97b upstream.

f->os_desc_table[0].if_id is zero by default. If the actual id happens
to be different then no Feature Descriptors will be returned to the host
for this interface, so assign if_id as soon as it is known.

Acked-by: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/usb/gadget/f_rndis.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/gadget/f_rndis.c
+++ b/drivers/usb/gadget/f_rndis.c
@@ -727,6 +727,10 @@ rndis_bind(struct usb_configuration *c,
 	rndis_control_intf.bInterfaceNumber = status;
 	rndis_union_desc.bMasterInterface0 = status;
 
+	if (cdev->use_os_string)
+		f->os_desc_table[0].if_id =
+			rndis_iad_descriptor.bFirstInterface;
+
 	status = usb_interface_id(c, f);
 	if (status < 0)
 		goto fail;



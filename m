Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299AbaGUFRN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 01:17:13 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:53847 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750817AbaGUFRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 01:17:12 -0400
From: Amit Virdi <amit.virdi@st.com>
To: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Cc: <gregkh@linuxfoundation.org>, <stern@rowland.harvard.edu>,
        <rdunlap@infradead.org>, <ming.lei@canonical.com>,
        <hdegoede@redhat.com>, <spear-devel@list.st.com>,
        Amit Virdi <amit.virdi@st.com>
Subject: [PATCH V2] usb: core: allow zero packet flag for interrupt urbs
Date: Mon, 21 Jul 2014 10:46:18 +0530
Message-ID: <c6287280f42a976eed5c3fe46901f40e3f5db816.1405919768.git.amit.virdi@st.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <53CCA019.7030007@st.com>
References: <53CCA019.7030007@st.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-07-20_03:2014-07-18,2014-07-20,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Section 4.4.7.2 "Interrupt Transfer Bandwidth Requirements" of the USB3.0 spec
says:
	A zero-length data payload is a valid transfer and may be useful for
	some implementations.

So, extend the logic of allowing URB_ZERO_PACKET to interrupt urbs too.
Otherwise, the kernel throws warning of BOGUS transfer flags.

Signed-off-by: Amit Virdi <amit.virdi@st.com>
Acked-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/usb/core/urb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/core/urb.c b/drivers/usb/core/urb.c
index 991386ceb4ec..c9e8ee81b6b7 100644
--- a/drivers/usb/core/urb.c
+++ b/drivers/usb/core/urb.c
@@ -454,6 +454,7 @@ int usb_submit_urb(struct urb *urb, gfp_t mem_flags)
 			URB_FREE_BUFFER);
 	switch (xfertype) {
 	case USB_ENDPOINT_XFER_BULK:
+	case USB_ENDPOINT_XFER_INT:
 		if (is_out)
 			allowed |= URB_ZERO_PACKET;
 		/* FALLTHROUGH */
-- 
1.8.0


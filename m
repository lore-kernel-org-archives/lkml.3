Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743AbaJMCa0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 22:30:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46160 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690AbaJMCaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 22:30:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 3.17 16/25] uas: Add another ASM1051 usb-id to the uas blacklist
Date: Mon, 13 Oct 2014 04:25:09 +0200
Message-Id: <20141013022454.985859333@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141013022454.289398272@linuxfoundation.org>
References: <20141013022454.289398272@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 710f1bf16ab1b1558f099b62c5011c4cbba6a7bb upstream.

As most ASM1051 based devices, this one has unfixable issues with uas too.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/storage/unusual_uas.h |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -67,3 +67,11 @@ UNUSUAL_DEV(0x152d, 0x0567, 0x0000, 0x99
 		"JMS567",
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_NO_REPORT_OPCODES),
+
+/* Most ASM1051 based devices have issues with uas, blacklist them all */
+/* Reported-by: Hans de Goede <hdegoede@redhat.com> */
+UNUSUAL_DEV(0x174c, 0x5106, 0x0000, 0x9999,
+		"ASMedia",
+		"ASM1051",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_IGNORE_UAS),



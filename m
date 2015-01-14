Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206AbbANH2P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:28:15 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57948 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461AbbANH2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:28:11 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Simon Schubert <2+kernel@0x2c.org>
Subject: [PATCH 3.18 084/150] USB: cdc-acm: check for valid interfaces
Date: Tue, 13 Jan 2015 23:22:35 -0800
Message-Id: <20150114072059.661820133@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072055.842408181@linuxfoundation.org>
References: <20150114072055.842408181@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 403dff4e2c94f275e24fd85f40b2732ffec268a1 upstream.

We need to check that we have both a valid data and control inteface for both
types of headers (union and not union.)

References: https://bugzilla.kernel.org/show_bug.cgi?id=83551
Reported-by: Simon Schubert <2+kernel@0x2c.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/class/cdc-acm.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1197,10 +1197,11 @@ next_desc:
 	} else {
 		control_interface = usb_ifnum_to_if(usb_dev, union_header->bMasterInterface0);
 		data_interface = usb_ifnum_to_if(usb_dev, (data_interface_num = union_header->bSlaveInterface0));
-		if (!control_interface || !data_interface) {
-			dev_dbg(&intf->dev, "no interfaces\n");
-			return -ENODEV;
-		}
+	}
+
+	if (!control_interface || !data_interface) {
+		dev_dbg(&intf->dev, "no interfaces\n");
+		return -ENODEV;
 	}
 
 	if (data_interface_num != call_interface_num)



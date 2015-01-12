Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774AbbALS0f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:26:35 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57518 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411AbbALSF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:05:59 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 050/216] USB: cdc-acm: check for valid interfaces
Date: Mon, 12 Jan 2015 18:02:47 +0000
Message-Id: <1421085933-32536-51-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 403dff4e2c94f275e24fd85f40b2732ffec268a1 upstream.

We need to check that we have both a valid data and control inteface for both
types of headers (union and not union.)

References: https://bugzilla.kernel.org/show_bug.cgi?id=83551
Reported-by: Simon Schubert <2+kernel@0x2c.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/class/cdc-acm.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 48e7a7e60937..4d4f6db94c72 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1192,10 +1192,11 @@ next_desc:
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
-- 
2.1.4


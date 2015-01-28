Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764226AbbA2DYg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 22:24:36 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46933 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932921AbbA2Cfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:35:34 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 049/139] USB: cdc-acm: check for valid interfaces
Date: Wed, 28 Jan 2015 14:19:52 -0800
Message-Id: <1422483682-15393-50-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 403dff4e2c94f275e24fd85f40b2732ffec268a1 upstream.

We need to check that we have both a valid data and control inteface for both
types of headers (union and not union.)

References: https://bugzilla.kernel.org/show_bug.cgi?id=83551
Reported-by: Simon Schubert <2+kernel@0x2c.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/class/cdc-acm.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 8a236bf..6746103 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1049,10 +1049,11 @@ next_desc:
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
1.9.1


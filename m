Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758233AbbA2JCa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:02:30 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44768 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758070AbbA2JCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:02:19 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 032/176] USB: cdc-acm: check for valid interfaces
Date: Wed, 28 Jan 2015 15:27:42 +0100
Message-Id: <7f05446ddd65a1ab8b1d3a8dbc5acddbe0c66745.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 403dff4e2c94f275e24fd85f40b2732ffec268a1 upstream.

We need to check that we have both a valid data and control inteface for both
types of headers (union and not union.)

References: https://bugzilla.kernel.org/show_bug.cgi?id=83551
Reported-by: Simon Schubert <2+kernel@0x2c.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/class/cdc-acm.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 99fd026161d5..f578a5aa02c0 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1079,10 +1079,11 @@ next_desc:
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
2.2.2


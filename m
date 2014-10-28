Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763AbaJ1Dgq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 23:36:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44326 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733AbaJ1Dgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:36:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ping Cheng <pingc@wacom.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 3.17 026/146] HID: wacom - remove report_id from wacom_get_report interface
Date: Tue, 28 Oct 2014 11:32:48 +0800
Message-Id: <20141028033344.570203859@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033343.441992423@linuxfoundation.org>
References: <20141028033343.441992423@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ping Cheng <pinglinux@gmail.com>

commit c64d883476812783e0400d37028756151d103e5c upstream.

It is assigned in buf[0] anyway.

Signed-off-by: Ping Cheng <pingc@wacom.com>
Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/wacom_sys.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/hid/wacom_sys.c
+++ b/drivers/hid/wacom_sys.c
@@ -23,13 +23,13 @@
 #define WAC_CMD_ICON_BT_XFER	0x26
 #define WAC_CMD_RETRIES		10
 
-static int wacom_get_report(struct hid_device *hdev, u8 type, u8 id,
-			    void *buf, size_t size, unsigned int retries)
+static int wacom_get_report(struct hid_device *hdev, u8 type, u8 *buf,
+			    size_t size, unsigned int retries)
 {
 	int retval;
 
 	do {
-		retval = hid_hw_raw_request(hdev, id, buf, size, type,
+		retval = hid_hw_raw_request(hdev, buf[0], buf, size, type,
 				HID_REQ_GET_REPORT);
 	} while ((retval == -ETIMEDOUT || retval == -EPIPE) && --retries);
 
@@ -255,7 +255,7 @@ static int wacom_set_device_mode(struct
 					 length, 1);
 		if (error >= 0)
 			error = wacom_get_report(hdev, HID_FEATURE_REPORT,
-			                         report_id, rep_data, length, 1);
+			                         rep_data, length, 1);
 	} while ((error < 0 || rep_data[1] != mode) && limit++ < WAC_MSG_RETRIES);
 
 	kfree(rep_data);



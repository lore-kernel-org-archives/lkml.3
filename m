Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143Ab3LRVXq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:23:46 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36571 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754470Ab3LRVOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:14:05 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>, Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 3.12 096/118] HID: kye: Fix missing break in kye_report_fixup()
Date: Wed, 18 Dec 2013 13:12:13 -0800
Message-Id: <20131218211222.169733670@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211219.461663463@linuxfoundation.org>
References: <20131218211219.461663463@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit 0a5f99cfff2297f6c350b7f54878cbbf1b1253d5 upstream.

The change to support Genius Manticore Keyboard also changed behaviour
for Genius Gx Imperator Keyboard, as there is no break between the
cases.  This is presumably a mistake.

Reported by Coverity as CID 1134029.

Fixes: 4a2c94c9b6c0 ('HID: kye: Add report fixup for Genius Manticore Keyboard')
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-kye.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/hid/hid-kye.c
+++ b/drivers/hid/hid-kye.c
@@ -341,6 +341,7 @@ static __u8 *kye_report_fixup(struct hid
 	case USB_DEVICE_ID_GENIUS_GX_IMPERATOR:
 		rdesc = kye_consumer_control_fixup(hdev, rdesc, rsize, 83,
 					"Genius Gx Imperator Keyboard");
+		break;
 	case USB_DEVICE_ID_GENIUS_MANTICORE:
 		rdesc = kye_consumer_control_fixup(hdev, rdesc, rsize, 104,
 					"Genius Manticore Keyboard");



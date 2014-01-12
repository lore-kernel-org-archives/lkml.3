Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751066AbaALCxB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 21:53:01 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:41571
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940AbaALCw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 21:52:58 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, dmitry.torokhov@gmail.com,
        linux-input@vger.kernel.org, vojtech@suse.cz, olaf@aepfle.de,
        apw@canonical.com, jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/1] Drivers: input: serio:hyperv-keyoard:  Handle 0xE1 prefix
Date: Sat, 11 Jan 2014 19:41:50 -0800
Message-Id: <1389498110-4790-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handle the 0xE1 prefix.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/input/serio/hyperv-keyboard.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/input/serio/hyperv-keyboard.c b/drivers/input/serio/hyperv-keyboard.c
index 3a83c3c..6132619 100644
--- a/drivers/input/serio/hyperv-keyboard.c
+++ b/drivers/input/serio/hyperv-keyboard.c
@@ -160,7 +160,9 @@ static void hv_kbd_on_receive(struct hv_device *hv_dev,
 			if (info & IS_E0)
 				serio_interrupt(kbd_dev->hv_serio,
 						XTKBD_EMUL0, 0);
-
+			if (info & IS_E1)
+				serio_interrupt(kbd_dev->hv_serio,
+						XTKBD_EMUL1, 0);
 			scan_code = __le16_to_cpu(ks_msg->make_code);
 			if (info & IS_BREAK)
 				scan_code |= XTKBD_RELEASE;
-- 
1.7.4.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027AbaAMO0V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 09:26:21 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51190 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbaAMOZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 09:25:18 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Marek Vasut <marex@denx.de>, Chen Peter <B29397@freescale.com>,
        Greg KH <greg@kroah.com>, Jiri Kosina <jkosina@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 08/96] HID: Bump maximum global item tag report size to 128 bytes
Date: Mon, 13 Jan 2014 14:23:31 +0000
Message-Id: <1389623099-18783-9-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
References: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.29 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marex@denx.de>

commit 23408f95fa92483527de3206ebeb55c37e0f679c upstream.

The Freescale i.MX28 BootROM USB recovery mode implements the USB HID
protocol, yet the global item tag report size is 128. Linux checks if
this is 96 as of now, see [1]. This causes Linux to refuse to communicate
with this device, making it impossible to use the recovery mode.

This is not a standard HID device per se, but rather a software emulation
implemented within the BootROM code and realized through USB OTG-capable
port switched to device mode present on the device.

Previous attempt to discuss this issue dates back to 2011, see [2]. There
has been not much response. Also noteworthy is the [3], where there seems
to be a pointing device that has issue similar to this one.

The tool making use of the USB recovery mode is available at [4].

[1] http://comments.gmane.org/gmane.linux.kernel.input/22328
[2] http://www.spinics.net/lists/linux-usb/msg43463.html
[3] https://bbs.archlinux.org/viewtopic.php?pid=1141340
[4] http://git.bfuser.eu/?p=marex/mxsldr.git;a=summary

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Chen Peter <B29397@freescale.com>
Cc: Greg KH <greg@kroah.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hid/hid-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 509d119..abc1fcd 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -382,7 +382,7 @@ static int hid_parser_global(struct hid_parser *parser, struct hid_item *item)
 
 	case HID_GLOBAL_ITEM_TAG_REPORT_SIZE:
 		parser->global.report_size = item_udata(item);
-		if (parser->global.report_size > 96) {
+		if (parser->global.report_size > 128) {
 			hid_err(parser->device, "invalid report_size %d\n",
 					parser->global.report_size);
 			return -1;
-- 
1.8.3.2


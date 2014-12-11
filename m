Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934486AbaLKKC1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 05:02:27 -0500
Received: from lekensteyn.nl ([178.21.112.251]:51055 "EHLO lekensteyn.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932698AbaLKKCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 05:02:25 -0500
From: Peter Wu <peter@lekensteyn.nl>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew de los Reyes <adlr@chromium.org>, Jiri Kosina <jkosina@suse.cz>
Subject: About "HID: logitech-hidpp: add support of the first Logitech Wireless Touchpad"
Date: Thu, 11 Dec 2014 11:02:20 +0100
Message-ID: <1659058.m7A8Z3l7lH@al>
User-Agent: KMail/4.14.3 (Linux/3.17.0-rc4-custom-00168-g7ec62d4; KDE/4.14.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Score: -0.0 (/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

In commit 57ac86cf52e903d9e3e0f12b34c814cce6b65550 ("HID:
logitech-hidpp: add support of the first Logitech Wireless Touchpad")
which is in jikos/hid, you made this change to wtp_raw_event:

        switch (data[0]) {
        case 0x02:
-               if (size < 21)
-                       return 1;
-               return wtp_mouse_raw_xy_event(hidpp, &data[7]);
+               if (hidpp->quirks & HIDPP_QUIRK_WTP_PHYSICAL_BUTTONS) {
+                       input_event(wd->input, EV_KEY, BTN_LEFT,
+                                       !!(data[1] & 0x01));
+                       input_event(wd->input, EV_KEY, BTN_RIGHT,
+                                       !!(data[1] & 0x02));
+                       input_sync(wd->input);
+               } else {
+                       if (size < 21)
+                               return 1;
+                       return wtp_mouse_raw_xy_event(hidpp, &data[7]);
+               }
        case REPORT_ID_HIDPP_LONG:
                if ((report->fap.feature_index != wd->mt_feature_index) ||
                    (report->fap.funcindex_clientid != EVENT_TOUCHPAD_RAW_XY))
                        return 1;
                hidpp_touchpad_raw_xy_event(hidpp, data + 4, &raw);
 
                wtp_send_raw_xy_event(hidpp, &raw);
                return 0;
        }

Report ID 2 is the mouse descriptor, so it seems correct in that it
falls-through to the next case, but I wanted to check with you that this
is indeed your intention. If so, could you explicitly mark it with a
comment, /* fallthrough */ ?
-- 
Kind regards,
Peter
https://lekensteyn.nl


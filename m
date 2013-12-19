Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498Ab3LSQFT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 11:05:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62586 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754532Ab3LSQFQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 11:05:16 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, David Herrmann <dh.herrmann@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] HID: input: fix input sysfs path for hid devices
Date: Thu, 19 Dec 2013 11:05:13 -0500
Message-Id: <1387469113-4129-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

we used to set the parent of the input device as the parent of
the hid bus. This was introduced when we created hid as a real bus, and
to keep backward compatibility. Now, it's time to proper set the parent
so that sysfs has an idea of which input device is attached to
which hid device.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---

Hi Jiri,

well, the regression test did not showed anything bad, and a look at the hid
drivers also showed that no drivers should be armed by that.

I think this is valuable because it will give a better understanding of the
actual mapping hardware/inputs. Like a touchscreen with pen + touch will have
the same hid parent, and I expect X/Wayland to be able to detect this at some
point to keep the mapping correctly between the two input devices and the screen.

I also need that for hid-replay, so that I can be sure which input is attached
to which uhid device, and give up the heuristics I currently use.

Cheers,
Benjamin

 drivers/hid/hid-input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index d97f232..d50e731 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -1279,7 +1279,7 @@ static struct hid_input *hidinput_allocate(struct hid_device *hid)
 	input_dev->id.vendor  = hid->vendor;
 	input_dev->id.product = hid->product;
 	input_dev->id.version = hid->version;
-	input_dev->dev.parent = hid->dev.parent;
+	input_dev->dev.parent = &hid->dev;
 	hidinput->input = input_dev;
 	list_add_tail(&hidinput->list, &hid->inputs);
 
-- 
1.8.3.1


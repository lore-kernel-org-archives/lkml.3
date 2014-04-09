Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933574AbaDIPBm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 11:01:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21684 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933291AbaDIPBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 11:01:40 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Andrew Duggan <aduggan@synaptics.com>,
        Christopher Heiny <cheiny@synaptics.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] HID: rmi: do not stop the device at the end of probe
Date: Wed,  9 Apr 2014 11:01:34 -0400
Message-Id: <1397055694-6312-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, this is embarrassing, if the device is stopped at the end of probe,
we get into big troubles (it even oopses my kernel).

This was a leftover of an attempt to be smart when sending the patch,
I deeply apologies.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---

Hi Jiri,

well, first thanks for having integrating hid-rmi in your for 3.16 branch.

While backporting it to 3.13 so Fedora can get it, I noticed a tiny difference
(besides formatting) between the version I submitted and the one I asked people
to test...

...facepalm.

Cheers,
Benjamin

 drivers/hid/hid-rmi.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/hid/hid-rmi.c b/drivers/hid/hid-rmi.c
index 699d631..7da9509 100644
--- a/drivers/hid/hid-rmi.c
+++ b/drivers/hid/hid-rmi.c
@@ -848,7 +848,6 @@ static int rmi_probe(struct hid_device *hdev, const struct hid_device_id *id)
 		return -EIO;
 	}
 
-	hid_hw_stop(hdev);
 	return 0;
 }
 
-- 
1.9.0


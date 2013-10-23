Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110Ab3JWTPd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 15:15:33 -0400
Received: from smtprelay0117.hostedemail.com ([216.40.44.117]:48683 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752723Ab3JWTPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 15:15:31 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:966:973:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:1981:2194:2196:2199:2200:2393:2559:2562:3138:3139:3140:3141:3142:3352:3866:3867:3868:4250:4321:4385:4605:5007:6261:7974:10004:10026:10848:11026:11658:11914:12043:12114:12296:12438:12517:12519:12555:13095:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: value95_69ee8f179bc4e
X-Filterd-Recvd-Size: 2082
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Bruno=20Pr=C3=A9mont?= <bonbons@linux-vserver.org>,
        linux-input@vger.kernel.org
Subject: [PATCH 3/8] hid: Remove OOM message after input_allocate_device
Date: Wed, 23 Oct 2013 12:14:49 -0700
Message-Id: <890e072c3487378bf1203acf65cc0e204dea89bb.1382555436.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1382555436.git.joe@perches.com>
References: <cover.1382555436.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Emitting an OOM message isn't necessary after input_allocate_device
as there's a generic OOM and a dump_stack already done.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/hid/hid-input.c        | 1 -
 drivers/hid/hid-picolcd_core.c | 5 ++---
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 8741d95..aed8238 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -1263,7 +1263,6 @@ static struct hid_input *hidinput_allocate(struct hid_device *hid)
 	if (!hidinput || !input_dev) {
 		kfree(hidinput);
 		input_free_device(input_dev);
-		hid_err(hid, "Out of memory during hid input probe\n");
 		return NULL;
 	}
 
diff --git a/drivers/hid/hid-picolcd_core.c b/drivers/hid/hid-picolcd_core.c
index acbb0210..f34ba0f 100644
--- a/drivers/hid/hid-picolcd_core.c
+++ b/drivers/hid/hid-picolcd_core.c
@@ -431,10 +431,9 @@ static int picolcd_init_keys(struct picolcd_data *data,
 	}
 
 	idev = input_allocate_device();
-	if (idev == NULL) {
-		hid_err(hdev, "failed to allocate input device\n");
+	if (idev == NULL)
 		return -ENOMEM;
-	}
+
 	input_set_drvdata(idev, hdev);
 	memcpy(data->keycode, def_keymap, sizeof(def_keymap));
 	idev->name = hdev->name;
-- 
1.8.1.2.459.gbcd45b4.dirty


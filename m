Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461Ab3JWTQY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 15:16:24 -0400
Received: from smtprelay0251.hostedemail.com ([216.40.44.251]:51442 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753296Ab3JWTQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 15:16:09 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1540:1711:1714:1730:1747:1777:1792:1981:2194:2199:2393:2559:2562:3138:3139:3140:3141:3142:3350:3867:3868:4250:5007:6261:10004:10026:10848:11026:11658:11914:12114:12296:12438:12517:12519:12555:13095:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: shirt86_6f6c7bd8f8106
X-Filterd-Recvd-Size: 1569
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org
Subject: [PATCH 8/8] sound: Remove OOM message after input_allocate_device
Date: Wed, 23 Oct 2013 12:14:54 -0700
Message-Id: <67fa483a408bf2abe0e2fad829f3c496130ae507.1382555436.git.joe@perches.com>
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
 sound/pci/hda/hda_beep.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/pci/hda/hda_beep.c b/sound/pci/hda/hda_beep.c
index 63c9909..20d065a 100644
--- a/sound/pci/hda/hda_beep.c
+++ b/sound/pci/hda/hda_beep.c
@@ -151,10 +151,8 @@ static int snd_hda_do_attach(struct hda_beep *beep)
 	int err;
 
 	input_dev = input_allocate_device();
-	if (!input_dev) {
-		printk(KERN_INFO "hda_beep: unable to allocate input device\n");
+	if (!input_dev)
 		return -ENOMEM;
-	}
 
 	/* setup digital beep device */
 	input_dev->name = "HDA Digital PCBeep";
-- 
1.8.1.2.459.gbcd45b4.dirty


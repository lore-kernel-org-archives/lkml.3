Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932294AbaE1PN3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 11:13:29 -0400
Received: from isis.lip6.fr ([132.227.60.2]:50506 "EHLO isis.lip6.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932227AbaE1PNX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 11:13:23 -0400
X-pt: isis.lip6.fr
From: Benoit Taine <benoit.taine@lip6.fr>
To: Jaroslav Kysela <perex@perex.cz>
Cc: benoit.taine@lip6.fr, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 1/2] ALSA: au1x00: Use resource_size instead of computation
Date: Wed, 28 May 2014 17:14:06 +0200
Message-Id: <1401290047-30005-2-git-send-email-benoit.taine@lip6.fr>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1401290047-30005-1-git-send-email-benoit.taine@lip6.fr>
References: <1401290047-30005-1-git-send-email-benoit.taine@lip6.fr>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.4.3 (isis.lip6.fr [132.227.60.2]); Wed, 28 May 2014 17:13:12 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This issue was reported by coccicheck using the semantic patch 
at scripts/coccinelle/api/resource_size.cocci

Signed-off-by: Benoit Taine <benoit.taine@lip6.fr>
---
Not compile tested, due incompatible architecture.

 sound/mips/au1x00.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/mips/au1x00.c b/sound/mips/au1x00.c
index d10ef76..fbcaa54 100644
--- a/sound/mips/au1x00.c
+++ b/sound/mips/au1x00.c
@@ -648,14 +648,14 @@ static int au1000_ac97_probe(struct platform_device *pdev)
 		goto out;
 
 	err = -EBUSY;
-	au1000->ac97_res_port = request_mem_region(r->start,
-					r->end - r->start + 1, pdev->name);
+	au1000->ac97_res_port = request_mem_region(r->start, resource_size(r),
+						   pdev->name);
 	if (!au1000->ac97_res_port) {
 		snd_printk(KERN_ERR "ALSA AC97: can't grab AC97 port\n");
 		goto out;
 	}
 
-	io = ioremap(r->start, r->end - r->start + 1);
+	io = ioremap(r->start, resource_size(r));
 	if (!io)
 		goto out;
 


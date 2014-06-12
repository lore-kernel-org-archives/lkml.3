Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750948AbaFLWCP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 18:02:15 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:35899 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbaFLWCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 18:02:14 -0400
Date: Fri, 13 Jun 2014 03:32:07 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] ALSA: au1x00: Use resource_size
Message-ID: <20140612220206.GA10257@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the function resource_size, which reduces the chance of introducing
off-by-one errors in calculating the resource size.

The semantic patch that makes this change is as follows:

// <smpl>
@@
struct resource *res;
@@

- (res->end - res->start) + 1
+ resource_size(res)
// </smpl>

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
Not compile tested.
 sound/mips/au1x00.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/mips/au1x00.c b/sound/mips/au1x00.c
index d10ef76..86583c7 100644
--- a/sound/mips/au1x00.c
+++ b/sound/mips/au1x00.c
@@ -649,7 +649,7 @@ static int au1000_ac97_probe(struct platform_device *pdev)
 
 	err = -EBUSY;
 	au1000->ac97_res_port = request_mem_region(r->start,
-					r->end - r->start + 1, pdev->name);
+					resource_size(r), pdev->name);
 	if (!au1000->ac97_res_port) {
 		snd_printk(KERN_ERR "ALSA AC97: can't grab AC97 port\n");
 		goto out;
-- 
1.9.1


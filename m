Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933754AbaGWVTI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 17:19:08 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:54664 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933170AbaGWVTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 17:19:04 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Wang YanQing <udknight@gmail.com>, Jingoo Han <jg1.han@samsung.com>,
        David Fries <David@Fries.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] video: fbdev: uvesafb.c:  Added additional error checking
Date: Wed, 23 Jul 2014 23:20:27 +0200
Message-Id: <1406150427-26077-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Variable was assigned a value that is never used.
Now the variable is used, and the function returns if a call to
uvesafb_exec() returns a error.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/video/fbdev/uvesafb.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/video/fbdev/uvesafb.c b/drivers/video/fbdev/uvesafb.c
index 509d452..47c2d74 100644
--- a/drivers/video/fbdev/uvesafb.c
+++ b/drivers/video/fbdev/uvesafb.c
@@ -561,6 +561,8 @@ static int uvesafb_vbe_getpmi(struct uvesafb_ktask *task,
 	task->t.regs.eax = 0x4f0a;
 	task->t.regs.ebx = 0x0;
 	err = uvesafb_exec(task);
+	if (err)
+		return err;
 
 	if ((task->t.regs.eax & 0xffff) != 0x4f || task->t.regs.es < 0xc000) {
 		par->pmi_setpal = par->ypan = 0;
-- 
1.7.10.4


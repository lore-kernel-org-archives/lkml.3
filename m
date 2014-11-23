Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751500AbaKWMyb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 07:54:31 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:14354 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751211AbaKWMxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 07:53:35 -0500
X-IronPort-AV: E=Sophos;i="5.07,443,1413237600"; 
   d="scan'208";a="109082631"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Jaroslav Kysela <perex@perex.cz>
Cc: kernel-janitors@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/10] sound/atmel/abdac.c: fix error return code
Date: Sun, 23 Nov 2014 13:48:08 +0100
Message-Id: <1416746890-22719-8-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1416746890-22719-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1416746890-22719-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Initialize retval before returning from a failed call to ioremap.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
(
if@p1 (\(ret < 0\|ret != 0\))
 { ... return ret; }
|
ret@p1 = 0
)
... when != ret = e1
    when != &ret
*if(...)
{
  ... when != ret = e2
      when forall
 return ret;
}

// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 sound/atmel/abdac.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/atmel/abdac.c b/sound/atmel/abdac.c
index 98554f4..277ebce 100644
--- a/sound/atmel/abdac.c
+++ b/sound/atmel/abdac.c
@@ -452,6 +452,7 @@ static int __devinit atmel_abdac_probe(struct platform_device *pdev)
 	dac->regs = ioremap(regs->start, resource_size(regs));
 	if (!dac->regs) {
 		dev_dbg(&pdev->dev, "could not remap register memory\n");
+		retval = -ENOMEM;
 		goto out_free_card;
 	}
 


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751457AbaKWMya (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 07:54:30 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:56950 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751218AbaKWMxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 07:53:35 -0500
X-IronPort-AV: E=Sophos;i="5.07,443,1413237600"; 
   d="scan'208";a="109082632"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Geoff Levand <geoff@infradead.org>
Cc: kernel-janitors@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, linuxppc-dev@lists.ozlabs.org,
        cbe-oss-dev@lists.ozlabs.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 9/9] sound/ppc/snd_ps3.c: fix error return code
Date: Sun, 23 Nov 2014 13:48:09 +0100
Message-Id: <1416746890-22719-9-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1416746890-22719-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1416746890-22719-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Initialize ret before returning on failure, as done elsewhere in the
function.

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
 sound/ppc/snd_ps3.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/ppc/snd_ps3.c b/sound/ppc/snd_ps3.c
index 1aa52ef..9b18b52 100644
--- a/sound/ppc/snd_ps3.c
+++ b/sound/ppc/snd_ps3.c
@@ -1040,6 +1040,7 @@ static int __devinit snd_ps3_driver_probe(struct ps3_system_bus_device *dev)
 				   GFP_KERNEL);
 	if (!the_card.null_buffer_start_vaddr) {
 		pr_info("%s: nullbuffer alloc failed\n", __func__);
+		ret = -ENOMEM;
 		goto clean_preallocate;
 	}
 	pr_debug("%s: null vaddr=%p dma=%#llx\n", __func__,


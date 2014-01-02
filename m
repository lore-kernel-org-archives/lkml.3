Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056AbaABWo3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 17:44:29 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:3535 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752822AbaABWo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 17:44:27 -0500
X-IronPort-AV: E=Sophos;i="4.95,593,1384297200"; 
   d="scan'208";a="51446861"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Jaya Kumar <jayakumar.alsa@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] ALSA: cs5535audio: use named constants for pci_power_t values
Date: Fri,  3 Jan 2014 00:40:30 +0100
Message-Id: <1388706031-22180-3-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1388706031-22180-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1388706031-22180-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression pdev;
@@

pci_set_power_state(pdev,
- 3
+ PCI_D3hot
 )
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 sound/pci/cs5535audio/cs5535audio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/cs5535audio/cs5535audio.c b/sound/pci/cs5535audio/cs5535audio.c
index 902bebd..c0d2835 100644
--- a/sound/pci/cs5535audio/cs5535audio.c
+++ b/sound/pci/cs5535audio/cs5535audio.c
@@ -253,7 +253,7 @@ static irqreturn_t snd_cs5535audio_interrupt(int irq, void *dev_id)
 static int snd_cs5535audio_free(struct cs5535audio *cs5535au)
 {
 	synchronize_irq(cs5535au->irq);
-	pci_set_power_state(cs5535au->pci, 3);
+	pci_set_power_state(cs5535au->pci, PCI_D3hot);
 
 	if (cs5535au->irq >= 0)
 		free_irq(cs5535au->irq, cs5535au);


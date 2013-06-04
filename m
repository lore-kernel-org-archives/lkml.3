Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866Ab3FDXRz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 19:17:55 -0400
Received: from 1wt.eu ([62.212.114.60]:35346 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803Ab3FDWl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:41:58 -0400
Message-Id: <20130604172132.135940874@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:22:14 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Sean Connor <sconnor004@allyinics.org>, Takashi Iwai <tiwai@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 044/184] ALSA: ice1712: Initialize card->private_data
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 properly

From: Sean Connor <sconnor004@allyinics.org>

commit 69a4cfdd444d1fe5c24d29b3a063964ac165d2cd upstream.

Set card->private_data in snd_ice1712_create for fixing NULL
dereference in snd_ice1712_remove().

Signed-off-by: Sean Connor <sconnor004@allyinics.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 sound/pci/ice1712/ice1712.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/pci/ice1712/ice1712.c b/sound/pci/ice1712/ice1712.c
index d74033a..95496ae 100644
--- a/sound/pci/ice1712/ice1712.c
+++ b/sound/pci/ice1712/ice1712.c
@@ -2574,6 +2574,8 @@ static int __devinit snd_ice1712_create(struct snd_card *card,
 	snd_ice1712_proc_init(ice);
 	synchronize_irq(pci->irq);
 
+	card->private_data = ice;
+
 	err = pci_request_regions(pci, "ICE1712");
 	if (err < 0) {
 		kfree(ice);
-- 
1.7.12.2.21.g234cd45.dirty




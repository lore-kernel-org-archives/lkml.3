Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337Ab3CNKiK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:38:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52044 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757156Ab3CNKiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:38:06 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sean Connor <sconnor004@allyinics.org>, Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 69/88] ALSA: ice1712: Initialize card->private_data properly
Date: Thu, 14 Mar 2013 10:36:02 +0000
Message-Id: <1363257381-15900-70-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
References: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Connor <sconnor004@allyinics.org>

commit 69a4cfdd444d1fe5c24d29b3a063964ac165d2cd upstream.

Set card->private_data in snd_ice1712_create for fixing NULL
dereference in snd_ice1712_remove().

Signed-off-by: Sean Connor <sconnor004@allyinics.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/pci/ice1712/ice1712.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/pci/ice1712/ice1712.c b/sound/pci/ice1712/ice1712.c
index 5be2e12..f8189e8 100644
--- a/sound/pci/ice1712/ice1712.c
+++ b/sound/pci/ice1712/ice1712.c
@@ -2595,6 +2595,8 @@ static int __devinit snd_ice1712_create(struct snd_card *card,
 	snd_ice1712_proc_init(ice);
 	synchronize_irq(pci->irq);
 
+	card->private_data = ice;
+
 	err = pci_request_regions(pci, "ICE1712");
 	if (err < 0) {
 		kfree(ice);
-- 
1.8.1.2


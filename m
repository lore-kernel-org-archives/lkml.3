Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658AbaLJNHT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 08:07:19 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:35997 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193AbaLJNHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 08:07:17 -0500
Date: Wed, 10 Dec 2014 16:06:46 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>, Benoit Taine <benoit.taine@lip6.fr>,
        Bjorn Helgaas <bhelgaas@google.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] ALSA: lola: NULL dereference on probe failure
Message-ID: <20141210130646.GA18593@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"card" is NULL if snd_card_new() fails.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/sound/pci/lola/lola.c b/sound/pci/lola/lola.c
index a75c8dc..4cf4be5 100644
--- a/sound/pci/lola/lola.c
+++ b/sound/pci/lola/lola.c
@@ -719,7 +719,7 @@ static int lola_probe(struct pci_dev *pci,
 	err = snd_card_new(&pci->dev, index[dev], id[dev], THIS_MODULE,
 			   0, &card);
 	if (err < 0) {
-		dev_err(card->dev, "Error creating card!\n");
+		dev_err(&pci->dev, "Error creating card!\n");
 		return err;
 	}
 

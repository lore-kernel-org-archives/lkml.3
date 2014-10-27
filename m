Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416AbaJ0FZr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 01:25:47 -0400
Received: from smtprelay0036.hostedemail.com ([216.40.44.36]:49324 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752907AbaJ0FZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 01:25:43 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1542:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3354:3865:3866:3867:3868:3871:4321:5007:6117:6119:6261:10004:10848:11026:11473:11658:11914:12438:12517:12519:12555:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: wine69_4ecc0b28c8a3c
X-Filterd-Recvd-Size: 2886
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org, Thibaut Varene <T-Bone@parisc-linux.org>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        linux-parisc@vger.kernel.org, alsa-devel@alsa-project.org
Subject: [PATCH 11/11] sound: ad1889: Fix probable mask then right shift defects
Date: Sun, 26 Oct 2014 22:25:07 -0700
Message-Id: <20f33139e87eb74f0ac50d0503a241936d4e0ff5.1414387334.git.joe@perches.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <cover.1414387334.git.joe@perches.com>
References: <cover.1414387334.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Precedence of & and >> is not the same and is not left to right.
shift has higher precedence and should be done after the mask.

Add parentheses around the mask.

Signed-off-by: Joe Perches <joe@perches.com>
---
 sound/pci/ad1889.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/pci/ad1889.c b/sound/pci/ad1889.c
index 7bfdf9c..1610c38 100644
--- a/sound/pci/ad1889.c
+++ b/sound/pci/ad1889.c
@@ -681,7 +681,7 @@ snd_ad1889_proc_read(struct snd_info_entry *entry, struct snd_info_buffer *buffe
 	
 	/* WARQ is at offset 12 */
 	tmp = (reg & AD_DS_WSMC_WARQ) ?
-			(((reg & AD_DS_WSMC_WARQ >> 12) & 0x01) ? 12 : 18) : 4;
+		((((reg & AD_DS_WSMC_WARQ) >> 12) & 0x01) ? 12 : 18) : 4;
 	tmp /= (reg & AD_DS_WSMC_WAST) ? 2 : 1;
 	
 	snd_iprintf(buffer, "Wave FIFO: %d %s words\n\n", tmp,
@@ -693,7 +693,7 @@ snd_ad1889_proc_read(struct snd_info_entry *entry, struct snd_info_buffer *buffe
 	
 	/* SYRQ is at offset 4 */
 	tmp = (reg & AD_DS_WSMC_SYRQ) ?
-			(((reg & AD_DS_WSMC_SYRQ >> 4) & 0x01) ? 12 : 18) : 4;
+		((((reg & AD_DS_WSMC_SYRQ) >> 4) & 0x01) ? 12 : 18) : 4;
 	tmp /= (reg & AD_DS_WSMC_WAST) ? 2 : 1;
 	
 	snd_iprintf(buffer, "Synthesis FIFO: %d %s words\n\n", tmp,
@@ -709,7 +709,7 @@ snd_ad1889_proc_read(struct snd_info_entry *entry, struct snd_info_buffer *buffe
 	
 	/* ACRQ is at offset 4 */
 	tmp = (reg & AD_DS_RAMC_ACRQ) ?
-			(((reg & AD_DS_RAMC_ACRQ >> 4) & 0x01) ? 12 : 18) : 4;
+		((((reg & AD_DS_RAMC_ACRQ) >> 4) & 0x01) ? 12 : 18) : 4;
 	tmp /= (reg & AD_DS_RAMC_ADST) ? 2 : 1;
 	
 	snd_iprintf(buffer, "ADC FIFO: %d %s words\n\n", tmp,
@@ -720,7 +720,7 @@ snd_ad1889_proc_read(struct snd_info_entry *entry, struct snd_info_buffer *buffe
 			
 	/* RERQ is at offset 12 */
 	tmp = (reg & AD_DS_RAMC_RERQ) ?
-			(((reg & AD_DS_RAMC_RERQ >> 12) & 0x01) ? 12 : 18) : 4;
+		((((reg & AD_DS_RAMC_RERQ) >> 12) & 0x01) ? 12 : 18) : 4;
 	tmp /= (reg & AD_DS_RAMC_ADST) ? 2 : 1;
 	
 	snd_iprintf(buffer, "Resampler FIFO: %d %s words\n\n", tmp,
-- 
2.1.2


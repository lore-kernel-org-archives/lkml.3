Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934034AbaE2Qvr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 12:51:47 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:53555 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932790AbaE2Qvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 12:51:46 -0400
Message-ID: <1401382304.25908.5.camel@x220>
Subject: [PATCH] sound: remove checks for CONFIG_BCM_CS4297A_CSWARM
From: Paul Bolle <pebolle@tiscali.nl>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Date: Thu, 29 May 2014 18:51:44 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 May 2014 16:51:44.0895 (UTC) FILETIME=[4605A0F0:01CF7B5E]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checks for CONFIG_BCM_CS4297A_CSWARM were added in v2.6.11. The related
Kconfig symbol was never added so these checks always evaluated to true.
Remove them.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

 sound/oss/swarm_cs4297a.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/sound/oss/swarm_cs4297a.c b/sound/oss/swarm_cs4297a.c
index f851fd0e199c..a33e8ce8085b 100644
--- a/sound/oss/swarm_cs4297a.c
+++ b/sound/oss/swarm_cs4297a.c
@@ -2625,15 +2625,12 @@ static int __init cs4297a_init(void)
 	u32 pwr, id;
 	mm_segment_t fs;
 	int rval;
-#ifndef CONFIG_BCM_CS4297A_CSWARM
 	u64 cfg;
 	int mdio_val;
-#endif
 
 	CS_DBGOUT(CS_INIT | CS_FUNCTION, 2, printk(KERN_INFO 
 		"cs4297a: cs4297a_init_module()+ \n"));
 
-#ifndef CONFIG_BCM_CS4297A_CSWARM
         mdio_val = __raw_readq(KSEG1 + A_MAC_REGISTER(2, R_MAC_MDIO)) &
                 (M_MAC_MDIO_DIR|M_MAC_MDIO_OUT);
 
@@ -2659,7 +2656,6 @@ static int __init cs4297a_init(void)
         __raw_writeq(mdio_val | M_MAC_GENC, KSEG1+A_MAC_REGISTER(2, R_MAC_MDIO));
         /* Give the codec some time to finish resetting (start the bit clock) */
         udelay(100);
-#endif
 
 	if (!(s = kzalloc(sizeof(struct cs4297a_state), GFP_KERNEL))) {
 		CS_DBGOUT(CS_ERROR, 1, printk(KERN_ERR
-- 
1.9.3


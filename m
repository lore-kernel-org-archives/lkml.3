Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218Ab3IEF5z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 01:57:55 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57189 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756660Ab3IEF5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 01:57:52 -0400
X-IronPort-AV: E=Sophos;i="4.90,844,1371052800"; 
   d="scan'208";a="8419289"
Message-ID: <52281D37.40808@cn.fujitsu.com>
Date: Thu, 05 Sep 2013 13:57:11 +0800
From: Duan Jiong <duanj.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: perex@perex.cz
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] ALSA: emu10k1: casting (void *) value returned by kcalloc
 is useless
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/05 13:55:39,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/05 13:55:39,
	Serialize complete at 2013/09/05 13:55:39
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=GB2312
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Duan Jiong <duanj.fnst@cn.fujitsu.com>

Casting (void *) value returned by kcalloc is useless
as mentioned in Documentation/CodingStyle, Chap 14.

Signed-off-by: Duan Jiong <duanj.fnst@cn.fujitsu.com>
---
 sound/pci/emu10k1/emufx.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/sound/pci/emu10k1/emufx.c b/sound/pci/emu10k1/emufx.c
index 0275209..68edb2d 100644
--- a/sound/pci/emu10k1/emufx.c
+++ b/sound/pci/emu10k1/emufx.c
@@ -1183,9 +1183,8 @@ static int _snd_emu10k1_audigy_init_efx(struct snd_emu10k1 *emu)
 	mm_segment_t seg;
 
 	if ((icode = kzalloc(sizeof(*icode), GFP_KERNEL)) == NULL ||
-	    (icode->gpr_map = (u_int32_t __user *)
-	     kcalloc(512 + 256 + 256 + 2 * 1024, sizeof(u_int32_t),
-		     GFP_KERNEL)) == NULL ||
+	    (icode->gpr_map = kcalloc(512 + 256 + 256 + 2 * 1024,
+				sizeof(u_int32_t), GFP_KERNEL)) == NULL ||
 	    (controls = kcalloc(SND_EMU10K1_GPR_CONTROLS,
 				sizeof(*controls), GFP_KERNEL)) == NULL) {
 		err = -ENOMEM;
@@ -1815,9 +1814,8 @@ static int _snd_emu10k1_init_efx(struct snd_emu10k1 *emu)
 
 	if ((icode = kzalloc(sizeof(*icode), GFP_KERNEL)) == NULL)
 		return -ENOMEM;
-	if ((icode->gpr_map = (u_int32_t __user *)
-	     kcalloc(256 + 160 + 160 + 2 * 512, sizeof(u_int32_t),
-		     GFP_KERNEL)) == NULL ||
+	if ((icode->gpr_map = kcalloc(256 + 160 + 160 + 2 * 512,
+				sizeof(u_int32_t), GFP_KERNEL)) == NULL ||
             (controls = kcalloc(SND_EMU10K1_GPR_CONTROLS,
 				sizeof(struct snd_emu10k1_fx8010_control_gpr),
 				GFP_KERNEL)) == NULL ||
-- 
1.8.3.1


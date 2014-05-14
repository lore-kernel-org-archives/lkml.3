Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553AbaENNcx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 09:32:53 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:38876 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbaENNcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 09:32:52 -0400
Date: Wed, 14 May 2014 16:32:21 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] ALSA: sb_mixer: missing return statement
Message-ID: <20140514133221.GD14571@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The if condition here was supposed to return on error but the return
statement is missing.  The effect is that the ->mixername is set to
"???" instead of "DT019X".

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/sound/isa/sb/sb_mixer.c b/sound/isa/sb/sb_mixer.c
index 6496822..1ff78ec 100644
--- a/sound/isa/sb/sb_mixer.c
+++ b/sound/isa/sb/sb_mixer.c
@@ -818,12 +818,14 @@ int snd_sbmixer_new(struct snd_sb *chip)
 			return err;
 		break;
 	case SB_HW_DT019X:
-		if ((err = snd_sbmixer_init(chip,
-					    snd_dt019x_controls,
-					    ARRAY_SIZE(snd_dt019x_controls),
-					    snd_dt019x_init_values,
-					    ARRAY_SIZE(snd_dt019x_init_values),
-					    "DT019X")) < 0)
+		err = snd_sbmixer_init(chip,
+				       snd_dt019x_controls,
+				       ARRAY_SIZE(snd_dt019x_controls),
+				       snd_dt019x_init_values,
+				       ARRAY_SIZE(snd_dt019x_init_values),
+				       "DT019X");
+		if (err < 0)
+			return err;
 		break;
 	default:
 		strcpy(card->mixername, "???");

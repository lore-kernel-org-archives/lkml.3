Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751190AbaACIUK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 03:20:10 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:34183 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813AbaACIUI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 03:20:08 -0500
Date: Fri, 3 Jan 2014 09:19:18 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ASoC: pcm: Fix lack of platform bespoke_trigger() call
Message-ID: <20140103091918.7387cfb5@armhf>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the platform driver has no ops, the platform function
bespoke_trigger() is no more called.

The problem was introduced by the commit c5914b0aaea6494aaa9e415cbd32f8b7eb604af0
	"ASoC: pcm: Check for ops before deferencing them"

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 sound/soc/soc-pcm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/soc-pcm.c b/sound/soc/soc-pcm.c
index 891b9a9..df79101 100644
--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -672,7 +672,7 @@ static int soc_pcm_bespoke_trigger(struct snd_pcm_substream *substream,
 			return ret;
 	}
 
-	if (platform->driver->ops && platform->driver->bespoke_trigger) {
+	if (platform->driver->bespoke_trigger) {
 		ret = platform->driver->bespoke_trigger(substream, cmd);
 		if (ret < 0)
 			return ret;
-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/

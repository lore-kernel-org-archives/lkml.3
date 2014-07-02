Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119AbaGBLUe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 07:20:34 -0400
Received: from cpanel09.rubas.ch ([195.182.222.79]:55622 "EHLO
	cpanel09.rubas.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbaGBLUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 07:20:32 -0400
From: =?UTF-8?q?J=C3=BCrg=20Billeter?= <j@bitron.ch>
To: Mark Brown <broonie@kernel.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?J=C3=BCrg=20Billeter?= <j@bitron.ch>
Subject: [PATCH] ASoC: rsnd: fixup index of SSI mod when SRC is used
Date: Wed,  2 Jul 2014 13:18:51 +0200
Message-Id: <1404299931-21384-1-git-send-email-j@bitron.ch>
X-Mailer: git-send-email 2.0.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cpanel09.rubas.ch
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - bitron.ch
X-Get-Message-Sender-Via: cpanel09.rubas.ch: authenticated_id: juerg@bitron.ch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The default index 1 was used as the loop was terminated before the
following code could be reached:

	if (mod[i] == this)
		index = i;

Signed-off-by: Jürg Billeter <j@bitron.ch>
---
 sound/soc/sh/rcar/core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sh/rcar/core.c b/sound/soc/sh/rcar/core.c
index 4e86265..d737fea 100644
--- a/sound/soc/sh/rcar/core.c
+++ b/sound/soc/sh/rcar/core.c
@@ -295,9 +295,11 @@ static void rsnd_dma_of_name(struct rsnd_dma *dma,
 	mod[0] = NULL; /* for "mem" */
 	index = 1;
 	for (i = 1; i < MOD_MAX; i++) {
-		if (!src) {
-			mod[i] = ssi;
+		if (!ssi) {
 			break;
+		} else if (!src) {
+			mod[i] = ssi;
+			ssi = NULL;
 		} else if (!dvc) {
 			mod[i] = src;
 			src = NULL;
-- 
2.0.1


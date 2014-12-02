Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932543AbaLBQkf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 11:40:35 -0500
Received: from mout.web.de ([212.227.17.12]:52990 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932443AbaLBQkc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 11:40:32 -0500
Message-ID: <547DEB6B.5000105@users.sourceforge.net>
Date: Tue, 02 Dec 2014 17:40:11 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jaroslav Kysela <perex@perex.cz>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/1] ASoC: mop500: Deletion of unnecessary checks before the
 function call "of_node_put"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:W5hZGki7PvXiRl4+a5EYWXOm4TVBS/9fw+vDPQWpkz8uu+b4qmS
 Kz52KLKaEfjmblTUtZYylVITQbW0UKU0ERNb9yu2JAtNHkBEdqRdi4neQWq8zTqs7r7dbXe
 0twYC79XNJ6CVvqh8nJg1+BNw6x3+Mk/KCVNO/qduiL3TWG1Soca+8AkkF4MRf46HxuZf9+
 YyAJDg5keJf9R4qIwE3TQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 2 Dec 2014 17:15:11 +0100

The of_node_put() function tests whether its argument is NULL and then
returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 sound/soc/ux500/mop500.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/sound/soc/ux500/mop500.c b/sound/soc/ux500/mop500.c
index 7f7093b..4e0c0e5 100644
--- a/sound/soc/ux500/mop500.c
+++ b/sound/soc/ux500/mop500.c
@@ -63,10 +63,8 @@ static void mop500_of_node_put(void)
 	int i;
 
 	for (i = 0; i < 2; i++) {
-		if (mop500_dai_links[i].cpu_of_node)
-			of_node_put(mop500_dai_links[i].cpu_of_node);
-		if (mop500_dai_links[i].codec_of_node)
-			of_node_put(mop500_dai_links[i].codec_of_node);
+		of_node_put(mop500_dai_links[i].cpu_of_node);
+		of_node_put(mop500_dai_links[i].codec_of_node);
 	}
 }
 
-- 
2.1.3


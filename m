Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703AbaLBNmA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 08:42:00 -0500
Received: from mout.web.de ([212.227.15.4]:63561 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753224AbaLBNl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 08:41:58 -0500
Message-ID: <547DC19B.5080302@users.sourceforge.net>
Date: Tue, 02 Dec 2014 14:41:47 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jaroslav Kysela <perex@perex.cz>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/1] ASoC: fsi: Deletion of unnecessary checks before the
 function call "clk_disable"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:IbSKMjyFZ6BN4sjwFwJz1WrQBnxPQbMA+7inr2ynPTo45DeOdsC
 7n9yDERnOwF4HraOnfrDCeKP/MyGj0gHcE8PjyLXqY4q49zp1ZuoCkb/otZX05H28ht9Omg
 dCXl1hlKJ42oIk6szkTt3lx7hdmxRFV41WGIveskq93NTNbYakzb10JFMnvozwn1ZMtaKxZ
 nUhp5AySPnSOopgN+qDVg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 2 Dec 2014 14:34:30 +0100

The clk_disable() function tests whether its argument is NULL and then
returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 sound/soc/sh/fsi.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/sound/soc/sh/fsi.c b/sound/soc/sh/fsi.c
index 88e5df4..8869971 100644
--- a/sound/soc/sh/fsi.c
+++ b/sound/soc/sh/fsi.c
@@ -842,12 +842,9 @@ static int fsi_clk_disable(struct device *dev,
 		return -EINVAL;
 
 	if (1 == clock->count--) {
-		if (clock->xck)
-			clk_disable(clock->xck);
-		if (clock->ick)
-			clk_disable(clock->ick);
-		if (clock->div)
-			clk_disable(clock->div);
+		clk_disable(clock->xck);
+		clk_disable(clock->ick);
+		clk_disable(clock->div);
 	}
 
 	return 0;
-- 
2.1.3


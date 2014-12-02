Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447AbaLBUza (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 15:55:30 -0500
Received: from mout.web.de ([212.227.15.3]:58473 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754035AbaLBUz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 15:55:29 -0500
Message-ID: <547E2738.1090708@users.sourceforge.net>
Date: Tue, 02 Dec 2014 21:55:20 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/2] ALSA: ctxfi: Deletion of an unnecessary check before
 the function call "kfree"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <547E2612.6010304@users.sourceforge.net>
In-Reply-To: <547E2612.6010304@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:Y10xBCB4UA0XbsLnAapbchz4LzXiidxsNlAwS2YgU/OHumUxldv
 TZd1w3vRQKF59QBLp3saRFsWk4eaxxDZVDXfEkB0mmHcZXPeEfUsIMH1RgY0SsnkhevBNsJ
 /z6kHwg8+ThPawOqdBsR6K9LVcaMQN/NtYr2U2d1wYIW27g+fCO9JdH7IIugzL/hOSuwuYd
 K/GLLBWC9wLQBF6flF6TA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 2 Dec 2014 20:00:33 +0100

The kfree() function performs also input parameter validation.
Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 sound/pci/ctxfi/ctdaio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/ctxfi/ctdaio.c b/sound/pci/ctxfi/ctdaio.c
index c1c3f88..1712332 100644
--- a/sound/pci/ctxfi/ctdaio.c
+++ b/sound/pci/ctxfi/ctdaio.c
@@ -577,7 +577,7 @@ static int get_daio_rsc(struct daio_mgr *mgr,
 error:
 	if (dao)
 		kfree(dao);
-	else if (dai)
+	else
 		kfree(dai);
 
 	spin_lock_irqsave(&mgr->mgr_lock, flags);
-- 
2.1.3


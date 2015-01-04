Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbbADMx0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 07:53:26 -0500
Received: from mout.web.de ([212.227.15.3]:56912 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752124AbbADMxZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 07:53:25 -0500
Message-ID: <54A937B6.6000302@users.sourceforge.net>
Date: Sun, 04 Jan 2015 13:53:10 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 2/13] ALSA: oss: Deletion of unnecessary checks before the
 function call "vfree"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <54A9355F.4050102@users.sourceforge.net>
In-Reply-To: <54A9355F.4050102@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:6LZU0sdEbrP+KDlBvWU4S0c1VKpNwTlTJDKrZ8SxfMK57fdVBLI
 P0psY05nn1baaziGZ/tAPxeAWzfNJ7V6ty7Kx/lMWSAgaNpfISkY7t8IEYwfaA19xWve+Pw
 WbU8T+0aTY+UhTOAt456kmkJFLFbjc0UxptAjYfdep0Bszq6kfSHYvl1AFgywbXiPkwIENy
 oEwxfDSbHslMZO7XTgGeg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 3 Jan 2015 15:10:52 +0100

The vfree() function performs also input parameter validation. Thus the test
around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 sound/oss/pss.c  | 2 +-
 sound/oss/trix.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/oss/pss.c b/sound/oss/pss.c
index ca0d6e9..81314f9 100644
--- a/sound/oss/pss.c
+++ b/sound/oss/pss.c
@@ -1228,7 +1228,7 @@ static void __exit cleanup_pss(void)
 {
 	if(!pss_no_sound)
 	{
-		if(fw_load && pss_synth)
+		if (fw_load)
 			vfree(pss_synth);
 		if(pssmss)
 			unload_pss_mss(&cfg2);
diff --git a/sound/oss/trix.c b/sound/oss/trix.c
index 944e0c0..3c494dc 100644
--- a/sound/oss/trix.c
+++ b/sound/oss/trix.c
@@ -487,7 +487,7 @@ static int __init init_trix(void)
 
 static void __exit cleanup_trix(void)
 {
-	if (fw_load && trix_boot)
+	if (fw_load)
 		vfree(trix_boot);
 	if (sb)
 		unload_trix_sb(&cfg2);
-- 
2.2.1


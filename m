Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287AbaKQMMe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 07:12:34 -0500
Received: from mout.web.de ([212.227.17.11]:64777 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897AbaKQMMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 07:12:33 -0500
Message-ID: <5469E61F.6000002@users.sourceforge.net>
Date: Mon, 17 Nov 2014 13:12:15 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Coccinelle <cocci@systeme.lip6.fr>
Subject: [PATCH 1/1] ALSA: hdsp: Deletion of an unnecessary check before the
 function call "release_firmware"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:CX+scxY4fl5xgwZ/n6yvlzrw4uaoqPG6Jg3WRM8z1OaLPCO2ha1
 s8DWqOjFlKPyemSW3W/UyLHxnlCwcxWUe9lqHJERPNqwb/rSrgpesMGWG5dY/Ieykq7uvEf
 axC69k3zBuxTdMTsqQMvP7obMqS39gxA6cpDuz6muOllDbW6BhcB0TzHb7QbrI0Nu8qBC2w
 UddL/FC8+Sg0e53gPcyHg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 17 Nov 2014 13:04:14 +0100

The release_firmware() function tests whether its argument is NULL and then
return immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 sound/pci/rme9652/hdsp.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/sound/pci/rme9652/hdsp.c b/sound/pci/rme9652/hdsp.c
index 7646ba1..0ae568d 100644
--- a/sound/pci/rme9652/hdsp.c
+++ b/sound/pci/rme9652/hdsp.c
@@ -5368,8 +5368,7 @@ static int snd_hdsp_free(struct hdsp *hdsp)
 
 	snd_hdsp_free_buffers(hdsp);
 
-	if (hdsp->firmware)
-		release_firmware(hdsp->firmware);
+	release_firmware(hdsp->firmware);
 	vfree(hdsp->fw_uploaded);
 
 	if (hdsp->iobase)
-- 
2.1.3



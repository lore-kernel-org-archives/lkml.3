Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778AbaKUKlF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 05:41:05 -0500
Received: from mout.web.de ([212.227.15.4]:60749 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810AbaKUKlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 05:41:04 -0500
Message-ID: <546F16A5.8030405@users.sourceforge.net>
Date: Fri, 21 Nov 2014 11:40:37 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Andreas Noever <andreas.noever@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/1] thunderbolt: Deletion of unnecessary checks before the
 function call "ring_free"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:7X/PizdUj20Zd/AL66ektf3dAlVBF+BH9EgcpFh9swhJEEsOuzC
 aMEBoecEQgWmtlbJDAj11kvHDwKyqRU3RQuTdnlowUckP9arymhqWcMAyK8qz35rtNsHQbY
 TiFJQ+lWYFeGSV5VaoZ3wNmNrphWQeRcZtf9oc/YdAyTcuxLYnHVmRdYu/TBwf0eR9ye8hA
 dN663bGzRMZzgcg8CHyNg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 21 Nov 2014 11:30:18 +0100

The ring_free() function tests whether its argument is NULL and then
returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/thunderbolt/ctl.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/thunderbolt/ctl.c b/drivers/thunderbolt/ctl.c
index 799634b..55b9bdf 100644
--- a/drivers/thunderbolt/ctl.c
+++ b/drivers/thunderbolt/ctl.c
@@ -520,10 +520,8 @@ err:
 void tb_ctl_free(struct tb_ctl *ctl)
 {
 	int i;
-	if (ctl->rx)
-		ring_free(ctl->rx);
-	if (ctl->tx)
-		ring_free(ctl->tx);
+	ring_free(ctl->rx);
+	ring_free(ctl->tx);
 
 	/* free RX packets */
 	for (i = 0; i < TB_CTL_RX_PKG_COUNT; i++)
-- 
2.1.3


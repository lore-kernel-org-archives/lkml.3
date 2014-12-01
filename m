Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114AbaLASZF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 13:25:05 -0500
Received: from mout.web.de ([212.227.17.11]:49490 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753758AbaLASZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 13:25:03 -0500
Message-ID: <547CB26E.6060500@users.sourceforge.net>
Date: Mon, 01 Dec 2014 19:24:46 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Joshua Morris <josh.h.morris@us.ibm.com>,
        Philip Kelleher <pjk1939@linux.vnet.ibm.com>
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/1] block-rsxx: Deletion of an unnecessary check before the
 function call "vfree"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:4zsKpAgizPYqHQjvX6ssO2JrAy7bVNKdgufW4i1z2GeLgoC1SEI
 jlF5lcfT65xaMS8LicbWwvHDC1+FniP7nM9TZRW0rvmWztj5q1S9z/XA63Hb0lzu5BiODAe
 rsRZcLQ/kL0LkeuoJGTkB8Q06K7PGlnHYAIJ7TsESmICv9+8+e6R/g1bMxotPYZhKPzRfFL
 IxQUGUJMY+uFgiESmSfjw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 1 Dec 2014 19:19:25 +0100

The vfree() function performs also input parameter validation.
Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/block/rsxx/dma.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/block/rsxx/dma.c b/drivers/block/rsxx/dma.c
index cf8cd29..0181387 100644
--- a/drivers/block/rsxx/dma.c
+++ b/drivers/block/rsxx/dma.c
@@ -960,8 +960,7 @@ failed_dma_setup:
 			ctrl->done_wq = NULL;
 		}
 
-		if (ctrl->trackers)
-			vfree(ctrl->trackers);
+		vfree(ctrl->trackers);
 
 		if (ctrl->status.buf)
 			pci_free_consistent(card->dev, STATUS_BUFFER_SIZE8,
-- 
2.1.3


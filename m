Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515AbaLNWj6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 17:39:58 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:37084 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755AbaLNWjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 17:39:39 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Forest Bond <forest@alittletooquiet.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Malcolm Priestley <tvboxspy@gmail.com>,
        Guillaume Clement <gclement@baobob.org>,
        =?UTF-8?q?Guido=20Mart=C3=ADnez?= <guido@vanguardiasur.com.ar>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Himangi Saraogi <himangi774@gmail.com>, Joe Perches <joe@perches.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: vt6655: wmgr.c:  Fix for possible null pointer dereference
Date: Sun, 14 Dec 2014 23:42:20 +0100
Message-Id: <1418596940-24915-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is otherwise a risk of a possible null pointer dereference.

Was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/vt6655/wmgr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vt6655/wmgr.c b/drivers/staging/vt6655/wmgr.c
index c73c39d..f98935c 100644
--- a/drivers/staging/vt6655/wmgr.c
+++ b/drivers/staging/vt6655/wmgr.c
@@ -4391,7 +4391,7 @@ bAdd_PMKID_Candidate(
 	unsigned int ii = 0;
 
 	pr_debug("bAdd_PMKID_Candidate START: (%d)\n",
-		 (int)pDevice->gsPMKIDCandidate.NumCandidates);
+		(int)(pDevice ? pDevice->gsPMKIDCandidate.NumCandidates : 0));
 
 	if ((pDevice == NULL) || (pbyBSSID == NULL) || (psRSNCapObj == NULL))
 		return false;
-- 
1.7.10.4


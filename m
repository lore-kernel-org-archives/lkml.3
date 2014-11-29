Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751566AbaK2RAb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 12:00:31 -0500
Received: from mout.web.de ([212.227.17.11]:50355 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075AbaK2RA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 12:00:29 -0500
Message-ID: <5479FBA2.5020405@users.sourceforge.net>
Date: Sat, 29 Nov 2014 18:00:18 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Christine Caulfield <ccaulfie@redhat.com>,
        David Teigland <teigland@redhat.com>, cluster-devel@redhat.com
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/1] fs-DLM: Deletion of unnecessary checks before the function
 call "kfree"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:LwcXk7KJW3uyUO4Cc7IDU4NHLGyy2LTFxaNp/VM+shv0hPlIbEn
 NLHcuqWFNx/48xPH8n8uvSSuGoUdYv5u3Pt9+MdaqbZiUp3M51/QoI6KxeQCQAD6jWjhROk
 /aH0m5wh62Rf8Cvh28v9bwinaIeL7wyOg3WDXHmnhWti5pGXs3dryRfG1P3U5d7egN3Pkw4
 /sTnKf/+hgJ/cRsxyo9zQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 29 Nov 2014 17:55:39 +0100

The kfree() function tests whether its argument is NULL and then
returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 fs/dlm/lockspace.c | 3 +--
 fs/dlm/memory.c    | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index f3e7278..b660b93 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -674,8 +674,7 @@ static int new_lockspace(const char *name, const char *cluster,
  out_lkbidr:
 	idr_destroy(&ls->ls_lkbidr);
 	for (i = 0; i < DLM_REMOVE_NAMES_MAX; i++) {
-		if (ls->ls_remove_names[i])
-			kfree(ls->ls_remove_names[i]);
+		kfree(ls->ls_remove_names[i]);
 	}
  out_rsbtbl:
 	vfree(ls->ls_rsbtbl);
diff --git a/fs/dlm/memory.c b/fs/dlm/memory.c
index 7cd24bc..2d2eaa0 100644
--- a/fs/dlm/memory.c
+++ b/fs/dlm/memory.c
@@ -86,8 +86,7 @@ void dlm_free_lkb(struct dlm_lkb *lkb)
 		struct dlm_user_args *ua;
 		ua = lkb->lkb_ua;
 		if (ua) {
-			if (ua->lksb.sb_lvbptr)
-				kfree(ua->lksb.sb_lvbptr);
+			kfree(ua->lksb.sb_lvbptr);
 			kfree(ua);
 		}
 	}
-- 
2.1.3


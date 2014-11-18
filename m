Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674AbaKRNs1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 08:48:27 -0500
Received: from mout.web.de ([212.227.17.12]:64207 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754037AbaKRNsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 08:48:25 -0500
Message-ID: <546B4E19.8050405@users.sourceforge.net>
Date: Tue, 18 Nov 2014 14:48:09 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
        linux-nilfs@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Coccinelle <cocci@systeme.lip6.fr>
Subject: [PATCH 1/1] nilfs2: Deletion of an unnecessary check before the function
 call "iput"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:KxdtesqSb1o9fg07QYYdpfT2KLsYkyQZYveYqY87DMX63Zo5PNq
 qFqvZQtiRhicESBV/DhJ0Ih8eT5hpIlOZMPjiLTttU0eVWEURvXPZzqk6Bf7jQxznj660ta
 Gbp8O0JLZfJX7hJBus283AxJCQRve7ffEI4qupLrTrhPfEOL2kDQq1W012pUn102jku4v3T
 GARzVDxFzQk4AQFBuFkBQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 18 Nov 2014 14:41:27 +0100

The iput() function tests whether its argument is NULL and then
returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 fs/nilfs2/the_nilfs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 9da25fe..69bd801 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -808,8 +808,7 @@ void nilfs_put_root(struct nilfs_root *root)
 		spin_lock(&nilfs->ns_cptree_lock);
 		rb_erase(&root->rb_node, &nilfs->ns_cptree);
 		spin_unlock(&nilfs->ns_cptree_lock);
-		if (root->ifile)
-			iput(root->ifile);
+		iput(root->ifile);
 
 		kfree(root);
 	}
-- 
2.1.3


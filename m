Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202AbbAROkq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 09:40:46 -0500
Received: from mout.web.de ([212.227.17.11]:60321 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751238AbbAROkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 09:40:45 -0500
Message-ID: <54BBC5E4.10400@users.sourceforge.net>
Date: Sun, 18 Jan 2015 15:40:36 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 2/3] block-z2ram: Delete an unnecessary check before the function
 call "kfree"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <54BBC3AB.6040207@users.sourceforge.net>
In-Reply-To: <54BBC3AB.6040207@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:AYKteBS8eNuYFocnXe5CZNYjUyg2fB/rhU01Y96fKJdS5JsbO4L
 8x3fJx3iCFrkNZ5oYYipxU+7eUz4xsk6FzZ2JBfvhvamxp/Esu9iv27MHAV5XQV9q3afsBW
 5lpKTqlkbREY3SmKRfveDL61mIwDB4/yunOjPiY0OFcJZ1xKhzck9itO9j0i1ZouFFjUaNx
 Lq4pMZNl079q+VjBTjzZQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 18 Jan 2015 12:28:27 +0100

The kfree() function tests whether its argument is NULL and then
returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/block/z2ram.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/block/z2ram.c b/drivers/block/z2ram.c
index 968f9e5..c32f248 100644
--- a/drivers/block/z2ram.c
+++ b/drivers/block/z2ram.c
@@ -404,10 +404,7 @@ static void __exit z2_exit(void)
 	    }
 	}
 
-	if ( z2ram_map != NULL )
-	{
-	    kfree( z2ram_map );
-	}
+	kfree(z2ram_map);
     }
 
     return;
-- 
2.2.2


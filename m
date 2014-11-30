Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453AbaK3WXe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 17:23:34 -0500
Received: from mout.web.de ([212.227.17.11]:63149 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752117AbaK3WXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 17:23:32 -0500
Message-ID: <547B98D5.8000909@users.sourceforge.net>
Date: Sun, 30 Nov 2014 23:23:17 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>, linux-media@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/1] [media] V4L2: Deletion of an unnecessary check before
 the function call "vb2_put_vma"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:ut9f10+9aqj3lJX0AcCCM9hIehPQYDnvtj19yPHFJxiTXgkZyxT
 Mrw1FlmCSFVEk4qy63onzQCMNFcBwT/n0tGiaMPFk5tNeYi1rp7nRW31NXnISMJPg9klbnk
 yMaFSbZYTVI9nf20Qev/K13ZIUXQzKe4QgU6LKKozE4Cf7VdbfUHKee7RITIgIPDIg+RhBt
 4Uk+jQcOrU31x44H5BLRQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 30 Nov 2014 23:10:51 +0100

The vb2_put_vma() function tests whether its argument is NULL and then
returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/v4l2-core/videobuf2-vmalloc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-vmalloc.c b/drivers/media/v4l2-core/videobuf2-vmalloc.c
index 3966b12..fba944e 100644
--- a/drivers/media/v4l2-core/videobuf2-vmalloc.c
+++ b/drivers/media/v4l2-core/videobuf2-vmalloc.c
@@ -154,8 +154,7 @@ static void vb2_vmalloc_put_userptr(void *buf_priv)
 		}
 		kfree(buf->pages);
 	} else {
-		if (buf->vma)
-			vb2_put_vma(buf->vma);
+		vb2_put_vma(buf->vma);
 		iounmap(buf->vaddr);
 	}
 	kfree(buf);
-- 
2.1.3


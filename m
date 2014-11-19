Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350AbaKSKom (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 05:44:42 -0500
Received: from mout.web.de ([212.227.17.12]:60105 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487AbaKSKok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 05:44:40 -0500
Message-ID: <546C748B.1010208@users.sourceforge.net>
Date: Wed, 19 Nov 2014 11:44:27 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ming Lei <ming.lei@canonical.com>
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/1] firmware class: Deletion of an unnecessary check before
 the function call "vunmap"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:1j0qKr3CB3P+IbKn4vxpreOGf7OMsPI75Vz3cvLyRRh9wPe0idi
 K5VdoJu5/xkDG8hmyRfIvahvcRye/ujVQ52Oabk8ZpSf78zH1CDmKfA40jLzKQX3f11lPiN
 mxT9aQGlVmGqEsi3UU052PU+pGtxmhCUyCQbnnw1YVpLZ5Mk35+N/td+ZhOCZW49wUxkCrw
 eAg/AwUFSn69fbdJ3ZoBQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 19 Nov 2014 11:38:38 +0100

The vunmap() function performes also input parameter validation. Thus the test
around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/base/firmware_class.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 3d785eb..532662c 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -591,8 +591,7 @@ static int fw_map_pages_buf(struct firmware_buf *buf)
 	if (!buf->is_paged_buf)
 		return 0;
 
-	if (buf->data)
-		vunmap(buf->data);
+	vunmap(buf->data);
 	buf->data = vmap(buf->pages, buf->nr_pages, 0, PAGE_KERNEL_RO);
 	if (!buf->data)
 		return -ENOMEM;
-- 
2.1.3


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756485AbaKSTzq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 14:55:46 -0500
Received: from mout.web.de ([212.227.15.3]:52944 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755976AbaKSTzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 14:55:44 -0500
Message-ID: <546CF5A6.3030305@users.sourceforge.net>
Date: Wed, 19 Nov 2014 20:55:18 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Karsten Keil <isdn@linux-pingi.de>, netdev@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/1] mISDN: Deletion of unnecessary checks before the function
 call "vfree"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:YvUqvQ5FesHZssW1fk0+OfKlBsScZMCIykXMSLmP00zhacsXEm8
 RmW348JeA/pz9iC0PqYrZwq+iBKXXCncbj/TsVNkJGXfKxtxPM25SxxNg//Vzhv07R/u+rz
 wiAZ/X1/O0nXqhXI4sLry+JBZgKGiEwtBOC6sEiUy5ffLjfT2AVGqbNajOPMdDjuDVCF/Yq
 TUzEYyBU0/kp8s/8g7fXA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 19 Nov 2014 20:48:26 +0100

The vfree() function performs also input parameter validation. Thus the test
around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/isdn/mISDN/l1oip_codec.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/isdn/mISDN/l1oip_codec.c b/drivers/isdn/mISDN/l1oip_codec.c
index a601c84..9b033be 100644
--- a/drivers/isdn/mISDN/l1oip_codec.c
+++ b/drivers/isdn/mISDN/l1oip_codec.c
@@ -312,10 +312,8 @@ l1oip_ulaw_to_alaw(u8 *data, int len, u8 *result)
 void
 l1oip_4bit_free(void)
 {
-	if (table_dec)
-		vfree(table_dec);
-	if (table_com)
-		vfree(table_com);
+	vfree(table_dec);
+	vfree(table_com);
 	table_com = NULL;
 	table_dec = NULL;
 }
-- 
2.1.3


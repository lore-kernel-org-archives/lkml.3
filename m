Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758540AbaKUN4C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 08:56:02 -0500
Received: from mout.web.de ([212.227.15.4]:56114 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755426AbaKUN4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 08:56:00 -0500
Message-ID: <546F4460.5000205@users.sourceforge.net>
Date: Fri, 21 Nov 2014 14:55:44 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/1] USB: gadget: function: Deletion of an unnecessary check
 before the function call "rndis_add_hdr"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:kj6zlFZrKUIOYNJpu6kFYkRe/y+d324N6bic03TYvz3UdPg9MHO
 xzAANL46EmUIzt6wS8gW0EFxIfxac7CCqNFfgOVeErpgg3oYw22x6dcZZXy58qOmmQLzPRp
 /ihyst0o0eGljqUx1YEljgtBeizNIU0yBXkE+Kl4tZWL8AyJHugkLvhCQ6Tli9jEnD/l88X
 X5E09q7BGTNHS+KAqgeCg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 21 Nov 2014 14:51:43 +0100

The rndis_add_hdr() function tests whether its argument is NULL and then
returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/usb/gadget/function/f_rndis.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/function/f_rndis.c b/drivers/usb/gadget/function/f_rndis.c
index ddb09dc..da56a5f 100644
--- a/drivers/usb/gadget/function/f_rndis.c
+++ b/drivers/usb/gadget/function/f_rndis.c
@@ -375,8 +375,7 @@ static struct sk_buff *rndis_add_header(struct gether *port,
 	struct sk_buff *skb2;
 
 	skb2 = skb_realloc_headroom(skb, sizeof(struct rndis_packet_msg_type));
-	if (skb2)
-		rndis_add_hdr(skb2);
+	rndis_add_hdr(skb2);
 
 	dev_kfree_skb(skb);
 	return skb2;
-- 
2.1.3


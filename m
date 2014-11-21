Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758367AbaKUOzk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 09:55:40 -0500
Received: from mout.web.de ([212.227.17.11]:65116 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755190AbaKUOzi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 09:55:38 -0500
Message-ID: <546F525A.7050002@users.sourceforge.net>
Date: Fri, 21 Nov 2014 15:55:22 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Winischhofer <thomas@winischhofer.net>,
        linux-usb@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/1] USB-SIS: Deletion of an unnecessary check before the
 function call "usb_put_dev"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:rvuswkOb/9wr11XmIxb3jUtBhksAAhwlBJ5UYJOV+/L4oUvMrXs
 4TSM+pLfHHWq+CqO8ubS+dZGD+EVw92SfoMi/TwOhg64Ia0xVKZUjlp/4mlUQvH++qbbnYA
 oN2F8ULaCme922Rd6KXmcJbGJkyInIrzekTStFE3gkuHpQfV8CAZmYFT88jxDhOV07AwgKe
 IMCHyufkm+IJI3fktsiRQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 21 Nov 2014 15:50:44 +0100

The usb_put_dev() function tests whether its argument is NULL and then
returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/usb/misc/sisusbvga/sisusb.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/usb/misc/sisusbvga/sisusb.c b/drivers/usb/misc/sisusbvga/sisusb.c
index 633caf6..022dc00 100644
--- a/drivers/usb/misc/sisusbvga/sisusb.c
+++ b/drivers/usb/misc/sisusbvga/sisusb.c
@@ -2472,8 +2472,7 @@ sisusb_delete(struct kref *kref)
 	if (!sisusb)
 		return;
 
-	if (sisusb->sisusb_dev)
-		usb_put_dev(sisusb->sisusb_dev);
+	usb_put_dev(sisusb->sisusb_dev);
 
 	sisusb->sisusb_dev = NULL;
 	sisusb_free_buffers(sisusb);
-- 
2.1.3


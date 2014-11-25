Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751113AbaKYP5Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 10:57:16 -0500
Received: from mout.web.de ([212.227.15.3]:55240 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821AbaKYP5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 10:57:15 -0500
Message-ID: <5474A6CF.1040000@users.sourceforge.net>
Date: Tue, 25 Nov 2014 16:57:03 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shigekatsu Tateno <shigekatsu.tateno@atmel.com>,
        devel@driverdev.osuosl.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/1] staging: ozwpan: Deletion of unnecessary checks before
 the function call "oz_free_urb_link"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:SKiE8NVV0wDpSvJSD9cJ4yhr7Wy7epRj4SuDwxfaWiWefCVohY3
 rSXungew8Eq4+D3+FaBilT94zVT23jhlYlncWqtl0A2QmA2Y/X/2NcHPdWzRoFV4pZB7A6C
 S9wJ6kB5flH/nDYj4+JGywRnf52nDGWXbuaiMGY07ZjRbY4UiP0VvDTO0xgqUACnPIBQq7Q
 ytcbTnpZ3JiNsmvBFc5MA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 25 Nov 2014 16:51:08 +0100

The oz_free_urb_link() function tests whether its argument is NULL
and then returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/staging/ozwpan/ozhcd.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/ozwpan/ozhcd.c b/drivers/staging/ozwpan/ozhcd.c
index 30bd928..c9b6d98 100644
--- a/drivers/staging/ozwpan/ozhcd.c
+++ b/drivers/staging/ozwpan/ozhcd.c
@@ -411,8 +411,7 @@ static void oz_complete_urb(struct usb_hcd *hcd, struct urb *urb,
 	}
 	spin_lock(&g_tasklet_lock);
 	spin_unlock_irqrestore(&g_tasklet_lock, irq_state);
-	if (cancel_urbl)
-		oz_free_urb_link(cancel_urbl);
+	oz_free_urb_link(cancel_urbl);
 }
 
 /*
@@ -581,8 +580,7 @@ static int oz_dequeue_ep_urb(struct oz_port *port, u8 ep_addr, int in_dir,
 		}
 	}
 	spin_unlock_bh(&port->ozhcd->hcd_lock);
-	if (urbl)
-		oz_free_urb_link(urbl);
+	oz_free_urb_link(urbl);
 	return urbl ? 0 : -EIDRM;
 }
 
-- 
2.1.3


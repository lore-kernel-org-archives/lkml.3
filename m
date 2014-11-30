Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328AbaK3V4x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 16:56:53 -0500
Received: from mout.web.de ([212.227.17.11]:56711 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752117AbaK3V4v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 16:56:51 -0500
Message-ID: <547B9246.3080209@users.sourceforge.net>
Date: Sun, 30 Nov 2014 22:55:18 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        linux-media@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/1] [media] ddbridge: Deletion of an unnecessary check before
 the function call "dvb_unregister_device"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:OmRxywOHczObxnGVkJD3lyJs8JLiqojlD/5B8GS1uoVGYzyDiAe
 w1wRY0VLvdZcaLvG923NlIcViN/CRnN6yqhHSVlbqVxUSUKY5LwepYnEWsXd3+p2mAxRlnD
 QLwDZ6bE+J4mF4gEhEoMI3auJr5hnewMP7bU4pAQqxIO48JLDFCKJWyMPUXYU2kVHCY7T9D
 6ip+tFUNuFonOOI9R3w/A==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 30 Nov 2014 22:50:20 +0100

The dvb_unregister_device() function tests whether its argument is NULL
and then returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/pci/ddbridge/ddbridge-core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index c82e855..9e3492e 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -1118,8 +1118,7 @@ static void ddb_ports_detach(struct ddb *dev)
 			dvb_input_detach(port->input[1]);
 			break;
 		case DDB_PORT_CI:
-			if (port->output->dev)
-				dvb_unregister_device(port->output->dev);
+			dvb_unregister_device(port->output->dev);
 			if (port->en) {
 				ddb_input_stop(port->input[0]);
 				ddb_output_stop(port->output);
-- 
2.1.3


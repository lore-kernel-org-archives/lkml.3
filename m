Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990AbaLAS4T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 13:56:19 -0500
Received: from mout.web.de ([212.227.15.14]:49667 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752854AbaLAS4S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 13:56:18 -0500
Message-ID: <547CB9BD.5050101@users.sourceforge.net>
Date: Mon, 01 Dec 2014 19:55:57 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jarod Wilson <jarod@wilsonet.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/1] [media] lirc_zilog: Deletion of unnecessary checks before
 the function call "vfree"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:mwZElN0T5sQgeoK6CSToFdJsOFeFWDPhL2I+HD+v4N2RC+gNQsB
 p4c+VDDoUr1OHO3WyNuT4w+eifRN+OaMrFyOkNs7AaQJl/qf8y1yFsb4cAWi4uNUOpV2S+U
 nVfpj5tlK6ghYC7VpIaUtdW5tRGZeXp/xzjfmZbjz0EiboVvTRO6/w4dNN2jlGkdSCGq3Ll
 FIO2sP2bLXrK6ff91xnTA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 1 Dec 2014 19:49:39 +0100

The vfree() function performs also input parameter validation. Thus the test
around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/staging/media/lirc/lirc_zilog.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_zilog.c b/drivers/staging/media/lirc/lirc_zilog.c
index 3259aac..50b255a 100644
--- a/drivers/staging/media/lirc/lirc_zilog.c
+++ b/drivers/staging/media/lirc/lirc_zilog.c
@@ -729,11 +729,9 @@ static int send_boot_data(struct IR_tx *tx)
 static void fw_unload_locked(void)
 {
 	if (tx_data) {
-		if (tx_data->code_sets)
-			vfree(tx_data->code_sets);
+		vfree(tx_data->code_sets);
 
-		if (tx_data->datap)
-			vfree(tx_data->datap);
+		vfree(tx_data->datap);
 
 		vfree(tx_data);
 		tx_data = NULL;
-- 
2.1.3


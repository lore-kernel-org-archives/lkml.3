Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751706AbaKVOFs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 09:05:48 -0500
Received: from mout.web.de ([212.227.17.11]:59988 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751139AbaKVOFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 09:05:46 -0500
Message-ID: <54709827.4050408@users.sourceforge.net>
Date: Sat, 22 Nov 2014 15:05:27 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Sebastian Ott <sebott@linux.vnet.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/1] s390/pci: Deletion of unnecessary checks before the function
 call "debug_unregister"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:SINROy2DwZyjo1TdxMDhfilAL/rcROm7Wwl0RhRIigq1VLcH7TZ
 HnticDA7sQ6bhdjJwdrj71Qz8L+o0SY40FwJwukygycfC7YHqruMAgIlmMaKepUzSLYN9MS
 VEYXJr5uZeDjxF23yZ+Yn4OYZ/okDAtFRr2Mb0zA1K1fDjrRxSBRRNWcg5oAcLYO6zjbYp1
 YXQOdeDBExR+1FmyS7s5g==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 22 Nov 2014 15:00:55 +0100

The debug_unregister() function performs also input parameter validation.
Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 arch/s390/pci/pci_debug.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/s390/pci/pci_debug.c b/arch/s390/pci/pci_debug.c
index eec598c..18403a7 100644
--- a/arch/s390/pci/pci_debug.c
+++ b/arch/s390/pci/pci_debug.c
@@ -158,10 +158,8 @@ int __init zpci_debug_init(void)
 
 void zpci_debug_exit(void)
 {
-	if (pci_debug_msg_id)
-		debug_unregister(pci_debug_msg_id);
-	if (pci_debug_err_id)
-		debug_unregister(pci_debug_err_id);
+	debug_unregister(pci_debug_msg_id);
+	debug_unregister(pci_debug_err_id);
 
 	debugfs_remove(debugfs_root);
 }
-- 
2.1.3


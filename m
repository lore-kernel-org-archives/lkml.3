Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751616AbaKVMA4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 07:00:56 -0500
Received: from mout.web.de ([212.227.17.11]:60536 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750969AbaKVMAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 07:00:55 -0500
Message-ID: <54707ADB.30807@users.sourceforge.net>
Date: Sat, 22 Nov 2014 13:00:27 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        "Jon D. Mason" <jdmason@kudzu.us>, Muli Ben-Yehuda <muli@il.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        discuss@x86-64.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/1] x86: PCI-Calgary: Deletion of an unnecessary check before
 the function call "free_tce_table"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:2GbBHHgnu/8qHtVRtg1Q4UX1fyzgRk/PbX59uBQliEKNVI8sYx7
 MiMIU4EEGdUaLo+0c2la3wKpw3pnqqpsx6O9QL536j4KSY2BXtWOHjkaoqyLOlcjIVx6kLP
 N27McpqcO0zRYg017hHM8OvG4xdXDwvID6v8tpPFGWovwJBMDbstcVL8ybcZdWgA7nxncU9
 1exZgxNcZZGoMKorP1ylg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 22 Nov 2014 12:55:28 +0100

The free_tce_table() function tests whether its argument is NULL and then
returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 arch/x86/kernel/pci-calgary_64.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index 0497f71..d22a386 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -1476,8 +1476,7 @@ cleanup:
 	for (--bus; bus >= 0; --bus) {
 		struct calgary_bus_info *info = &bus_info[bus];
 
-		if (info->tce_space)
-			free_tce_table(info->tce_space);
+		free_tce_table(info->tce_space);
 	}
 	return -ENOMEM;
 }
-- 
2.1.3


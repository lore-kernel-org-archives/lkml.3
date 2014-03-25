Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683AbaCYPsj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 11:48:39 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:50553 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607AbaCYPsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 11:48:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Insop Song <insop.song@gainspeed.com>
Subject: [PATCH] staging: gs_fpgaboot: remove __TIMESTAMP__ macro
Date: Tue, 25 Mar 2014 16:48:35 +0100
Message-ID: <1398516318.KXtUGEPAeQ@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:+Bn+yJGbPHANx3frIZieJzOdHGVv3fxGx2cM0kHM3ny
 pkcpxOKhfhHVeODDH56nIKLx0igKiFeJRE5kjtqHUuVosJiOk/
 FSy4rWfEq9yjPH3Byqt8hNvQS98tqNxgg4CVT+eV3QIwlrDf0d
 oXd9SnMykJVIGWHRFqP4y33I/e+EsPkvTT4GW8q4zcLifwkpKa
 QwbpBx/ygnkc7A1H6qW/v/1aLRnXGWUMXYIKeqyTFHIhGzvwBZ
 Cy75rr8eAwpl9gZmlpeUr3czSYnFn1ex/DZvUclbBzKOwmFPNF
 V5Jr3PsxKHVPDic9ehLF3f1kyNPLBeoCXYlzFc7fXt/SWYEJP3
 /PkCNV+zictVbWoHsf8U=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We specifically build the kernel with -Werror=date-time to detect
such macros, which gives us this error:

gs_fpgaboot/gs_fpgaboot.c:376:44: error: macro "__TIMESTAMP__" might prevent reproducible builds [-Werror=date-time]
  pr_info("built at %s UTC\n", __TIMESTAMP__);

The obvious fix is to remove the printk output line.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/drivers/staging/gs_fpgaboot/gs_fpgaboot.c b/drivers/staging/gs_fpgaboot/gs_fpgaboot.c
index 89bc84d..7506900 100644
--- a/drivers/staging/gs_fpgaboot/gs_fpgaboot.c
+++ b/drivers/staging/gs_fpgaboot/gs_fpgaboot.c
@@ -373,7 +373,6 @@ static int __init gs_fpgaboot_init(void)
 	r = -1;
 
 	pr_info("FPGA DOWNLOAD --->\n");
-	pr_info("built at %s UTC\n", __TIMESTAMP__);
 
 	pr_info("FPGA image file name: %s\n", file);
 


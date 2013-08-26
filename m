Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209Ab3HZTW6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 15:22:58 -0400
Received: from mga14.intel.com ([143.182.124.37]:57551 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752103Ab3HZTW4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 15:22:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,961,1367996400"; 
   d="scan'208,223";a="351857696"
From: "Yang, Fei" <fei.yang@intel.com>
To: "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "'linux-kernel@vger.kernel.org' (linux-kernel@vger.kernel.org)" 
	<linux-kernel@vger.kernel.org>
Subject: Can anyone suggest a better fix? Not sure if I understand the
 problem, but the patch fixed it
Thread-Topic: Can anyone suggest a better fix? Not sure if I understand the
 problem, but the patch fixed it
Thread-Index: Ac6ikZoVxBxE4fuwQdCkVcy9DopOgA==
Date: Mon, 26 Aug 2013 19:22:46 +0000
Message-ID: <02E7334B1630744CBDC55DA85862258348E431C1@ORSMSX102.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 5e6501efa26bc19dad0b43e3a2b0daa81408a8ae Mon Sep 17 00:00:00 2001
From: Fei Yang <fei.yang@intel.com>
Date: Mon, 26 Aug 2013 11:21:48 -0700
Subject: [PATCH] FIXDEP: error opening depfile
 
Met a kernel build issue where fixdep fails to open a depfile,
fixdep: error opening depfile: drivers/driver-name/.driver-code.o.d: No such file or directory
make[4]: *** [drivers/driver-name/driver-code.o] Error 2
make[3]: *** [drivers/driver-name] Error 2
Don't know why the expected file was not created, but the assumption that
the file had been created might not be true, so simply return for such failure.
 
Change-Id: I299c01f2e3f6e1d04b19ced34ebeb964e16494e6
Signed-off-by: Fei Yang <fei.yang@intel.com>
---
 scripts/basic/fixdep.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
 
diff --git a/scripts/basic/fixdep.c b/scripts/basic/fixdep.c
index cb1f50c..2c065e5 100644
--- a/scripts/basic/fixdep.c
+++ b/scripts/basic/fixdep.c
@@ -377,7 +377,7 @@ static void print_deps(void)
        if (fd < 0) {
                fprintf(stderr, "fixdep: error opening depfile: ");
                perror(depfile);
-               exit(2);
+               return;
        }
        if (fstat(fd, &st) < 0) {
                 fprintf(stderr, "fixdep: error fstat'ing depfile: ");
-- 
1.7.9.5

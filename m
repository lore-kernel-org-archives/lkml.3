Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540AbaCFAiq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 19:38:46 -0500
Received: from mail1.windriver.com ([147.11.146.13]:49472 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757260AbaCFAip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 19:38:45 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-next@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Johannes Thumshirn <johannes.thumshirn@men.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH-next] drivers/mcb: do not set default Kconfig variable to modular
Date: Wed, 5 Mar 2014 19:38:09 -0500
Message-ID: <1394066289-18320-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.9.0
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Coverage builds found this build fail in ARM ebsa110_defconfig:

drivers/mcb/mcb-parse.c: In function 'chameleon_parse_cells':
drivers/mcb/mcb-parse.c:105:2: error: implicit declaration of function 'memcpy_fromio' [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors
make[2]: *** [drivers/mcb/mcb-parse.o] Error 1

A simple bisect will output this:

3764e82e5150d87b205c10cd78a9c9ab86fbfa51 is the first bad commit
commit 3764e82e5150d87b205c10cd78a9c9ab86fbfa51
Author: Johannes Thumshirn <johannes.thumshirn@men.de>
Date:   Wed Feb 26 17:29:05 2014 +0100

    drivers: Introduce MEN Chameleon Bus

The above commit used "default m" which is wrong.  New drivers
should never be globally enabled with "default y/m".  Whether
this driver makes sense to build on ARM is an independent issue.

Here we delete the "default m" line, which is the equivalent of
"default n".

Cc: Johannes Thumshirn <johannes.thumshirn@men.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---

[above commit ID comes from char-misc tree, and will be invalid
 if that content gets rebased... ]

 drivers/mcb/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/mcb/Kconfig b/drivers/mcb/Kconfig
index 44c82d68c563..9ad2f8661487 100644
--- a/drivers/mcb/Kconfig
+++ b/drivers/mcb/Kconfig
@@ -4,7 +4,6 @@
 
 menuconfig MCB
 	   tristate "MCB support"
-	   default m
 	   help
 
 	   The MCB (MEN Chameleon Bus) is a Bus specific to MEN Mikroelektronik
-- 
1.9.0


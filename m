Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967445AbaFTNwb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 09:52:31 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:63737 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965897AbaFTNw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 09:52:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andreas Noever <andreas.noever@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 2/3] thunderbolt: include linux/slab.h for kmalloc
Date: Fri, 20 Jun 2014 15:52:10 +0200
Message-Id: <1403272331-3790755-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1403272331-3790755-1-git-send-email-arnd@arndb.de>
References: <1403272331-3790755-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:HfWj6wIC3A1PCil5wcHipNP8QEaXqGVMom0isPX6qFu
 vbRyw8YoUNL579rvEvIn80iSTxUA8UA9GqaizuxzTIJnmIM5Vf
 VH95zdvyetIYHG0lFdYYwRWDs5+PwtaZ1HQEfqTPoJRg+CvYji
 5vY1UKBxqs4KyN73fUHSxRZ/UyesgGdZMfqRZ1ISjtq+QkvXw7
 edow4zfw6EdbCd3+kbr26DM3DztAhL4fA7Bb5tfwh+BaOV+q4U
 aYUcIFa//s4/LhgpLlb2HXosWhNG+VkmWCuP8egTe51W4DMuRb
 zuwCnSRpQwkXmYmPaOXpa4FnwAc3CQMa/UDnsvTzT7cHAGBulj
 2QFGbrzRHiAsOUgYKgzN7AOb1v2lNtT/mwAbP1jW+
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kmalloc/kzalloc/kfree functions are declared in linux/slab.h,
so we have to explicitly include that header to avoid build failures
on ARM and other architectures that don't include these implicitly
through another header.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/thunderbolt/eeprom.c | 1 +
 drivers/thunderbolt/switch.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/thunderbolt/eeprom.c b/drivers/thunderbolt/eeprom.c
index 0d5a80b..bc0449f 100644
--- a/drivers/thunderbolt/eeprom.c
+++ b/drivers/thunderbolt/eeprom.c
@@ -5,6 +5,7 @@
  */
 
 #include <linux/crc32.h>
+#include <linux/slab.h>
 #include "tb.h"
 
 /**
diff --git a/drivers/thunderbolt/switch.c b/drivers/thunderbolt/switch.c
index 0d50e7e..26e76e4 100644
--- a/drivers/thunderbolt/switch.c
+++ b/drivers/thunderbolt/switch.c
@@ -5,6 +5,7 @@
  */
 
 #include <linux/delay.h>
+#include <linux/slab.h>
 
 #include "tb.h"
 
-- 
1.8.3.2


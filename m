Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965658AbaFTJFo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 05:05:44 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:48701 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964904AbaFTJFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 05:05:43 -0400
From: Sachin Kamat <sachin.kamat@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, andreas.noever@gmail.com, spk.linux@gmail.com
Subject: [PATCH 1/6] thunderbolt: Fix build error in eeprom.c
Date: Fri, 20 Jun 2014 14:32:29 +0530
Message-Id: <1403254954-14429-1-git-send-email-sachin.kamat@samsung.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the below error:
drivers/thunderbolt/eeprom.c:407:2: error: implicit declaration of function ‘kzalloc’ [-Werror=implicit-function-declaration]
drivers/thunderbolt/eeprom.c:444:2: error: implicit declaration of function ‘kfree’ [-Werror=implicit-function-declaration]

Signed-off-by: Sachin Kamat <sachin.kamat@samsung.com>
---
 drivers/thunderbolt/eeprom.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/thunderbolt/eeprom.c b/drivers/thunderbolt/eeprom.c
index 0d5a80b2d07a..bc0449f581c2 100644
--- a/drivers/thunderbolt/eeprom.c
+++ b/drivers/thunderbolt/eeprom.c
@@ -5,6 +5,7 @@
  */
 
 #include <linux/crc32.h>
+#include <linux/slab.h>
 #include "tb.h"
 
 /**
-- 
1.7.9.5


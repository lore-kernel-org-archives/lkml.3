Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966271AbaFTJFu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 05:05:50 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:33085 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964904AbaFTJFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 05:05:47 -0400
From: Sachin Kamat <sachin.kamat@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, andreas.noever@gmail.com, spk.linux@gmail.com
Subject: [PATCH 2/6] thunderbolt: Fix build error in switch.c
Date: Fri, 20 Jun 2014 14:32:30 +0530
Message-Id: <1403254954-14429-2-git-send-email-sachin.kamat@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1403254954-14429-1-git-send-email-sachin.kamat@samsung.com>
References: <1403254954-14429-1-git-send-email-sachin.kamat@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the below error:
drivers/thunderbolt/switch.c:347:2: error: implicit declaration of function ‘kzalloc’ [-Werror=implicit-function-declaration]
drivers/thunderbolt/switch.c:381:2: error: implicit declaration of function ‘kcalloc’ [-Werror=implicit-function-declaration]

Signed-off-by: Sachin Kamat <sachin.kamat@samsung.com>
---
 drivers/thunderbolt/switch.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/thunderbolt/switch.c b/drivers/thunderbolt/switch.c
index 0d50e7e7b29b..26e76e4aa835 100644
--- a/drivers/thunderbolt/switch.c
+++ b/drivers/thunderbolt/switch.c
@@ -5,6 +5,7 @@
  */
 
 #include <linux/delay.h>
+#include <linux/slab.h>
 
 #include "tb.h"
 
-- 
1.7.9.5


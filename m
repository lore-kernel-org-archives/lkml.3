Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758096Ab3DXMqs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 08:46:48 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:46656 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754677Ab3DXMqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 08:46:46 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Karsten Keil <isdn@linux-pingi.de>, Rusty Russell <rusty@rustcorp.com.au>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] isdn/sc: Fix incorrect module_param_array types
Date: Wed, 24 Apr 2013 14:46:37 +0200
Message-Id: <1366807597-24314-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/isdn/sc/init.c: In function ‘__check_irq’:
drivers/isdn/sc/init.c:36: warning: return from incompatible pointer type
drivers/isdn/sc/init.c: In function ‘__check_ram’:
drivers/isdn/sc/init.c:37: warning: return from incompatible pointer type

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/isdn/sc/init.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/isdn/sc/init.c b/drivers/isdn/sc/init.c
index 6b580b2..ca997bd 100644
--- a/drivers/isdn/sc/init.c
+++ b/drivers/isdn/sc/init.c
@@ -33,8 +33,8 @@ static unsigned long ram[] = {0, 0, 0, 0};
 static bool do_reset = 0;
 
 module_param_array(io, int, NULL, 0);
-module_param_array(irq, int, NULL, 0);
-module_param_array(ram, int, NULL, 0);
+module_param_array(irq, byte, NULL, 0);
+module_param_array(ram, long, NULL, 0);
 module_param(do_reset, bool, 0);
 
 static int identify_board(unsigned long, unsigned int);
-- 
1.7.0.4


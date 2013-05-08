Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757816Ab3EHUXw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 16:23:52 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:41965 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757419Ab3EHUXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 16:23:51 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-media@vger.kernel.org
Subject: [PATCH 1/2] [media] v4l2: SI476X MFD - Do not use binary constants
Date: Wed,  8 May 2013 22:23:41 +0200
Message-Id: <1368044622-25645-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gcc < 4.3 doesn't understand binary constanrs (0b*):

drivers/media/radio/radio-si476x.c:862:20: error: invalid suffix "b10000000" on integer constant

Hence use a hexadecimal constant (0x*) instead.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
---
 drivers/media/radio/radio-si476x.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/radio/radio-si476x.c b/drivers/media/radio/radio-si476x.c
index 9430c6a..9dc8baf 100644
--- a/drivers/media/radio/radio-si476x.c
+++ b/drivers/media/radio/radio-si476x.c
@@ -44,7 +44,7 @@
 
 #define FREQ_MUL (10000000 / 625)
 
-#define SI476X_PHDIV_STATUS_LINK_LOCKED(status) (0b10000000 & (status))
+#define SI476X_PHDIV_STATUS_LINK_LOCKED(status) (0x80 & (status))
 
 #define DRIVER_NAME "si476x-radio"
 #define DRIVER_CARD "SI476x AM/FM Receiver"
-- 
1.7.0.4


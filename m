Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760977Ab3DBHhU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 03:37:20 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47835 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891Ab3DBHhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 03:37:18 -0400
From: Richard Weinberger <richard@nod.at>
To: sfr@canb.auug.org.au
Cc: greg@kroah.com, arnd@arndb.de, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>
Subject: [PATCH] cs5535-mfgpt: Fix quotation marks
Date: Tue,  2 Apr 2013 09:37:09 +0200
Message-Id: <1364888229-27714-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <20130402181728.1c3f92fc8727a39e1145c688@canb.auug.org.au>
References: <20130402181728.1c3f92fc8727a39e1145c688@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit "cs5535-mfgpt: Add another reset method" introduced an unterminated
string and broke the build.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/misc/cs5535-mfgpt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/cs5535-mfgpt.c b/drivers/misc/cs5535-mfgpt.c
index 6bdb3ba..effd8c6 100644
--- a/drivers/misc/cs5535-mfgpt.c
+++ b/drivers/misc/cs5535-mfgpt.c
@@ -27,8 +27,8 @@ module_param_named(mfgptfix, mfgpt_reset_timers, int, 0644);
 MODULE_PARM_DESC(mfgptfix, "Try to reset the MFGPT timers during init; "
 		"required by some broken BIOSes (ie, TinyBIOS < 0.99) or kexec "
 		"(1 = reset the MFGPT using an undocumented bit, "
-		"2 = perform a soft reset by unconfiguring all timers);
-		use what works best for you.");
+		"2 = perform a soft reset by unconfiguring all timers); "
+		"use what works best for you.");
 
 struct cs5535_mfgpt_timer {
 	struct cs5535_mfgpt_chip *chip;
-- 
1.8.1.4


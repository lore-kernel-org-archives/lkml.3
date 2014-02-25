Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312AbaBYPrK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 10:47:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18254 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752634AbaBYPrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 10:47:09 -0500
From: Adam Jackson <ajax@redhat.com>
To: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Peter Jones <pjones@redhat.com>
Subject: [PATCH] i8042: Don't print an error message just because there's no chip
Date: Tue, 25 Feb 2014 10:47:07 -0500
Message-Id: <1393343227-13092-1-git-send-email-ajax@redhat.com>
In-Reply-To: <1222713404-1097-1-git-send-email-ajax@redhat.com>
References: <1222713404-1097-1-git-send-email-ajax@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Jones <pjones@redhat.com>

Some systems, such as EFI-based Apple systems, won't necessarily have an
i8042 to initialize. We shouldn't be printing an error message in this
case, since not detecting the chip is the correct behavior.

v2: Downgrade to pr_notice instead of pr_err.

Signed-off-by: Adam Jackson <ajax@redhat.com>
---
 drivers/input/serio/i8042.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/serio/i8042.c b/drivers/input/serio/i8042.c
index 020053f..05c6285 100644
--- a/drivers/input/serio/i8042.c
+++ b/drivers/input/serio/i8042.c
@@ -855,7 +855,7 @@ static int __init i8042_check_aux(void)
 static int i8042_controller_check(void)
 {
 	if (i8042_flush()) {
-		pr_err("No controller found\n");
+		pr_notice("No controller found\n");
 		return -ENODEV;
 	}
 
-- 
1.8.5.3


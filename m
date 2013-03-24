Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797Ab3CXUaM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 16:30:12 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43118 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754722Ab3CXUaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 16:30:11 -0400
From: Paolo Pisati <paolo.pisati@canonical.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Russell King <linux@arm.linux.org.uk>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Will Deacon <will.deacon@arm.com>, Jason Cooper <jason@lakedaemon.net>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        Paolo Pisati <paolo.pisati@canonical.com>
Subject: [PATCH 7/7] ARM: l2x0: don't set .set_debug in l310 case
Date: Sun, 24 Mar 2013 21:29:45 +0100
Message-Id: <1364156985-20264-1-git-send-email-paolo.pisati@canonical.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364149654-16163-1-git-send-email-p.pisati@gmail.com>
References: <1364149654-16163-1-git-send-email-p.pisati@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 74ddcdb ("l2x0: Only set .set_debug on PL310 r3p0 and earlier")
to actually work needs .set_debug to be not set during definition

Signed-off-by: Paolo Pisati <paolo.pisati@canonical.com>
---
 arch/arm/mm/cache-l2x0.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/mm/cache-l2x0.c b/arch/arm/mm/cache-l2x0.c
index d457653..37f1364 100644
--- a/arch/arm/mm/cache-l2x0.c
+++ b/arch/arm/mm/cache-l2x0.c
@@ -724,7 +724,6 @@ static const struct l2x0_of_data pl310_data = {
 		.flush_all   = l2x0_flush_all,
 		.inv_all     = l2x0_inv_all,
 		.disable     = l2x0_disable,
-		.set_debug   = pl310_set_debug,
 	},
 };
 
-- 
1.7.10.4


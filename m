Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014AbaGWMwi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 08:52:38 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:18673 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123AbaGWMwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 08:52:37 -0400
From: Sasha Levin <sasha.levin@oracle.com>
To: geert@linux-m68k.org
Cc: rostedt@goodmis.org, gnomes@lxorguk.ukuu.org.uk, linux@roeck-us.net,
        xerofoify@gmail.com, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH] m68k/q40: Revert "m68k/q40: Fix q40_irq_startup() to return -ENXIO on failures"
Date: Wed, 23 Jul 2014 08:51:39 -0400
Message-Id: <1406119899-22659-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.9.1
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Revert since we're trying to return -ENXIO from a function returning
unsigned int. Not only it causes compiler warnings it's also obviously
incorrect.

In general, watch for patches from Nick Krause since they are not even
build tested.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/q40/q40ints.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/m68k/q40/q40ints.c b/arch/m68k/q40/q40ints.c
index 9dfa1ea..513f9bb 100644
--- a/arch/m68k/q40/q40ints.c
+++ b/arch/m68k/q40/q40ints.c
@@ -49,7 +49,7 @@ static unsigned int q40_irq_startup(struct irq_data *data)
 	case 1: case 2: case 8: case 9:
 	case 11: case 12: case 13:
 		printk("%s: ISA IRQ %d not implemented by HW\n", __func__, irq);
-		return -ENXIO;
+		/* FIXME return -ENXIO; */
 	}
 	return 0;
 }
-- 
1.9.1


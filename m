Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751349AbaHUCLk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 22:11:40 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:59089 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbaHUCLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 22:11:39 -0400
Message-ID: <1408587094.10818.1.camel@phoenix>
Subject: [PATCH] regulator: core: Add back the const qualifier for ops of
 struct regulator_desc
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 21 Aug 2014 10:11:34 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix below build warning:
CC [M]  drivers/regulator/hi6421-regulator.o
drivers/regulator/hi6421-regulator.c:356:2: warning: initialization discards 'const' qualifier from pointer target type [enabled by default]

This is a revert of commit 716845ebeb50 ("regulator: core: Fix build error due
to const qualifier for ops"). The build error was fixed by commit 39f5460d7f9c
("regulator: core: add const to regulator_ops and fix build error in mc13892").

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 include/linux/regulator/driver.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index 3abda75..efe058f 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -246,7 +246,7 @@ struct regulator_desc {
 	int id;
 	bool continuous_voltage_range;
 	unsigned n_voltages;
-	struct regulator_ops *ops;
+	const struct regulator_ops *ops;
 	int irq;
 	enum regulator_type type;
 	struct module *owner;
-- 
1.9.1




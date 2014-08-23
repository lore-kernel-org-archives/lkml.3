Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824AbaHWLZd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 07:25:33 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:1746 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752479AbaHWLY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 07:24:58 -0400
X-IronPort-AV: E=Sophos;i="5.04,386,1406584800"; 
   d="scan'208";a="90829918"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: josh@joshtriplett.org, kernel-janitors@vger.kernel.org,
        linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/9] pwm: lpss: use c99 initializers in structures
Date: Sat, 23 Aug 2014 13:20:25 +0200
Message-Id: <1408792831-25615-4-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1408792831-25615-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1408792831-25615-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Use c99 initializers for structures.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@decl@
identifier i1,fld;
type T;
field list[n] fs;
@@

struct i1 {
 fs
 T fld;
 ...};

@bad@
identifier decl.i1,i2;
expression e;
initializer list[decl.n] is;
@@

struct i1 i2 = { is,
+ .fld = e
- e
 ,...};
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
The patches in this series do not depend on each other.

 drivers/pwm/pwm-lpss.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pwm/pwm-lpss.c b/drivers/pwm/pwm-lpss.c
index 4df994f..441a046 100644
--- a/drivers/pwm/pwm-lpss.c
+++ b/drivers/pwm/pwm-lpss.c
@@ -45,7 +45,7 @@ struct pwm_lpss_boardinfo {
 
 /* BayTrail */
 static const struct pwm_lpss_boardinfo byt_info = {
-	25000000
+	.clk_rate = 25000000
 };
 
 static inline struct pwm_lpss_chip *to_lpwm(struct pwm_chip *chip)


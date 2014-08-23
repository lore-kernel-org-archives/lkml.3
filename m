Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467AbaHWLY4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 07:24:56 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:21752 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751812AbaHWLYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 07:24:54 -0400
X-IronPort-AV: E=Sophos;i="5.04,386,1406584800"; 
   d="scan'208";a="90829916"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: josh@joshtriplett.org, kernel-janitors@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/9] [media] v4l: ti-vpe: use c99 initializers in structures
Date: Sat, 23 Aug 2014 13:20:23 +0200
Message-Id: <1408792831-25615-2-git-send-email-Julia.Lawall@lip6.fr>
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

Not compiled.

 drivers/media/platform/ti-vpe/vpe.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index 972f43f..20dd7ea 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -138,12 +138,12 @@ struct vpe_dei_regs {
  * default expert DEI register values, unlikely to be modified.
  */
 static const struct vpe_dei_regs dei_regs = {
-	0x020C0804u,
-	0x0118100Fu,
-	0x08040200u,
-	0x1010100Cu,
-	0x10101010u,
-	0x10101010u,
+	.mdt_spacial_freq_thr_reg = 0x020C0804u,
+	.edi_config_reg = 0x0118100Fu,
+	.edi_lut_reg0 = 0x08040200u,
+	.edi_lut_reg1 = 0x1010100Cu,
+	.edi_lut_reg2 = 0x10101010u,
+	.edi_lut_reg3 = 0x10101010u,
 };
 
 /*


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549Ab3LBUXH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:23:07 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39087 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604Ab3LBTRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:17:08 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nishanth Menon <nm@ti.com>, Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.12 031/212] regulator: ti-abb: Fix operator precedence typo
Date: Mon,  2 Dec 2013 11:13:42 -0800
Message-Id: <20131202191252.039245052@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nishanth Menon <nm@ti.com>

commit 9a633a2bced158c57b73cf4d8e87be60473de1d2 upstream.

commit 40b1936e (regulator: Introduce TI Adaptive Body Bias(ABB) on-chip
LDO driver) missed a pair of brackets which cause the wrong vset data to be
picked up from efuse, resulting in bad VBB voltage values.

Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/regulator/ti-abb-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/regulator/ti-abb-regulator.c
+++ b/drivers/regulator/ti-abb-regulator.c
@@ -615,7 +615,7 @@ static int ti_abb_init_table(struct devi
 					pname, *volt_table, vset_mask);
 			continue;
 		}
-		info->vset = efuse_val & vset_mask >> __ffs(vset_mask);
+		info->vset = (efuse_val & vset_mask) >> __ffs(vset_mask);
 		dev_dbg(dev, "[%d]v=%d vset=%x\n", i, *volt_table, info->vset);
 check_abb:
 		switch (info->opp_sel) {



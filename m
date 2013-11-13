Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758847Ab3KMLdH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 06:33:07 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:49736 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755687Ab3KMLdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 06:33:05 -0500
Date: Wed, 13 Nov 2013 12:33:00 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Mark Brown <broonie@kernel.org>
cc: linux-kernel@vger.kernel.org, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] regulator: fixed: fix regulator_list_voltage() for regression
Message-ID: <Pine.LNX.4.64.1311131228030.18879@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:C3/CU+zFXAN5bcrYzSBL0iHNZrwGqCgVxhB2z2kMKaQ
 Yhd2XOBrP6BzMtQesf1h//0lM//DS8/OOEEM+yiklfQzznzfgy
 SDRilgYJILRcqHOfJ89LAGZar+5CSooCC6COcFsI+JnzwVUYaj
 Z8rId/XsjGzMyb7i5ASykzPMX/aaprtHDqffpD9rXr3CMQ8/Kv
 lqdZLY+nR+mo4U5XHn8i8QMx95vhXrqVnx5bF7YfeKgdr3SXwQ
 NmrvG2rDOaDi1LYGdpSsaZ9W63qTJXALORVyBK5vNuMotjr6pK
 fmTo3iSGYwendwpDt9MgaJR0jnjpDRKPzsWfBbrRaH3nddNC60
 Nod3MGNKcJvveHu3h46FpArf6jLLzexp/TK0ixJ8+A8iufH/am
 U04PqSNy71JeQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit c368e5fc2a190923b786f2de3e79430ea3566a25 "regulator: fixed:
get rid of {get|list}_voltage()" broke regulator_list_voltage() for
the fixed regulator, because an earlier commit
5a523605afa7d3b54b2e7041f8c9e6bc39872a7e "regulator: core: provide
fixed voltage in desc for single voltage rail" missed to add support
for the fixed-voltage special case to that function. This patch
fixes that regression.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/regulator/core.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 6382f0a..3fe1313 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2184,6 +2184,9 @@ int regulator_list_voltage(struct regulator *regulator, unsigned selector)
 	struct regulator_ops	*ops = rdev->desc->ops;
 	int			ret;
 
+	if (rdev->desc->fixed_uV && rdev->desc->n_voltages == 1 && !selector)
+		return rdev->desc->fixed_uV;
+
 	if (!ops->list_voltage || selector >= rdev->desc->n_voltages)
 		return -EINVAL;
 
-- 
1.7.2.5


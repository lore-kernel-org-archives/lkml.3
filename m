Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959Ab3ENHAP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 03:00:15 -0400
Received: from eu1sys200aog121.obsmtp.com ([207.126.144.151]:46442 "EHLO
	eu1sys200aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751662Ab3ENHAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 03:00:14 -0400
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
To: broonie@kernel.org
Cc: srinivas.kandagatla@st.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v1] regmap: debugfs: Fix return from regmap_debugfs_get_dump_start
Date: Tue, 14 May 2013 07:54:23 +0100
Message-Id: <1368514463-4035-1-git-send-email-srinivas.kandagatla@st.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@st.com>

regmap_debugfs_get_dump_start should return the offset of the register
it should start reading from, However in the current code at one point
the code does not return correct register offset.

With this patch all the returns from this function takes reg_stride in
to consideration to return correct offset.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
---
 drivers/base/regmap/regmap-debugfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index 23b701f..2ec4dad 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -145,7 +145,7 @@ static unsigned int regmap_debugfs_get_dump_start(struct regmap *map,
 			reg_offset = fpos_offset / map->debugfs_tot_len;
 			*pos = c->min + (reg_offset * map->debugfs_tot_len);
 			mutex_unlock(&map->cache_lock);
-			return c->base_reg + reg_offset;
+			return c->base_reg + (reg_offset * map->reg_stride);
 		}
 
 		*pos = c->max;
-- 
1.7.6.5


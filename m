Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754Ab3LNN6e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 08:58:34 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:56114 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122Ab3LNN6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 08:58:32 -0500
Date: Sat, 14 Dec 2013 19:28:24 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Doug Thompson <dougthompson@xmission.com>, Borislav Petkov <bp@alien8.de>,
        linux-edac@vger.kernel.org, josh@joshtriplett.org
Subject: [PATCH 1/3] drivers: edac: Mark the function
 amd64_decode_bus_error() as static in amd64_edac.c
Message-ID: <7cddbd4c69ed493f183383e98853181aaf75b26b.1387029387.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch marks the function amd64_decode_bus_error() as static in
amd64_edac.c because it is not used outside this file.

Thus, it also eliminates the following warning in amd64_edac.c:
drivers/edac/amd64_edac.c:2038:6: warning: no previous prototype for ‘amd64_decode_bus_error’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
---
 drivers/edac/amd64_edac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index b53d0de..52b34ea 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2035,7 +2035,7 @@ static inline void __amd64_decode_bus_error(struct mem_ctl_info *mci,
 	__log_bus_error(mci, &err, ecc_type);
 }
 
-void amd64_decode_bus_error(int node_id, struct mce *m)
+static void amd64_decode_bus_error(int node_id, struct mce *m)
 {
 	__amd64_decode_bus_error(mcis[node_id], m);
 }
-- 
1.7.9.5


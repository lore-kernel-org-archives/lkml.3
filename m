Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871Ab3LNOCT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 09:02:19 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:33693 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500Ab3LNOCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 09:02:18 -0500
Date: Sat, 14 Dec 2013 19:32:09 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Doug Thompson <dougthompson@xmission.com>, linux-edac@vger.kernel.org,
        josh@joshtriplett.org
Subject: [PATCH 3/3] drivers: edac: Mark the function get_mci_for_node_id()
 as static in sb_edac.c
Message-ID: <0441f508186fc4eeabc8e9c3e4dde013d99405d4.1387029387.git.rashika.kheria@gmail.com>
References: <7cddbd4c69ed493f183383e98853181aaf75b26b.1387029387.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7cddbd4c69ed493f183383e98853181aaf75b26b.1387029387.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch marks the function get_mci_for_node_id() as static in
sb_edac.c because it is not used outside this file.

Thus, it also eliminates the following warning in sb_edac.c:
drivers/edac/sb_edac.c:918:22: warning: no previous prototype for ‘get_mci_for_node_id’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
---
 drivers/edac/sb_edac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index 8472405..a8845a3 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -915,7 +915,7 @@ static void get_memory_layout(const struct mem_ctl_info *mci)
 	}
 }
 
-struct mem_ctl_info *get_mci_for_node_id(u8 node_id)
+static struct mem_ctl_info *get_mci_for_node_id(u8 node_id)
 {
 	struct sbridge_dev *sbridge_dev;
 
-- 
1.7.9.5


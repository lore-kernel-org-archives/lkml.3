Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537Ab3CNK5V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:57:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51843 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757008Ab3CNKhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:37:20 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Asias He <asias@redhat.com>, Nicholas Bellinger <nab@linux-iscsi.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 30/88] target/pscsi: Fix page increment
Date: Thu, 14 Mar 2013 10:35:23 +0000
Message-Id: <1363257381-15900-31-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
References: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Asias He <asias@redhat.com>

commit 472b72f2db7831d7dbe22ffdff4adee3bd49b05d upstream.

The page++ is wrong. It makes bio_add_pc_page() pointing to a wrong page
address if the 'while (len > 0 && data_len > 0) { ... }' loop is
executed more than one once.

Signed-off-by: Asias He <asias@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/target/target_core_pscsi.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 4ce2cf6..1835d84 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -1000,7 +1000,6 @@ static int pscsi_map_sg(struct se_cmd *cmd, struct scatterlist *sgl,
 				bio = NULL;
 			}
 
-			page++;
 			len -= bytes;
 			data_len -= bytes;
 			off = 0;
-- 
1.8.1.2


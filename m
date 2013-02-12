Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760378Ab3BLEMQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 23:12:16 -0500
Received: from mail-we0-f180.google.com ([74.125.82.180]:44620 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932981Ab3BLEL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 23:11:56 -0500
From: Cyril Roelandt <tipecaml@gmail.com>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Cc: Cyril Roelandt <tipecaml@gmail.com>, konrad.wilk@oracle.com,
        jeremy@goop.org, xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 5/5] xen: remove redundant NULL check before unregister_and_remove_pcpu().
Date: Tue, 12 Feb 2013 05:01:53 +0100
Message-Id: <1360641713-24895-6-git-send-email-tipecaml@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360641713-24895-1-git-send-email-tipecaml@gmail.com>
References: <1360641713-24895-1-git-send-email-tipecaml@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

unregister_and_remove_pcpu on a NULL pointer is a no-op, so the NULL check in
sync_pcpu can be removed.

Signed-off-by: Cyril Roelandt <tipecaml@gmail.com>
---
 drivers/xen/pcpu.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/xen/pcpu.c b/drivers/xen/pcpu.c
index 067fcfa..5a27a45 100644
--- a/drivers/xen/pcpu.c
+++ b/drivers/xen/pcpu.c
@@ -278,8 +278,7 @@ static int sync_pcpu(uint32_t cpu, uint32_t *max_cpu)
 	 * Only those at cpu present map has its sys interface.
 	 */
 	if (info->flags & XEN_PCPU_FLAGS_INVALID) {
-		if (pcpu)
-			unregister_and_remove_pcpu(pcpu);
+		unregister_and_remove_pcpu(pcpu);
 		return 0;
 	}
 
-- 
1.7.10.4


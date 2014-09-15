Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757843AbaIOWQl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:16:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50958 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754881AbaIOWQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:16:34 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andrey Utkin <andrey.krieger.utkin@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 150/187] powerpc/mm/numa: Fix break placement
Date: Mon, 15 Sep 2014 15:09:20 -0700
Message-Id: <1410818997-9432-151-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrey Utkin <andrey.krieger.utkin@gmail.com>

commit b00fc6ec1f24f9d7af9b8988b6a198186eb3408c upstream.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=81631
Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/powerpc/mm/numa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
index 6847d50..c752d50 100644
--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -588,8 +588,8 @@ static int cpu_numa_callback(struct notifier_block *nfb, unsigned long action,
 	case CPU_UP_CANCELED:
 	case CPU_UP_CANCELED_FROZEN:
 		unmap_cpu_from_node(lcpu);
-		break;
 		ret = NOTIFY_OK;
+		break;
 #endif
 	}
 	return ret;
-- 
1.9.1


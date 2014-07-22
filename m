Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933822AbaGVW46 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:56:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44379 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932233AbaGVWWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:22:36 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Gavin Shan <gwshan@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 010/116] powerpc/pseries: Fix overwritten PE state
Date: Tue, 22 Jul 2014 15:20:21 -0700
Message-Id: <1406067727-19683-11-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406067727-19683-1-git-send-email-kamal@canonical.com>
References: <1406067727-19683-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gavin Shan <gwshan@linux.vnet.ibm.com>

commit 54f112a3837d4e7532bbedbbbf27c0de277be510 upstream.

In pseries_eeh_get_state(), EEH_STATE_UNAVAILABLE is always
overwritten by EEH_STATE_NOT_SUPPORT because of the missed
"break" there. The patch fixes the issue.

Reported-by: Joe Perches <joe@perches.com>
Signed-off-by: Gavin Shan <gwshan@linux.vnet.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/powerpc/platforms/pseries/eeh_pseries.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/platforms/pseries/eeh_pseries.c b/arch/powerpc/platforms/pseries/eeh_pseries.c
index b456b15..68f97d5 100644
--- a/arch/powerpc/platforms/pseries/eeh_pseries.c
+++ b/arch/powerpc/platforms/pseries/eeh_pseries.c
@@ -400,6 +400,7 @@ static int pseries_eeh_get_state(struct eeh_pe *pe, int *state)
 			} else {
 				result = EEH_STATE_NOT_SUPPORT;
 			}
+			break;
 		default:
 			result = EEH_STATE_NOT_SUPPORT;
 		}
-- 
1.9.1


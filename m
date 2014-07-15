Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933855AbaGOW1j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 18:27:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53906 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756391AbaGOVb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:31:26 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Gavin Shan <gwshan@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 019/198] powerpc/pseries: Fix overwritten PE state
Date: Tue, 15 Jul 2014 14:28:09 -0700
Message-Id: <1405459868-15089-20-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405459868-15089-1-git-send-email-kamal@canonical.com>
References: <1405459868-15089-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.

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
index ccb633e..c4e1d42 100644
--- a/arch/powerpc/platforms/pseries/eeh_pseries.c
+++ b/arch/powerpc/platforms/pseries/eeh_pseries.c
@@ -464,6 +464,7 @@ static int pseries_eeh_get_state(struct eeh_pe *pe, int *state)
 			} else {
 				result = EEH_STATE_NOT_SUPPORT;
 			}
+			break;
 		default:
 			result = EEH_STATE_NOT_SUPPORT;
 		}
-- 
1.9.1


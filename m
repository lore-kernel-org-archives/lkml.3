Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758020AbaGCJVM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:21:12 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51406 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756020AbaGCJVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:21:03 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Gavin Shan <gwshan@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 010/198] powerpc/pseries: Fix overwritten PE state
Date: Thu,  3 Jul 2014 10:17:33 +0100
Message-Id: <1404379241-8590-11-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gavin Shan <gwshan@linux.vnet.ibm.com>

commit 54f112a3837d4e7532bbedbbbf27c0de277be510 upstream.

In pseries_eeh_get_state(), EEH_STATE_UNAVAILABLE is always
overwritten by EEH_STATE_NOT_SUPPORT because of the missed
"break" there. The patch fixes the issue.

Reported-by: Joe Perches <joe@perches.com>
Signed-off-by: Gavin Shan <gwshan@linux.vnet.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/powerpc/platforms/pseries/eeh_pseries.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/platforms/pseries/eeh_pseries.c b/arch/powerpc/platforms/pseries/eeh_pseries.c
index 7fbc25b1813f..74448701b636 100644
--- a/arch/powerpc/platforms/pseries/eeh_pseries.c
+++ b/arch/powerpc/platforms/pseries/eeh_pseries.c
@@ -461,6 +461,7 @@ static int pseries_eeh_get_state(struct eeh_pe *pe, int *state)
 			} else {
 				result = EEH_STATE_NOT_SUPPORT;
 			}
+			break;
 		default:
 			result = EEH_STATE_NOT_SUPPORT;
 		}
-- 
1.9.1


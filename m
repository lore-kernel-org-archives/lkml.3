Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965410AbaGRNDU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:03:20 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17227 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755456AbaGRNDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:03:16 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Gavin Shan <gwshan@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 039/170] powerpc/pseries: Fix overwritten PE state
Date: Fri, 18 Jul 2014 14:10:44 +0200
Message-Id: <a27d1641371ea6599a7ff6cba8373d567a02ecb6.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gavin Shan <gwshan@linux.vnet.ibm.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 54f112a3837d4e7532bbedbbbf27c0de277be510 upstream.

In pseries_eeh_get_state(), EEH_STATE_UNAVAILABLE is always
overwritten by EEH_STATE_NOT_SUPPORT because of the missed
"break" there. The patch fixes the issue.

Reported-by: Joe Perches <joe@perches.com>
Signed-off-by: Gavin Shan <gwshan@linux.vnet.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
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
2.0.0


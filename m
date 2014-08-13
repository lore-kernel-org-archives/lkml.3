Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180AbaHMJSy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 05:18:54 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:55454 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbaHMJSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 05:18:52 -0400
Date: Wed, 13 Aug 2014 14:48:47 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: enjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH] powerpc/pseries: Drop unnecessary continue
Message-ID: <20140813091847.GA3078@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Continue is not needed at the bottom of a loop.

The Coccinelle semantic patch implementing this change is:

@@
@@

for (...;...;...) {
  ...
  if (...) {
    ...
-   continue;
  }
}

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
Not compile tested.
 arch/powerpc/platforms/pseries/cmm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/powerpc/platforms/pseries/cmm.c b/arch/powerpc/platforms/pseries/cmm.c
index 2d8bf15..fc44ad0 100644
--- a/arch/powerpc/platforms/pseries/cmm.c
+++ b/arch/powerpc/platforms/pseries/cmm.c
@@ -555,7 +555,6 @@ static int cmm_mem_going_offline(void *arg)
 				pa_last = pa_last->next;
 				free_page((unsigned long)cmm_page_list);
 				cmm_page_list = pa_last;
-				continue;
 			}
 		}
 		pa_curr = pa_curr->next;
-- 
1.9.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757660Ab3BEW2z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:28:55 -0500
Received: from relay2.sgi.com ([192.48.179.30]:50297 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757410Ab3BEW0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:26:50 -0500
Message-Id: <20130205222648.951508678@gulag1.americas.sgi.com>
User-Agent: quilt/0.47-1
Date: Tue, 05 Feb 2013 16:26:53 -0600
From: Mike Travis <travis@sgi.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Russ Anderson <rja@sgi.com>
Subject: [PATCH 5/7] x86, UV: UV3 Update Time Support
References: <20130205222648.204965172@gulag1.americas.sgi.com>
Content-Disposition: inline; filename=uv3-update-time-support.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	This patch updates time support for the SGI UV3 hub.

Signed-off-by: Mike Travis <travis@sgi.com>
Acked-by: Russ Anderson <rja@sgi.com>
Reviewed-by: Dimitri Sivanich <sivanich@sgi.com>
---
 arch/x86/platform/uv/uv_time.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- linux.orig/arch/x86/platform/uv/uv_time.c
+++ linux/arch/x86/platform/uv/uv_time.c
@@ -15,7 +15,7 @@
  *  along with this program; if not, write to the Free Software
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
  *
- *  Copyright (c) 2009 Silicon Graphics, Inc.  All Rights Reserved.
+ *  Copyright (c) 2009-2013 Silicon Graphics, Inc.  All Rights Reserved.
  *  Copyright (c) Dimitri Sivanich
  */
 #include <linux/clockchips.h>
@@ -102,9 +102,10 @@ static int uv_intr_pending(int pnode)
 	if (is_uv1_hub())
 		return uv_read_global_mmr64(pnode, UVH_EVENT_OCCURRED0) &
 			UV1H_EVENT_OCCURRED0_RTC1_MASK;
-	else
-		return uv_read_global_mmr64(pnode, UV2H_EVENT_OCCURRED2) &
-			UV2H_EVENT_OCCURRED2_RTC_1_MASK;
+	else if (is_uvx_hub())
+		return uv_read_global_mmr64(pnode, UVXH_EVENT_OCCURRED2) &
+			UVXH_EVENT_OCCURRED2_RTC_1_MASK;
+	return 0;
 }
 
 /* Setup interrupt and return non-zero if early expiration occurred. */
@@ -122,8 +123,8 @@ static int uv_setup_intr(int cpu, u64 ex
 		uv_write_global_mmr64(pnode, UVH_EVENT_OCCURRED0_ALIAS,
 				UV1H_EVENT_OCCURRED0_RTC1_MASK);
 	else
-		uv_write_global_mmr64(pnode, UV2H_EVENT_OCCURRED2_ALIAS,
-				UV2H_EVENT_OCCURRED2_RTC_1_MASK);
+		uv_write_global_mmr64(pnode, UVXH_EVENT_OCCURRED2_ALIAS,
+				UVXH_EVENT_OCCURRED2_RTC_1_MASK);
 
 	val = (X86_PLATFORM_IPI_VECTOR << UVH_RTC1_INT_CONFIG_VECTOR_SHFT) |
 		((u64)apicid << UVH_RTC1_INT_CONFIG_APIC_ID_SHFT);


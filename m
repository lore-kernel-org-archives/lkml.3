Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933638AbbA1B4z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 20:56:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41426 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933269AbbA1Bi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:38:26 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Anton Kolesov <akolesov@synopsys.com>,
        Vineet Gupta <vgupta@synopsys.com>
Subject: [PATCH 3.14 41/77] ARC: Fix build breakage for !CONFIG_ARC_DW2_UNWIND
Date: Tue, 27 Jan 2015 17:27:19 -0800
Message-Id: <20150128012747.191645131@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150128012745.971137091@linuxfoundation.org>
References: <20150128012745.971137091@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vineet Gupta <vgupta@synopsys.com>

commit ba25915fb2cd18152cb14b144dbe8bf2f2bd8e45 upstream.

Fixes: ec7ac6afd07b (ARC: switch to generic ENTRY/END assembler annotations)
Reported-by: Anton Kolesov <akolesov@synopsys.com>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arc/kernel/ctx_sw_asm.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arc/kernel/ctx_sw_asm.S
+++ b/arch/arc/kernel/ctx_sw_asm.S
@@ -10,9 +10,9 @@
  *  -This is the more "natural" hand written assembler
  */
 
+#include <linux/linkage.h>
 #include <asm/entry.h>       /* For the SAVE_* macros */
 #include <asm/asm-offsets.h>
-#include <asm/linkage.h>
 
 #define KSP_WORD_OFF 	((TASK_THREAD + THREAD_KSP) / 4)
 



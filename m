Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965102AbaKLBmV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:42:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60235 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965078AbaKLBmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:42:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vineet Gupta <vgupta@synopsys.com>
Subject: [PATCH 3.14 089/203] ARC: fix mmuv2 warning
Date: Wed, 12 Nov 2014 10:15:59 +0900
Message-Id: <20141112011546.770261562@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011542.686743533@linuxfoundation.org>
References: <20141112011542.686743533@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vineet Gupta <vgupta@synopsys.com>

commit d75386363ee60eb51c933c7b5e536f3a502ad7d7 upstream.

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arc/mm/cache_arc700.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/arc/mm/cache_arc700.c
+++ b/arch/arc/mm/cache_arc700.c
@@ -253,12 +253,16 @@ static inline void __cache_line_loop(uns
 
 	if (cacheop == OP_INV_IC) {
 		aux_cmd = ARC_REG_IC_IVIL;
+#if (CONFIG_ARC_MMU_VER > 2)
 		aux_tag = ARC_REG_IC_PTAG;
+#endif
 	}
 	else {
 		/* d$ cmd: INV (discard or wback-n-discard) OR FLUSH (wback) */
 		aux_cmd = cacheop & OP_INV ? ARC_REG_DC_IVDL : ARC_REG_DC_FLDL;
+#if (CONFIG_ARC_MMU_VER > 2)
 		aux_tag = ARC_REG_DC_PTAG;
+#endif
 	}
 
 	/* Ensure we properly floor/ceil the non-line aligned/sized requests



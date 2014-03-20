Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759870AbaCTUgu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 16:36:50 -0400
Received: from relay3.sgi.com ([192.48.152.1]:58188 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759512AbaCTUgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 16:36:48 -0400
Date: Thu, 20 Mar 2014 15:36:46 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Ingo Molnar <mingo@redhat.com>
Subject: [PATCH] x86/UV: Fix conditional in gru_exit
Message-ID: <20140320203646.GA603@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix conditional in gru_exit to match gru_init.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
---
 drivers/misc/sgi-gru/grufile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/misc/sgi-gru/grufile.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grufile.c
+++ linux/drivers/misc/sgi-gru/grufile.c
@@ -573,7 +573,7 @@ exit0:
 
 static void __exit gru_exit(void)
 {
-	if (!is_uv_system())
+	if (!is_uv_system() || (is_uvx_hub() && !is_uv2_hub()))
 		return;
 
 	gru_teardown_tlb_irqs();

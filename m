Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965911Ab3GSF2v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 01:28:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40062 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965494Ab3GSF1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 01:27:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 67/72] ARM: mm: fix boot on SA1110 Assabet
Date: Thu, 18 Jul 2013 22:26:24 -0700
Message-Id: <20130719052604.444270826@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20130719052559.852627424@linuxfoundation.org>
References: <20130719052559.852627424@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King <rmk+kernel@arm.linux.org.uk>

commit 319e0b4f02f73983c03a2ca38595fc6367929edf upstream.

Commit 83db0384 (mm/ARM: use common help functions to free reserved
pages) broke booting on the Assabet by trying to convert a PFN to
a virtual address using the __va() macro.  This macro takes the
physical address, not a PFN.  Fix this.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mm/init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -600,7 +600,7 @@ void __init mem_init(void)
 
 #ifdef CONFIG_SA1111
 	/* now that our DMA memory is actually so designated, we can free it */
-	free_reserved_area(__va(PHYS_PFN_OFFSET), swapper_pg_dir, 0, NULL);
+	free_reserved_area(__va(PHYS_OFFSET), swapper_pg_dir, 0, NULL);
 #endif
 
 	free_highpages();



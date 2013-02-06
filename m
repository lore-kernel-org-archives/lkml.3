Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866Ab3BFIT4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 03:19:56 -0500
Received: from ozlabs.org ([203.10.76.45]:34897 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751700Ab3BFIT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 03:19:27 -0500
From: Michael Ellerman <michael@ellerman.id.au>
To: <penberg@kernel.org>
Cc: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/6] kvm tools: powerpc: Only emit TB freq if it's non-zero
Date: Wed,  6 Feb 2013 19:19:16 +1100
Message-Id: <1360138756-1991-6-git-send-email-michael@ellerman.id.au>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360138756-1991-1-git-send-email-michael@ellerman.id.au>
References: <1360138756-1991-1-git-send-email-michael@ellerman.id.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel can handle a missing timebase-frequency property much better
than one that claims zero.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
---
 tools/kvm/powerpc/kvm.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/kvm/powerpc/kvm.c b/tools/kvm/powerpc/kvm.c
index dc9f89d..b4b9f82 100644
--- a/tools/kvm/powerpc/kvm.c
+++ b/tools/kvm/powerpc/kvm.c
@@ -389,7 +389,9 @@ static int setup_fdt(struct kvm *kvm)
 		_FDT(fdt_property_cell(fdt, "dcache-block-size", cpu_info->d_bsize));
 		_FDT(fdt_property_cell(fdt, "icache-block-size", cpu_info->i_bsize));
 
-		_FDT(fdt_property_cell(fdt, "timebase-frequency", cpu_info->tb_freq));
+		if (cpu_info->tb_freq)
+			_FDT(fdt_property_cell(fdt, "timebase-frequency", cpu_info->tb_freq));
+
 		/* Lies, but safeish lies! */
 		_FDT(fdt_property_cell(fdt, "clock-frequency", 0xddbab200));
 
-- 
1.7.10.4


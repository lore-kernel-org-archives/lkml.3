Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441Ab3EMWWv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 18:22:51 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:35203 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754413Ab3EMWWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 18:22:50 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Fedora Kernel Team <kernel-team@fedoraproject.org>,
        Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH] intel_iommu: Downgrade the warning if enabling irq remapping fails
Date: Mon, 13 May 2013 15:22:42 -0700
Message-Id: <cae6129769f80ed16f30118dc19ff10ba5d63fde.1368483649.git.luto@amacapital.net>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <20130513220444.GA22440@redhat.com>
References: <20130513220444.GA22440@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This triggers on a MacBook Pro.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
https://bugzilla.redhat.com/show_bug.cgi?id=948262
---
 drivers/iommu/intel_irq_remapping.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index f3b8f23..a7e0ad1 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -654,8 +654,7 @@ error:
 	 */
 
 	if (x2apic_present)
-		WARN(1, KERN_WARNING
-			"Failed to enable irq remapping.  You are vulnerable to irq-injection attacks.\n");
+		pr_warn("Failed to enable irq remapping.  You are vulnerable to irq-injection attacks.\n");
 
 	return -1;
 }
-- 
1.8.1.4


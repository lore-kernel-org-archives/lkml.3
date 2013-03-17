Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147Ab3CQJtJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 05:49:09 -0400
Received: from mail-qe0-f48.google.com ([209.85.128.48]:55003 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227Ab3CQJtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 05:49:05 -0400
Message-ID: <51459188.7000104@opello.org>
Date: Sun, 17 Mar 2013 04:48:56 -0500
From: Dan Christensen <opello@opello.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: monstr@monstr.eu
CC: microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org
Subject: [PATCH] microblaze: intc: set the default irq_domain
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register the irq_domain created during initialization as the default so
that device drivers can pass NULL to irq_create_mapping and get a
virtual irq to pass to request_irq.

Signed-off-by: Dan Christensen <opello@opello.org>
---
 arch/microblaze/kernel/intc.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/microblaze/kernel/intc.c b/arch/microblaze/kernel/intc.c
index 8778adf..d85fa3a 100644
--- a/arch/microblaze/kernel/intc.c
+++ b/arch/microblaze/kernel/intc.c
@@ -172,4 +172,6 @@ void __init init_IRQ(void)
 	 * and commits this patch.  ~~gcl */
 	root_domain = irq_domain_add_linear(intc, nr_irq, &xintc_irq_domain_ops,
 							(void *)intr_mask);
+
+	irq_set_default_host(root_domain);
 }
-- 
1.7.0.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759816Ab3CZOl1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 10:41:27 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:13114 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933984Ab3CZOlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 10:41:25 -0400
X-IronPort-AV: E=Sophos;i="4.84,911,1355097600"; 
   d="scan'208";a="14895950"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <Stefano.Stabellini@eu.citrix.com>, <konrad.wilk@oracle.com>,
        <Ian.Campbell@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v2 1/6] xen/arm: actually pass a non-NULL percpu pointer to request_percpu_irq
Date: Tue, 26 Mar 2013 14:41:10 +0000
Message-ID: <1364308875-26484-1-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1303261423530.4430@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1303261423530.4430@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/arm/xen/enlighten.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
index 8dc0605..99ce189 100644
--- a/arch/arm/xen/enlighten.c
+++ b/arch/arm/xen/enlighten.c
@@ -239,7 +239,7 @@ static int __init xen_init_events(void)
 	xen_init_IRQ();
 
 	if (request_percpu_irq(xen_events_irq, xen_arm_callback,
-			"events", xen_vcpu)) {
+			"events", &xen_vcpu)) {
 		pr_err("Error requesting IRQ %d\n", xen_events_irq);
 		return -EINVAL;
 	}
-- 
1.7.2.5


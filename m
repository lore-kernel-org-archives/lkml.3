Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757679Ab3DXTo7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 15:44:59 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:49782 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757438Ab3DXToa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 15:44:30 -0400
X-IronPort-AV: E=Sophos;i="4.87,545,1363132800"; 
   d="scan'208";a="20369899"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <Stefano.Stabellini@eu.citrix.com>, <konrad.wilk@oracle.com>,
        <Ian.Campbell@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v4 1/7] xen/arm: actually pass a non-NULL percpu pointer to request_percpu_irq
Date: Wed, 24 Apr 2013 20:28:09 +0100
Message-ID: <1366831695-13214-1-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1304242012590.4180@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1304242012590.4180@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: stable@vger.kernel.org
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


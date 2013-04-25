Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932655Ab3DYQ6I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 12:58:08 -0400
Received: from smtp.citrix.com ([66.165.176.89]:28628 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932087Ab3DYQ6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 12:58:05 -0400
X-IronPort-AV: E=Sophos;i="4.87,551,1363132800"; 
   d="scan'208";a="21599744"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <Stefano.Stabellini@eu.citrix.com>, <konrad.wilk@oracle.com>,
        <Ian.Campbell@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v5 1/7] xen/arm: actually pass a non-NULL percpu pointer to request_percpu_irq
Date: Thu, 25 Apr 2013 17:57:49 +0100
Message-ID: <1366909075-28775-1-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1304251750160.4180@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1304251750160.4180@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Reviewed-by: Ian Campbell <ian.camjpbell@citrix.com>
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


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526Ab3CUTQl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 15:16:41 -0400
Received: from smtp.citrix.com ([66.165.176.89]:53415 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752033Ab3CUTQ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 15:16:29 -0400
X-IronPort-AV: E=Sophos;i="4.84,888,1355097600"; 
   d="scan'208";a="14783238"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <Stefano.Stabellini@eu.citrix.com>, <konrad.wilk@oracle.com>,
        <Ian.Campbell@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <rob.herring@calxeda.com>, <will.deacon@arm.com>,
        <marc.zyngier@arm.com>, <arnd@arndb.de>
Subject: [PATCH 4/4] xenvm: add a simple PSCI node and a second cpu
Date: Thu, 21 Mar 2013 19:16:20 +0000
Message-ID: <1363893380-14309-4-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1303211848150.5135@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1303211848150.5135@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: rob.herring@calxeda.com
CC: will.deacon@arm.com
CC: marc.zyngier@arm.com
CC: arnd@arndb.de
---
 arch/arm/boot/dts/xenvm-4.2.dts |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/xenvm-4.2.dts b/arch/arm/boot/dts/xenvm-4.2.dts
index 7a2cf30..66efd22 100644
--- a/arch/arm/boot/dts/xenvm-4.2.dts
+++ b/arch/arm/boot/dts/xenvm-4.2.dts
@@ -29,6 +29,18 @@
 			compatible = "arm,cortex-a15";
 			reg = <0>;
 		};
+
+		cpu@1 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a15";
+			reg = <1>;
+		};
+	};
+
+	psci {
+		compatible      = "arm,psci";
+		method          = "hvc";
+		cpu_on          = <2>;
 	};
 
 	memory@80000000 {
-- 
1.7.2.5


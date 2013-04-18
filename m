Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967350Ab3DROvM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 10:51:12 -0400
Received: from smtp.citrix.com ([66.165.176.89]:25995 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966941Ab3DROvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 10:51:07 -0400
X-IronPort-AV: E=Sophos;i="4.87,502,1363132800"; 
   d="scan'208";a="20206185"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <Stefano.Stabellini@eu.citrix.com>, <konrad.wilk@oracle.com>,
        <Ian.Campbell@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <rob.herring@calxeda.com>, <will.deacon@arm.com>, <arnd@arndb.de>
Subject: [PATCH v3 5/5] xenvm: add a simple PSCI node and a second cpu
Date: Thu, 18 Apr 2013 15:50:46 +0100
Message-ID: <1366296646-12215-5-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1304181538160.7254@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1304181538160.7254@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
CC: rob.herring@calxeda.com
CC: will.deacon@arm.com
CC: arnd@arndb.de
---
 arch/arm/boot/dts/xenvm-4.2.dts |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/xenvm-4.2.dts b/arch/arm/boot/dts/xenvm-4.2.dts
index ec3f952..9441156 100644
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


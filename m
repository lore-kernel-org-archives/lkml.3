Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932674Ab3DYQ6J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 12:58:09 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:17806 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932607Ab3DYQ6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 12:58:06 -0400
X-IronPort-AV: E=Sophos;i="4.87,551,1363132800"; 
   d="scan'208";a="20573175"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <Stefano.Stabellini@eu.citrix.com>, <konrad.wilk@oracle.com>,
        <Ian.Campbell@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <rob.herring@calxeda.com>, <will.deacon@arm.com>, <arnd@arndb.de>
Subject: [PATCH v5 6/7] xenvm: add a simple PSCI node and a second cpu
Date: Thu, 25 Apr 2013 17:57:54 +0100
Message-ID: <1366909075-28775-6-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1304251750160.4180@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1304251750160.4180@kaball.uk.xensource.com>
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
 arch/arm/boot/dts/xenvm-4.2.dts |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/xenvm-4.2.dts b/arch/arm/boot/dts/xenvm-4.2.dts
index ec3f952..3369151 100644
--- a/arch/arm/boot/dts/xenvm-4.2.dts
+++ b/arch/arm/boot/dts/xenvm-4.2.dts
@@ -29,6 +29,19 @@
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
+		cpu_off         = <1>;
+		cpu_on          = <2>;
 	};
 
 	memory@80000000 {
-- 
1.7.2.5


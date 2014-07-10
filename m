Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875AbaGJK1e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 06:27:34 -0400
Received: from rslrsmtp2.opaltelecom.net ([62.24.128.202]:11041 "EHLO
	iprslrsmtp2msp.cpwnetworks.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750966AbaGJK1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 06:27:33 -0400
X-Greylist: delayed 640 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Jul 2014 06:27:32 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsgEAMBmvlM+GID9/2dsb2JhbABZhymtAo8sh1GBIXWELVY1AiYCLjEBEohGrkqZLheBLI4Ygn6BTAWiD4RBiEWDRA
X-IPAS-Result: AsgEAMBmvlM+GID9/2dsb2JhbABZhymtAo8sh1GBIXWELVY1AiYCLjEBEohGrkqZLheBLI4Ygn6BTAWiD4RBiEWDRA
X-IronPort-AV: E=Sophos;i="5.01,637,1400022000"; 
   d="scan'208";a="481251859"
Message-ID: <1404987355.23201.65.camel@samson1.armitage.org.uk>
Subject: [PATCH] cpufreq: kirkwood: Reinstate cpufreq driver for
 ARCH_KIRKWOOD
From: Quentin Armitage <quentin@armitage.org.uk>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>
Date: Thu, 10 Jul 2014 11:15:55 +0100
Organization: The Armitage family
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit ff1f0018cf66080d8e6f59791e552615648a033a ("drivers: Enable
building of Kirkwood drivers for mach-mvebu") added Kirkwood into
mach-mvebu, adding MACH_KIRKWOOD to ARCH_KIRKWOOD in the KConfig files.

The change for ARM_KIRKWOOD_CPUFREQ replaced ARCH_KIRKWOOD with
MACH_KIRKWOOD, whereas all the other changes were ARCH_KIRKWOOD ||
MACH_KIRKWOOD.

As a consequence of this change, the cpufreq driver is no longer enabled
for ARCH_KIRKWOOD. This patch reinstates ARM_KIRKWOOD_CPUFREQ for
ARCH_KIRKWOOD.

Signed-off-by: Quentin Armitage <quentin@armitage.org.uk>
---
diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
index ebac671..24778f0 100644
--- a/drivers/cpufreq/Kconfig.arm
+++ b/drivers/cpufreq/Kconfig.arm
@@ -118,7 +118,7 @@ config ARM_INTEGRATOR
          If in doubt, say Y.

 config ARM_KIRKWOOD_CPUFREQ
-       def_bool MACH_KIRKWOOD
+       def_bool ARCH_KIRKWOOD || MACH_KIRKWOOD
        help
          This adds the CPUFreq driver for Marvell Kirkwood
          SoCs.
 






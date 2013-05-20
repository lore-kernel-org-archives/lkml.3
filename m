Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246Ab3ETIy7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 04:54:59 -0400
Received: from intranet.asianux.com ([58.214.24.6]:50087 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab3ETIy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 04:54:57 -0400
X-Spam-Score: -100.8
Message-ID: <5199E4AF.7040607@asianux.com>
Date: Mon, 20 May 2013 16:54:07 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: ben-linux@fluff.org, "kgene.kim@samsung.com" <kgene.kim@samsung.com>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org >> \"linux-kernel@vger.kernel.org\"" 
	<linux-kernel@vger.kernel.org>
Subject: [PATCH] ARM: S5PV210: dependency issue, S5P_SLEEP is depend on ARM_CPU_SUSPEND
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When randconfig with MMU for arm s5pv210 (and select all cpu type),
need let S5P_SLEEP depend on ARM_CPU_SUSPEND, or will cause issue below:

  arch/arm/plat-samsung/built-in.o: In function `s3c_cpu_resume':
  arch/arm/plat-samsung/s5p-sleep.S:83: undefined reference to `cpu_resume'


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/arm/plat-samsung/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/plat-samsung/Kconfig b/arch/arm/plat-samsung/Kconfig
index f8ed2de..1d38541 100644
--- a/arch/arm/plat-samsung/Kconfig
+++ b/arch/arm/plat-samsung/Kconfig
@@ -483,6 +483,7 @@ config S5P_PM
 
 config S5P_SLEEP
 	bool
+	select ARM_CPU_SUSPEND
 	help
 	  Internal config node to apply common S5P sleep management code.
 	  Can be selected by S5P and newer SoCs with similar sleep procedure.
-- 
1.7.7.6

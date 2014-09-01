Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320AbaIAO6k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 10:58:40 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:45763 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272AbaIAO6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 10:58:39 -0400
From: Hanjun Guo <hanjun.guo@linaro.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <mark.rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>
Cc: Graeme Gregory <graeme.gregory@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Will Deacon <will.deacon@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Robert Richter <rric@kernel.org>, Lv Zheng <lv.zheng@intel.com>,
        Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>, Charles.Garcia-Tobin@arm.com,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org,
        Hanjun Guo <hanjun.guo@linaro.org>
Subject: [PATCH v3 01/17] ARM64: Move the init of cpu_logical_map(0) before unflatten_device_tree()
Date: Mon,  1 Sep 2014 22:57:39 +0800
Message-Id: <1409583475-6978-2-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1409583475-6978-1-git-send-email-hanjun.guo@linaro.org>
References: <1409583475-6978-1-git-send-email-hanjun.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It always make sense to initialize CPU0's logical map entry from the
hardware values, so move the initialization of cpu_logical_map(0)
before unflatten_device_tree() which is needed by ACPI code later.

Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
---
 arch/arm64/kernel/setup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index f6f0ccf..c96172a 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -390,11 +390,11 @@ void __init setup_arch(char **cmdline_p)
 
 	efi_idmap_init();
 
+	cpu_logical_map(0) = read_cpuid_mpidr() & MPIDR_HWID_BITMASK;
 	unflatten_device_tree();
 
 	psci_init();
 
-	cpu_logical_map(0) = read_cpuid_mpidr() & MPIDR_HWID_BITMASK;
 	cpu_read_bootcpu_ops();
 #ifdef CONFIG_SMP
 	smp_init_cpus();
-- 
1.7.9.5


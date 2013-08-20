Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892Ab3HTJeh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 05:34:37 -0400
Received: from service87.mimecast.com ([91.220.42.44]:34485 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021Ab3HTJaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 05:30:14 -0400
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: Sudeep.KarkadaNagesha@arm.com, Viresh Kumar <viresh.kumar@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jonas Bonn <jonas@southpole.se>, Michal Simek <monstr@monstr.eu>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH v4 05/19] ARM: DT/kernel: define ARM specific arch_match_cpu_phys_id
Date: Tue, 20 Aug 2013 10:30:07 +0100
Message-Id: <1376991021-12160-6-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376991021-12160-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
References: <1374492747-13879-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
 <1376991021-12160-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-OriginalArrivalTime: 20 Aug 2013 09:30:10.0927 (UTC) FILETIME=[DDE56FF0:01CE9D87]
X-MC-Unique: 113082010301202701
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r7K9YgVF012337

From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>

OF/DT core library now provides architecture specific hook to match the
logical cpu index with the corresponding physical identifier. Most of the
cpu DT node parsing and initialisation is contained in devtree.c. So it's
better to define ARM specific arch_match_cpu_phys_id there.

This mainly helps to avoid replication of the code doing CPU node parsing
and physical(MPIDR) to logical mapping.

Cc: Russell King <linux@arm.linux.org.uk>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Acked-by: Rob Herring <rob.herring@calxeda.com>
Acked-by: Nicolas Pitre <nico@linaro.org>
Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
---
 arch/arm/kernel/devtree.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/kernel/devtree.c b/arch/arm/kernel/devtree.c
index 5859c8b..2ee8a17 100644
--- a/arch/arm/kernel/devtree.c
+++ b/arch/arm/kernel/devtree.c
@@ -169,6 +169,11 @@ void __init arm_dt_init_cpu_maps(void)
 	}
 }
 
+bool arch_match_cpu_phys_id(int cpu, u64 phys_id)
+{
+	return (phys_id & MPIDR_HWID_BITMASK) == cpu_logical_map(cpu);
+}
+
 /**
  * setup_machine_fdt - Machine setup when an dtb was passed to the kernel
  * @dt_phys: physical address of dt blob
-- 
1.8.1.2



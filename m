Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932AbaF0Dwu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 23:52:50 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:34251 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905AbaF0Dwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 23:52:47 -0400
From: Hanjun Guo <hanjun.guo@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Bjorn Helgaas <bhelgaas@google.com>, rric@kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Charles.Garcia-Tobin@arm.com,
        lorenzo.pieralisi@arm.com, linaro-acpi@lists.linaro.org,
        Al Stone <al.stone@linaro.org>, Hanjun Guo <hanjun.guo@linaro.org>
Subject: [PATCH v4 11/13] ARM64 / ACPI: Select ACPI_REDUCED_HARDWARE_ONLY if ACPI is enabled on ARM64
Date: Fri, 27 Jun 2014 11:49:34 +0800
Message-Id: <1403840976-7456-12-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1403840976-7456-1-git-send-email-hanjun.guo@linaro.org>
References: <1403840976-7456-1-git-send-email-hanjun.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Stone <al.stone@linaro.org>

ACPI reduced hardware mode is disabled by default, but ARM64
can only run properly in ACPI hardware reduced mode, so select
ACPI_REDUCED_HARDWARE_ONLY if ACPI is enabled on ARM64.

Reviewed-by: Grant Likely <grant.likely@linaro.org>
Signed-off-by: Al Stone <al.stone@linaro.org>
Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
---
 arch/arm64/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index db5190a..102384e 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1,5 +1,6 @@
 config ARM64
 	def_bool y
+	select ACPI_REDUCED_HARDWARE_ONLY if ACPI
 	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 	select ARCH_USE_CMPXCHG_LOCKREF
 	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
-- 
1.7.9.5


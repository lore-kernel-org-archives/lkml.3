Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127Ab3LBJe1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 04:34:27 -0500
Received: from exprod5og110.obsmtp.com ([64.18.0.20]:49731 "HELO
	exprod5og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753001Ab3LBJeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 04:34:25 -0500
From: Vinayak Kale <vkale@apm.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: tglx@linutronix.de, will.deacon@arm.com, patches@apm.com, jcm@redhat.com,
        sboyd@codeaurora.org, marc.zyngier@arm.com,
        Vinayak Kale <vkale@apm.com>
Subject: [PATCH V6 0/2] genirq: arm64: perf: support for percpu pmu interrupt
Date: Mon,  2 Dec 2013 15:04:01 +0530
Message-Id: <1385976843-13280-1-git-send-email-vkale@apm.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds support to handle interrupt registration/deregistration
in arm64 pmu driver when pmu interrupt type is percpu.

Changelog:
V6:
* In arm64 pmu driver: Use macro 'IRQ_TYPE_NONE' while passing irq type value
  to enable_percpu_irq(). Change 'irqs' etc variables as unsigned, modify the
  check for 'irqs' inside armpmu_[release/reserve]_hardware().

V5:
* In irqdesc.h: Added Chris Smith's sign-off.
  In arm64 pmu driver: Handle the invalid irq-0 case for platform_get_irq().

V4:
* In arm64 pmu driver: Avoid using irq_to_desc() to check validity of irq.

V3:
* Remove validity check for 'desc' from accessor function in irqdesc.h .
  Instead, check the irq 'desc' validity in arm64 pmu driver.

V2:
* To determine whether an IRQ is percpu or not, added an accessor function in
  irqdesc.h . This approach was used by Chris Smith here[1] for similar changes
  in arm pmu driver.
* In arm64 pmu driver: Got rid of unnecessary pointer typecastings.

[1] http://lkml.indiana.edu/hypermail/linux/kernel/1207.3/02955.html

Vinayak Kale (2):
  genirq: Add an accessor for IRQ_PER_CPU flag
  arm64: perf: add support for percpu pmu interrupt

 arch/arm64/kernel/perf_event.c |  116 +++++++++++++++++++++++++++++-----------
 include/linux/irqdesc.h        |    8 +++
 2 files changed, 94 insertions(+), 30 deletions(-)

-- 
1.7.9.5


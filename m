Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168Ab3KYJqW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 04:46:22 -0500
Received: from exprod5og103.obsmtp.com ([64.18.0.145]:39323 "HELO
	exprod5og103.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751627Ab3KYJqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 04:46:16 -0500
From: Vinayak Kale <vkale@apm.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: tglx@linutronix.de, will.deacon@arm.com, patches@apm.com, jcm@redhat.com,
        sboyd@codeaurora.org, marc.zyngier@arm.com,
        Vinayak Kale <vkale@apm.com>
Subject: [PATCH V5 0/2] genirq: arm64: perf: support for percpu pmu interrupt
Date: Mon, 25 Nov 2013 15:15:51 +0530
Message-Id: <1385372753-7396-1-git-send-email-vkale@apm.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds support to handle interrupt registration/deregistration
in arm64 pmu driver when pmu interrupt type is percpu.

Changelog:
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

 arch/arm64/kernel/perf_event.c |  108 ++++++++++++++++++++++++++++++----------
 include/linux/irqdesc.h        |    8 +++
 2 files changed, 89 insertions(+), 27 deletions(-)

-- 
1.7.9.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751322AbaDUBYH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 21:24:07 -0400
Received: from mga03.intel.com ([143.182.124.21]:39922 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098AbaDUBYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 21:24:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,894,1389772800"; 
   d="scan'208";a="421363970"
From: Jason Chen <jason.cj.chen@intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Jason Chen <jason.cj.chen@intel.com>
Subject: [RFC PATCH 0/1] add apic_irqs bitmap to identify irqs from apic
Date: Mon, 21 Apr 2014 09:18:26 +0800
Message-Id: <cover.1397838739.git.jason.cj.chen@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During irq migration, irq_force_complete_move() will consider all irqs coming from apic kind of
irq chip, but they may also coming from other irq chip, such kind of irqs should be filtered out.

Jason Chen (1):
  x86/apic: add apic_irqs bitmap to identify irqs from apic

 arch/x86/kernel/apic/io_apic.c | 21 ++++++++++++++++++++-
 include/linux/irqdesc.h        |  6 ++++++
 kernel/irq/internals.h         |  6 ------
 3 files changed, 26 insertions(+), 7 deletions(-)

-- 
1.8.1.2


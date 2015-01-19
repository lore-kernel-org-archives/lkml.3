Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531AbbASOT1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 09:19:27 -0500
Received: from mga03.intel.com ([134.134.136.65]:56351 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317AbbASOT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 09:19:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,427,1418112000"; 
   d="scan'208";a="514300743"
Message-ID: <54BD1256.1020406@linux.intel.com>
Date: Mon, 19 Jan 2015 22:19:02 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Marc Zyngier <marc.zyngier@arm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Proposal about reorganize struct irq_data and struct irq_desc
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas and Marc,
	During working on the generic MSI support, I have some proposal
about reorganizing struct irq_data and struct irq_desc. The proposed
changes are:
1) Add a pointer "struct irq_desc *" to struct irq_data, so we could
   quickly get struct irq_desc from struct irq_data.
2) Move "node" from struct irq_data into struct irq_desc, NUMA info
   should be per-irq instead of per-chip.
3) Move "affinity" from struct irq_data into struct irq_desc, NUMA info
   should be per-irq instead of per-chip.
4) Move "msi_desc" from struct irq_data into struct irq_desc. (Not sure
   whether we should do this. Theoretically we should use
   irq_data->handler_data to store msi_desc.)

With above change applied, struct irq_data only hosts per-chip data, and
struct irq_desc hosts per-irq data. What's your thoughts?
Regards,
Gerry

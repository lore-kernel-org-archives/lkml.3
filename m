Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758798AbaLKTsY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 14:48:24 -0500
Received: from www.linutronix.de ([62.245.132.108]:59677 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758750AbaLKTsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 14:48:23 -0500
Message-Id: <20141211191853.613107396@linutronix.de>
User-Agent: quilt/0.63-1
Date: Thu, 11 Dec 2014 19:48:07 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, x86@kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Borislav Petkov <bp@alien8.de>, Yinghai Lu <yinghai@kernel.org>
Subject: [patch 0/4] x86: Fix the ACPI resource handling and range checking
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai noticed that Jiangs changes broke the resource range checks. I
picked up his patch and addressed a few other things:

   - Ignoring the IORESOURCE_DISABLED flag
   - Range checking of IO resources against iomem_resource

There is more cleanup work to do in that area, but thats for later.

Please review and test ride it, so we can get x86/apic out of blocked
state.

Thanks,

	tglx
---
 arch/x86/pci/acpi.c   |  111 +++++++++++++++++++++++++++-----------------------
 drivers/acpi/ioapic.c |   38 +++++++++--------
 2 files changed, 83 insertions(+), 66 deletions(-)



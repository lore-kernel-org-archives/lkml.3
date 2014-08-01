Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829AbaHAK4W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 06:56:22 -0400
Received: from mail.skyhub.de ([78.46.96.112]:38299 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754086AbaHAK4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 06:56:20 -0400
Date: Fri, 1 Aug 2014 12:56:18 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-pci@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, irq: Keep IRQ assignment for PCI devices during
 suspend/hibernation, bisected
Message-ID: <20140801105618.GA3857@nazgul.tnic>
References: <20140730175836.GC10213@pd.tnic>
 <1406766807-5745-1-git-send-email-jiang.liu@linux.intel.com>
 <20140731103941.GA4375@pd.tnic>
 <53DA70AB.9010906@linux.intel.com>
 <20140731165648.GG4375@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140731165648.GG4375@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok,

so I went and looked at tip and which branches could be the usual
suspects. And whaddya know, tip/x86/apic was the first to pick and it
contained the culprit:

6a38fa0e3c94 ("x86, irq, ACPI: Release IOAPIC pin when PCI device is disabled")

It seems like my machine doesn't like releasing the IOAPIC pin. Or,
maybe it is IOMMU-related and the IOMMU doesn't like this releasing of
the pin *after* the device gets suspended and *before* the IOMMU.

Strange.

Oh well, a well deserved lunch now :)

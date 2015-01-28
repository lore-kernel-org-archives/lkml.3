Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718AbbA2BYu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:24:50 -0500
Received: from mail-oi0-f48.google.com ([209.85.218.48]:59885 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177AbbA2BYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:24:47 -0500
Date: Wed, 28 Jan 2015 17:38:34 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Lv Zheng <lv.zheng@intel.com>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Len Brown <lenb@kernel.org>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [Patch v2 20/22] x86/PCI: Refine the way to release PCI IRQ
 resources
Message-ID: <20150128233834.GF17623@google.com>
References: <1422442660-455-1-git-send-email-jiang.liu@linux.intel.com>
 <1422442660-455-21-git-send-email-jiang.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422442660-455-21-git-send-email-jiang.liu@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 06:57:38PM +0800, Jiang Liu wrote:
> Some PCI device drivers assume that pci_dev->irq won't change after
> calling pci_disable_device() and pci_enable_device() during suspend and
> resume.
> 
> Commit c03b3b0738a56cf283b0d05256988d5e3c8bd719 ("x86, irq, mpparse:

Cosmetic: please use the conventional 12-char SHA1 as you did below.

> Release IOAPIC pin when PCI device is disabled") frees PCI IRQ
> resources when pci_disable_device() is called and reallocate IRQ
> resources when pci_enable_device() is called again. This breaks
> above assumption. So commit 3eec595235c1 ("x86, irq, PCI: Keep IRQ
> assignment for PCI devices during suspend/hibernation") and
> 9eabc99a635a ("x86, irq, PCI: Keep IRQ assignment for runtime power
> management") fix the issue by avoiding freeing/reallocating IRQ
> resources during PCI device suspend/resume. They achieve this by
> checking dev.power.is_prepared and dev.power.runtime_status.
> PM maintainer, Rafael, then pointed out that it's really an ugly fix
> which leaking PM internal state information to IRQ subsystem.

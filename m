Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388AbaKTVyA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 16:54:00 -0500
Received: from mail-ig0-f169.google.com ([209.85.213.169]:36597 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757334AbaKTVx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 16:53:56 -0500
Date: Thu, 20 Nov 2014 14:53:53 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Yijing Wang <wangyijing@huawei.com>, Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-pci@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: Removal of bus->msi assignment breaks MSI with stacked domains
Message-ID: <20141120215353.GA7987@google.com>
References: <546E1771.4030201@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546E1771.4030201@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 04:31:45PM +0000, Marc Zyngier wrote:
> Bjorn, Yijing,
> 
> I've just realized that patch c167caf8d174 (PCI/MSI: Remove useless
> bus->msi assignment) completely breaks MSI on arm64 when using the new
> MSI stacked domain:
> 
> This patch relies on architectures to implement either
> pcibios_msi_controller() or arch_setup_msi_irq(). It turns out that with
> stacked domains, none of this is actually necessary, as long as you can
> access to the msi_controller.
> 
> And everything was fine until this patch came around (and managed to
> test on a system where the PCI devices are not directly attached to the
> root bus). Of course, everything now breaks, as we cannot get to the MSI
> controller (which contains the domain we allocate the MSIs from).
> 
> In short, this patch breaks an important feature on which arm64 relies,
> and I believe this patch should be reverted ASAP.

I'm happy to revert it from pci/msi, but I think Thomas has already pulled
it into his branch, so he'd have to drop it, too.

Thomas, let me know if you want to do that.  I suppose we could add a new
patch to add it back, but that would leave bisection broken for the
interval between c167caf8d174 and the patch that adds it back.

Bjorn

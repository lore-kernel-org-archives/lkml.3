Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693AbaJLUkk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 16:40:40 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52919 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107AbaJLUkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 16:40:35 -0400
Date: Sun, 12 Oct 2014 22:40:32 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Wilmer van der Gaast <wilmer@gaast.net>, bhelgaas@google.com
Cc: rafael.j.wysocki@intel.com, linux-kernel@vger.kernel.org
Subject: Re: Machine crashes right *after* ~successful resume
Message-ID: <20141012204032.GA11171@amd>
References: <54347520.3050109@gaast.net>
 <20141012143025.GA378@amd>
 <543AA2FE.20105@gaast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <543AA2FE.20105@gaast.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn, any ideas?

Would it be feasible to revert 2e8b... to see if it fixes it on 3.17?

Thanks,
									Pavel

On Sun 2014-10-12 16:49:18, Wilmer van der Gaast wrote:
> Hello,
> 
> Many thanks for your response!
> 
> On 12-10-14 15:30, Pavel Machek wrote:
> >
> >Has it ever worked ok? ...aha, in 3.10, ok.
> >
> Correct. And I've tried a few more kernels now, compiled on my own. 3.17
> still has this issue, 3.10 is completely fine all the way up to 3.10.57
> (I've tested just under 50 cycles last night). 3.11 I tried but it seems to
> have other suspend-resume stability issues not present anymore in later
> kernels, I've mostly not used those results.
> 
> git bisect: I've finally succeeded! I've tried automating it completely, but
> sadly Gigabyte couldn't be bothered wiring up the motherboard to make the
> watchdog work. :-(
> 
> The culprit appears to be this one: 2e8b5f621dbe29425906852c6079afb6b28720cb
> 
> Merge: 07f2daa fed2451
> Author: Bjorn Helgaas <bhelgaas@google.com>
> Date:   Wed Aug 28 20:55:41 2013 -0600
> 
>     Merge branch 'pci/misc' into next
> 
>     * pci/misc:
>       PCI: Remove pcie_cap_has_devctl()
>       PCI: Support PCIe Capability Slot registers only for ports with slots
>       PCI: Remove PCIe Capability version checks
>       PCI: Allow PCIe Capability link-related register access for switches
>       PCI: Add offsets of PCIe capability registers
>       PCI: Tidy bitmasks and spacing of PCIe capability definitions
>       PCI: Remove obsolete comment reference to pci_pcie_cap2()
>       PCI: Clarify PCI_EXP_TYPE_PCI_BRIDGE comment
>       PCI: Rename PCIe capability definitions to follow convention
>       PCI: Disable decoding for BAR sizing only when it was actually enabled
>       PCI: Add comment about needing pci_msi_off() even when
> CONFIG_PCI_MSI=n
>       PCI: Add pcibios_pm_ops for optional arch-specific hibernate
> functionality
> 
> I've then tried to narrow down which of the merged changes is my issue but
> with no luck, possibly because there's a problem with a combination of one
> of these changes, and a change that was not in the pci/misc branch at the
> time. I could do a manual test instead.
> 
> >>I've already tried to skip the NVidia + VMware modules at boot time (as you
> >>can see from the logs they're not loaded at any point), but it didn't help.
> >>I could try omitting more modules.
> >Yes, try with minimal modules (and no s2ram) would be nice.
> >									
> I've tried unloading a bunch of modules (sound and NIC IIRC), same results.
> I can try this again with an even more minimal set. If this improves the
> situation, I'll post again.
> 
> 
> Wilmer van der Gaast.
> 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960AbaBNWWj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 17:22:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22879 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752712AbaBNWWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 17:22:37 -0500
Message-ID: <1392416555.15608.430.camel@ul30vt.home>
Subject: Re: [PATCH v2 0/3] Quirk Intel PCH root ports for ACS-like features
From: Alex Williamson <alex.williamson@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Don Dugger <donald.d.dugger@intel.com>
Date: Fri, 14 Feb 2014 15:22:35 -0700
In-Reply-To: <CAErSpo5D55RcaSASGrU8hEcg+BYvGKOQHFjor8k1gSzfZKWy2g@mail.gmail.com>
References: <20140203212216.8607.68273.stgit@bling.home>
	 <CAErSpo5D55RcaSASGrU8hEcg+BYvGKOQHFjor8k1gSzfZKWy2g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-02-14 at 14:43 -0700, Bjorn Helgaas wrote:
> [+cc Don]
> 
> On Mon, Feb 03, 2014 at 02:27:27PM -0700, Alex Williamson wrote:
> > v2:
> >  - Remove bus #0 bug in filtering matching
> >  - Add 2/3 introducing PCI_DEV_FLAGS_ACS_ENABLED_QUIRK, this gives
> >    is better tracking and addresses the theoretical hotplug issue
> >  - Update 3/3 for PCI_DEV_FLAGS_ACS_ENABLED_QUIRK
> >  - Add dev_info to print regardless of whether we changes bits
> >  - Add Intel cc
> >
> > As described in 3/3 many Intel root ports lack PCIe ACS capabilities
> > which results in excessively large IOMMU groups.  Many of these root
> > ports do provide isolation capabilities, we just need to use device
> > specific mechanisms to enable and verify.  Long term, I hope we can
> > round out this list (particularly to include X79 root ports) and
> > more importantly, encourage proper PCIe ACS support in future
> > products.  I'm really hoping we can get this in during the 3.14 cycle.
> > Thanks,
> >
> > Alex
> > ---
> >
> > Alex Williamson (3):
> >       pci: Add device specific PCI ACS enable
> >       pci: Add pci_dev_flag for ACS enable quirks
> >       pci/quirks: Enable quirks for PCIe ACS on Intel PCH root ports
> 
> I applied these (with Don's ack for 3/3) to pci/virtualization.
> 
> I tried to figure out how to handle post-merge window patches.  Per
> Documentation/development-process/2.Process, "[after -rc1], only patches
> which fix problems should be submitted to the mainline," so one might
> conclude that a fix for any sort of problem is allowed.  However,
> Documentation/networking/netdev-FAQ.txt says "No new features get mainlined
> after this [-rc1] -- only fixes to the rc1 content are expected," which is
> how I've been operating.
> 
> In any case, these patches look more like new functionality (enabling a
> non-standard ACS feature) than a bug fix to me, so my preference is to
> merge them during the v3.15 merge window.
> 
> I understand the desire for v3.14, namely, "lots of Intel devices don't
> support ACS, and that makes it hard for users to expose devices to
> userspace with fine granularity, and waiting for v3.15 will mean another
> two months."  But this problem is really of Intel's own making: if they'd
> used standard ACS, or if they'd documented their non-standard mechanism,
> this wouldn't be an issue.

I appreciate you taking the time to consider it for 3.14.  I'll look
forward to it appearing in linux-next for 3.15.  Thanks for review and
applying,

Alex


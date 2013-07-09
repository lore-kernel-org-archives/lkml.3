Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826Ab3GIOWM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 10:22:12 -0400
Received: from mga11.intel.com ([192.55.52.93]:59019 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753381Ab3GIOWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 10:22:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1028,1363158000"; 
   d="scan'208";a="367450501"
Date: Tue, 9 Jul 2013 22:21:13 +0800
From: Haicheng Li <haicheng.li@linux.intel.com>
To: Jiang Liu <liuj97@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Haicheng Li <haicheng.lee@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 1/3] PCI: Add hide_device support to pci subsystem.
Message-ID: <20130709142113.GA5954@hli22-desktop>
References: <1372864578-6925-1-git-send-email-haicheng.li@linux.intel.com>
 <CAErSpo5dR_2tUDFoFO49N3Ut569+6Cfosx8Q=91U_w-8mvFVkg@mail.gmail.com>
 <51D8D5D7.3010701@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51D8D5D7.3010701@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 07, 2013 at 10:43:35AM +0800, Jiang Liu wrote:
> On 07/04/2013 12:09 AM, Bjorn Helgaas wrote:
> > On Wed, Jul 3, 2013 at 9:16 AM, Haicheng Li <haicheng.li@linux.intel.com> wrote:
> >> With more and more SOCs having pci device integrated into chip (e.g. Intel
> >> Atom series), it's useful to add an interface to cleanly hide pci devices from
> >> pci device scanning, which is because:
> >>
> >> 1. phone or tablet OEMs may choose disabling some pci device in the SOC,
> >>    such as camera ISP in Intel Atom Z2580 chip, and etc.
> >> 2. if such disabled devices are not cleanly removed from pci device tree,
> >>    then pci-core will still try to operate on the relative device control
> >>    registers while S3 suspend and resume.
> >> 3. so hiding such devices from early begining will not only reduce the kernel
> >>    boot time, but also optimize the latency of system suspend and resume.
> > 
> > Normally the chip provides a way to disable devices by writing a
> > configuration register.  Then the device doesn't respond when Linux
> > enumerates devices, so nothing special is required in the kernel.
> > What's different about the Z2580?  I'd be surprised if Intel forgot to
> > include such a register.  Maybe the firmware just isn't smart enough
> > to disable the device?  If so, it would be better to fix the firmware
> > than to add kludges in the kernel.

Sorry for slow response due to a travel recently.
> Agree, it would be great if chipset and firmware could cooperate to
> handle this issue. Otherwise the interface may be abused and causes
> trouble to PCI hotplug operations because the notation seg:bus:dev.func
> isn't reliable. The PCI bus number may reassigned by OS.
I quickly went thru the code and thought the bus # should not be changed in runtime
by current code. do you mean after a reboot, the bus# maybe changed with new slot hotplugged?

Can you please elabrate this case? hopefully I can enhance the patch to cover it.
 
> > 
> >> To hide pci devices, just pass such parameters to kernel at boot stage:
> >>         pci=hide=[<domain>:]<bus>:<slot>.<func>[; ...]

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455AbaHUXH5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 19:07:57 -0400
Received: from dliviu.plus.com ([80.229.23.120]:40302 "EHLO smtp.dudau.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755089AbaHUXH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 19:07:56 -0400
Date: Fri, 22 Aug 2014 00:07:40 +0100
From: Liviu Dudau <liviu@dudau.co.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Liviu Dudau <Liviu.Dudau@arm.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        linux-pci <linux-pci@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] drivers: pci: convert generic host controller to DT host
 bridge creation API
Message-ID: <20140821230740.GJ13147@bart.dudau.co.uk>
References: <1407861695-25549-1-git-send-email-Liviu.Dudau@arm.com>
 <201408201327.57376.arnd@arndb.de>
 <20140820123112.GG13147@bart.dudau.co.uk>
 <201408202139.27678.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <201408202139.27678.arnd@arndb.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Fri Aug 22 00:07:55 2014
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 13,53f67bcb3129530696664
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2014 at 09:39:27PM +0200, Arnd Bergmann wrote:
> On Wednesday 20 August 2014, Liviu Dudau wrote:
> > That has been the general approach of my patchset up to v9. But, as Bjorn has
> > mentioned in his v8 review and I have put in my cover letter, the regular
> > aproach means that architectures that use pci_scan_root_bus() will have to
> > drop their one liner and replace it with the more verbose of_create_pci_host_bridge()
> > followed by pci_scan_child_bus() and pci_bus_add_devices() (basically, the content
> > of pci_scan_root_bus()). For those architectures it will lead to a net increase of
> > lines of code.
> 
> I'll try to get hold of Bjorn here and discuss it with him in person. I'd
> rather see a few extra lines in each driver than the complexity of callback
> funtions.
> 
> > The patch for pci-host-generic.c is the first to use the callback setup function, but
> > not the only one. My PCI host bridge driver for Juno has the same need, and I'm betting
> > all other host bridge controllers will use it as it will be the only opportunity to
> > finish the controller setup before we start scanning the child busses. I'm trying to
> > balance ease of read vs ease of use here and it is the best version I've come up with
> > so far.
> 
> My main objection to the new approach is that it's different from most other
> subsystems doing the same thing. For a person reading the pci host driver
> implementation, when they are familiar with other device drivers, I think it's
> much clearer what is going on when smaller functions are called in sequence
> than to see one function passed into some other interface that you now have
> to read as well in order to understand when it gets called.

Would it be more clear if (when) the currently opaque sysdata becomes a structure
to be filled by the host bridge driver with a .setup member pointing to the
callback? That would be my preferred way of expressing the API, tbh, but it means
duplicating the existing pci_{create,scan}_root_bus() functions.

Best regards,
Liviu

> 
> 	Arnd
> 

-- 
-------------------
   .oooO
   (   )
    \ (  Oooo.
     \_) (   )
          ) /
         (_/

 One small step
   for me ...


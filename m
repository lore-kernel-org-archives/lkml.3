Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132Ab3FZVaQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 17:30:16 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:33617 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585Ab3FZVaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 17:30:14 -0400
Date: Wed, 26 Jun 2013 15:30:10 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        danders@circuitco.com, vishal.l.verma@intel.com,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 7/8] pci: Add CircuitCo VENDOR ID and MinnowBoard DEVICE
 ID
Message-ID: <20130626213010.GA31010@google.com>
References: <cover.1372211451.git.dvhart@linux.intel.com>
 <83879b07cd4ce95f086420d1faa926c1692d63b4.1372211451.git.dvhart@linux.intel.com>
 <20130626163250.GA29299@google.com>
 <1372266904.8177.83.camel@envy.home>
 <CAErSpo6=1i76RRmJSUi+BpD9D0WrXaML4HkGLn0C=+6=ohB0uQ@mail.gmail.com>
 <1372281416.2720.28.camel@envy.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372281416.2720.28.camel@envy.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 02:16:56PM -0700, Darren Hart wrote:
> On Wed, 2013-06-26 at 13:37 -0600, Bjorn Helgaas wrote:
> > On Wed, Jun 26, 2013 at 11:15 AM, Darren Hart <dvhart@linux.intel.com> wrote:
> > > On Wed, 2013-06-26 at 10:32 -0600, Bjorn Helgaas wrote:
> > 
> > >> +#define PCI_VENDOR_ID_CIRCUITCO              0x1cc8
> > >> +
> > >>  #define PCI_VENDOR_ID_TEKRAM         0x1de1
> > >>  #define PCI_DEVICE_ID_TEKRAM_DC290   0xdc29
> > >
> > >
> > > Thanks Bjorn. When I reuse this Subsystem ID and there is more than one
> > > usage, I should send a patch to pci_ids.h adding it and replace the hex
> > > value in all drivers with the new define. Is that right?
> > 
> > Yeah, that's what I was thinking.
> > 
> > But Peter's comment makes more sense to me now.  The spec refers to
> > that config register as "Subsystem ID," not "Subsystem Device ID," but
> > I was confused because most existing usage treats it as a device ID.
> > For example, the field in struct pci_device_id is named "subdevice,"
> > and all the existing #defines in pci_ids.h are of the form
> > PCI_SUBDEVICE_ID_*.
> > 
> > Device IDs are pretty specific identifiers, so I was thinking that a
> > "sub-device ID" would be even more specific.  Then it would make no
> > sense to have a "sub-device ID" that was as generic as "MINNOWBOARD."
> > But the register is actually *not* a "sub-device ID," and I can see
> > that using the same Subsystem ID for all the devices on a board might
> > make sense.
> > 
> > So I think the name PCI_DEVICE_ID_CIRCUITCO_MINNOWBOARD is a bit of a
> > misnomer, and something like PCI_SUBSYSTEM_CIRCUITCO_MINNOWBOARD would
> > make it more clear that it really isn't sharing the device ID space
> > assigned to CircuitCo.  It would make perfect sense to have a Device
> > ID, e.g., "PCI_DEVICE_ID_CIRCUIT_CO_xxx 0x0001," that has nothing to
> > do with the Subsystem ID 0x0001.
> > 
> > If you want to do something like that (or even keep your original
> > patch), I can put that in my -next branch.  Just let me know.
> > 
> > Bjorn
> 
> 
> I would be happy to change DEVICE to SUBSYSTEM in the the pci_ids.h:
> 
> +#define PCI_VENDOR_ID_CIRCUITCO		0x1cc8
> +#define PCI_SUBSYSTEM_ID_CITCUITCO_MINNOWBOARD	0x0001
> 
> Would you like me to send another patch?

No need.  I'll just apply the following patch.  Obviously your follow-on
pch_gbe patch will need a corresponding change.

Let me know if it needs tweaking, or if you decide I was talking nonsense
above.


commit c2efb42ab6033388f3bbed2dbe0fb76f2402e04a
Author: Darren Hart <dvhart@linux.intel.com>
Date:   Tue Jun 25 20:08:46 2013 -0600

    PCI: Add CircuitCo vendor ID and subsystem ID
    
    Add CircuitCo's newly created VENDOR ID and their first board subsystem
    ID for the MinnowBoard.
    
    [bhelgaas: sort, change DEVICE_ID to SUBSYSTEM_ID]
    Signed-off-by: Darren Hart <dvhart@linux.intel.com>
    Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>

diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index c129162..4c7b349 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2476,6 +2476,9 @@
 
 #define PCI_VENDOR_ID_ASMEDIA		0x1b21
 
+#define PCI_VENDOR_ID_CIRCUITCO		0x1cc8
+#define PCI_SUBSYSTEM_ID_CIRCUITCO_MINNOWBOARD	0x0001
+
 #define PCI_VENDOR_ID_TEKRAM		0x1de1
 #define PCI_DEVICE_ID_TEKRAM_DC290	0xdc29
 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645Ab3FZTiB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 15:38:01 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:47236 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307Ab3FZTh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 15:37:59 -0400
MIME-Version: 1.0
In-Reply-To: <1372266904.8177.83.camel@envy.home>
References: <cover.1372211451.git.dvhart@linux.intel.com> <83879b07cd4ce95f086420d1faa926c1692d63b4.1372211451.git.dvhart@linux.intel.com>
 <20130626163250.GA29299@google.com> <1372266904.8177.83.camel@envy.home>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 26 Jun 2013 13:37:39 -0600
Message-ID: <CAErSpo6=1i76RRmJSUi+BpD9D0WrXaML4HkGLn0C=+6=ohB0uQ@mail.gmail.com>
Subject: Re: [PATCH 7/8] pci: Add CircuitCo VENDOR ID and MinnowBoard DEVICE ID
To: Darren Hart <dvhart@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        danders@circuitco.com, vishal.l.verma@intel.com,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 11:15 AM, Darren Hart <dvhart@linux.intel.com> wrote:
> On Wed, 2013-06-26 at 10:32 -0600, Bjorn Helgaas wrote:

>> +#define PCI_VENDOR_ID_CIRCUITCO              0x1cc8
>> +
>>  #define PCI_VENDOR_ID_TEKRAM         0x1de1
>>  #define PCI_DEVICE_ID_TEKRAM_DC290   0xdc29
>
>
> Thanks Bjorn. When I reuse this Subsystem ID and there is more than one
> usage, I should send a patch to pci_ids.h adding it and replace the hex
> value in all drivers with the new define. Is that right?

Yeah, that's what I was thinking.

But Peter's comment makes more sense to me now.  The spec refers to
that config register as "Subsystem ID," not "Subsystem Device ID," but
I was confused because most existing usage treats it as a device ID.
For example, the field in struct pci_device_id is named "subdevice,"
and all the existing #defines in pci_ids.h are of the form
PCI_SUBDEVICE_ID_*.

Device IDs are pretty specific identifiers, so I was thinking that a
"sub-device ID" would be even more specific.  Then it would make no
sense to have a "sub-device ID" that was as generic as "MINNOWBOARD."
But the register is actually *not* a "sub-device ID," and I can see
that using the same Subsystem ID for all the devices on a board might
make sense.

So I think the name PCI_DEVICE_ID_CIRCUITCO_MINNOWBOARD is a bit of a
misnomer, and something like PCI_SUBSYSTEM_CIRCUITCO_MINNOWBOARD would
make it more clear that it really isn't sharing the device ID space
assigned to CircuitCo.  It would make perfect sense to have a Device
ID, e.g., "PCI_DEVICE_ID_CIRCUIT_CO_xxx 0x0001," that has nothing to
do with the Subsystem ID 0x0001.

If you want to do something like that (or even keep your original
patch), I can put that in my -next branch.  Just let me know.

Bjorn

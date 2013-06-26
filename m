Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177Ab3FZVbE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 17:31:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40568 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753005Ab3FZVbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 17:31:01 -0400
Message-ID: <51CB5D84.4080709@zytor.com>
Date: Wed, 26 Jun 2013 14:30:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Darren Hart <dvhart@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        danders@circuitco.com, vishal.l.verma@intel.com,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 7/8] pci: Add CircuitCo VENDOR ID and MinnowBoard DEVICE
 ID
References: <cover.1372211451.git.dvhart@linux.intel.com> <83879b07cd4ce95f086420d1faa926c1692d63b4.1372211451.git.dvhart@linux.intel.com> <20130626163250.GA29299@google.com> <1372266904.8177.83.camel@envy.home> <CAErSpo6=1i76RRmJSUi+BpD9D0WrXaML4HkGLn0C=+6=ohB0uQ@mail.gmail.com>
In-Reply-To: <CAErSpo6=1i76RRmJSUi+BpD9D0WrXaML4HkGLn0C=+6=ohB0uQ@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2013 12:37 PM, Bjorn Helgaas wrote:
> 
> Yeah, that's what I was thinking.
> 
> But Peter's comment makes more sense to me now.  The spec refers to
> that config register as "Subsystem ID," not "Subsystem Device ID," but
> I was confused because most existing usage treats it as a device ID.
> For example, the field in struct pci_device_id is named "subdevice,"
> and all the existing #defines in pci_ids.h are of the form
> PCI_SUBDEVICE_ID_*.
> 
> Device IDs are pretty specific identifiers, so I was thinking that a
> "sub-device ID" would be even more specific.  Then it would make no
> sense to have a "sub-device ID" that was as generic as "MINNOWBOARD."
> But the register is actually *not* a "sub-device ID," and I can see
> that using the same Subsystem ID for all the devices on a board might
> make sense.
> 

Subsystem IDs is basically a board ID in the traditional PC view, but
they didn't call it that because it would have been confusing in other,
nontraditional configurations.

Microsoft has a "best practices" document, which may end up becoming
basis for a future PCI-SIG document clarifying the standard:

http://msdn.microsoft.com/en-us/library/windows/hardware/gg463287.aspx

	-hpa


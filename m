Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952Ab3FZVq1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 17:46:27 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:59871 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab3FZVqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 17:46:25 -0400
MIME-Version: 1.0
In-Reply-To: <51CB5D84.4080709@zytor.com>
References: <cover.1372211451.git.dvhart@linux.intel.com> <83879b07cd4ce95f086420d1faa926c1692d63b4.1372211451.git.dvhart@linux.intel.com>
 <20130626163250.GA29299@google.com> <1372266904.8177.83.camel@envy.home>
 <CAErSpo6=1i76RRmJSUi+BpD9D0WrXaML4HkGLn0C=+6=ohB0uQ@mail.gmail.com> <51CB5D84.4080709@zytor.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 26 Jun 2013 15:46:04 -0600
Message-ID: <CAErSpo6Dss9hj33QRP-Leob05WT-uN-MWUAZBfh+VDtUvCWNkA@mail.gmail.com>
Subject: Re: [PATCH 7/8] pci: Add CircuitCo VENDOR ID and MinnowBoard DEVICE ID
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Darren Hart <dvhart@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        danders@circuitco.com, vishal.l.verma@intel.com,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 3:30 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 06/26/2013 12:37 PM, Bjorn Helgaas wrote:
>>
>> Yeah, that's what I was thinking.
>>
>> But Peter's comment makes more sense to me now.  The spec refers to
>> that config register as "Subsystem ID," not "Subsystem Device ID," but
>> I was confused because most existing usage treats it as a device ID.
>> For example, the field in struct pci_device_id is named "subdevice,"
>> and all the existing #defines in pci_ids.h are of the form
>> PCI_SUBDEVICE_ID_*.
>>
>> Device IDs are pretty specific identifiers, so I was thinking that a
>> "sub-device ID" would be even more specific.  Then it would make no
>> sense to have a "sub-device ID" that was as generic as "MINNOWBOARD."
>> But the register is actually *not* a "sub-device ID," and I can see
>> that using the same Subsystem ID for all the devices on a board might
>> make sense.
>>
>
> Subsystem IDs is basically a board ID in the traditional PC view, but
> they didn't call it that because it would have been confusing in other,
> nontraditional configurations.
>
> Microsoft has a "best practices" document, which may end up becoming
> basis for a future PCI-SIG document clarifying the standard:
>
> http://msdn.microsoft.com/en-us/library/windows/hardware/gg463287.aspx

Interesting, thanks for the link.  If I read that correctly, the
MinnowBoard is basically a motherboard, and any board layout change or
component value change will require a new Subsystem ID, which will in
turn require a pch_gbe update.  That doesn't sound optimal, but maybe
people don't actually interpret it that strictly.

Bjorn

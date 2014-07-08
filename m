Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833AbaGHSYD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 14:24:03 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:41260 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866AbaGHSYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 14:24:00 -0400
MIME-Version: 1.0
In-Reply-To: <5283004.YemU4lhtKD@pcbe13110.cern.ch>
References: <280883016.9onmf0miLq@pcbe13110.cern.ch> <1719046.4xHmiSoxkE@pcbe13110.cern.ch>
 <CAErSpo5YbaOjqr4obHwekRNwo1K5j0JbE-PYu48k7U90ZpWM0A@mail.gmail.com> <5283004.YemU4lhtKD@pcbe13110.cern.ch>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 8 Jul 2014 12:23:39 -0600
Message-ID: <CAErSpo5ixtc=n0f56=QvtxYnXumZiao6NMgBVAWpcJH4f7QA4g@mail.gmail.com>
Subject: Re: PCIe bus enumeration
To: Federico Vaga <federico.vaga@cern.ch>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        michel.arruat@cern.ch
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 8, 2014 at 1:15 AM, Federico Vaga <federico.vaga@cern.ch> wrote:
>> > So, It looks like that some BIOS disable the bridge when there is
>> > nothing behind it. Why? Power save? :/
>>
>> Could be power savings, or possibly to conserve bus numbers, which
>> are a limited resource.
>
> what is the maximum number of buses?

256.

>> Well, it's true that it's hard to get constant *bus numbers*, but
>> it's never really been a good idea to rely on those, because
>> they're assigned at the discretion of the OS, and there are reasons
>> why the OS might want to reallocate them, e.g., to accommodate a
>> deep hot-plugged hierarchy.  If you shift focus to *slot numbers*,
>> then I think there's a lot more we can do.
>
> At this point I'm a little bit confused about the definition "slot
> numbers" :) You mean the 22, 25, ...

Right.  Bus numbers are under software control, to some degree (as a
general rule, an x86 BIOS assigns them and Linux leaves them alone,
but they *can* be changed so they aren't a good thing to rely on).
The bus number of a root bus is usually determined by hardware or by
an arch-specific host bridge driver.  The bus number below a PCI-PCI
bridge is determined by the bridge's "secondary bus number" register,
which software can change.

Slot numbers are based on the Physical Slot Number in the PCIe Slot
Capability register.  This is set by some hardware mechanism such as
pin strapping or a serial EEPROM.  Software can't change it, so you
can rely on it to be constant.  (There's also a mechanism for getting
a slot number from ACPI, but that should also return a constant
value).  The problem is that I don't think the Linux slot number
support is very good, so I'm sure there's plenty of stuff that we
*should* be able to do that we can't do *yet*.

Bjorn

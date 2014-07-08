Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083AbaGHU1X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 16:27:23 -0400
Received: from mail-qg0-f48.google.com ([209.85.192.48]:47229 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbaGHU1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 16:27:21 -0400
MIME-Version: 1.0
In-Reply-To: <3107266.EcOOcRPPM0@harkonnen>
References: <280883016.9onmf0miLq@pcbe13110.cern.ch> <5283004.YemU4lhtKD@pcbe13110.cern.ch>
 <CAErSpo5ixtc=n0f56=QvtxYnXumZiao6NMgBVAWpcJH4f7QA4g@mail.gmail.com> <3107266.EcOOcRPPM0@harkonnen>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 8 Jul 2014 14:27:00 -0600
Message-ID: <CAErSpo7YEiiM1b8Jf1d3Pt4iZXhwNTr18SsSZS15Ekm_LHS03A@mail.gmail.com>
Subject: Re: PCIe bus enumeration
To: Federico Vaga <federico.vaga@cern.ch>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        michel.arruat@cern.ch
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 8, 2014 at 1:20 PM, Federico Vaga <federico.vaga@cern.ch> wrote:
> On Tuesday 08 July 2014 12:23:39 Bjorn Helgaas wrote:
>> On Tue, Jul 8, 2014 at 1:15 AM, Federico Vaga
> <federico.vaga@cern.ch> wrote:
>> >> > So, It looks like that some BIOS disable the bridge when there
>> >> > is
>> >> > nothing behind it. Why? Power save? :/
>> >>
>> >> Could be power savings, or possibly to conserve bus numbers,
>> >> which
>> >> are a limited resource.
>> >
>> > what is the maximum number of buses?
>>
>> 256.
>
> Well, it is not a small number. I will ask directly to the company who
> sell this crate and ask them what is going on in the BIOS

Yeah, it's not usually a problem until you get to the really big
machines.  The BIOS vendor could give you a much better reason; I'm
only speculating.

>> > At this point I'm a little bit confused about the definition "slot
>> > numbers" :) You mean the 22, 25, ...
>>
>> Right.  Bus numbers are under software control, to some degree (as a
>> general rule, an x86 BIOS assigns them and Linux leaves them alone,
>> but they *can* be changed so they aren't a good thing to rely on).
>> The bus number of a root bus is usually determined by hardware or
>> by an arch-specific host bridge driver.  The bus number below a
>> PCI-PCI bridge is determined by the bridge's "secondary bus number"
>> register, which software can change.
>>
>> Slot numbers are based on the Physical Slot Number in the PCIe Slot
>> Capability register.  This is set by some hardware mechanism such as
>> pin strapping or a serial EEPROM.  Software can't change it, so you
>> can rely on it to be constant.  (There's also a mechanism for
>> getting a slot number from ACPI, but that should also return a
>> constant value).  The problem is that I don't think the Linux slot
>> number support is very good, so I'm sure there's plenty of stuff
>> that we *should* be able to do that we can't do *yet*.
>
> Mh, I understand. Let's say that I have time to spend on this problem
> (I do not know) and contributing to the PCI subsystem. How many
> differences are there between 3.2, 3.6, 3.16/next? We are using
> 3.2/3.6 at the moment, but probably you should expect that it will
> work on the last version :)

There are quite a few differences, including a fair amount of work on
the hotplug drivers.  The problem in this area is that pciehp (the
PCIe hotplug driver) and acpiphp (the ACPI hotplug driver) both can
register slot numbers and it's sort of ugly to figure out which one to
use in a given situation.  Neither can be a loadable module anymore,
which simplifies things a little bit, but it's still ugly.

Bjorn

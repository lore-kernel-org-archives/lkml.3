Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265AbaAJBcR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 20:32:17 -0500
Received: from exprod5og110.obsmtp.com ([64.18.0.20]:40911 "HELO
	exprod5og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754309AbaAJBcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 20:32:15 -0500
MIME-Version: 1.0
In-Reply-To: <20140107183148.GD4227@obsidianresearch.com>
References: <1387785725-24262-1-git-send-email-tinamdar@apm.com>
	<201401031049.20932.arnd@arndb.de>
	<CACoXjc=h8W=9jx4d2Y+F9hmgQsuMTgG4080jZGbtddv10OgtMA@mail.gmail.com>
	<201401071635.02006.arnd@arndb.de>
	<20140107183148.GD4227@obsidianresearch.com>
Date: Thu, 9 Jan 2014 17:32:13 -0800
Message-ID: <CACoXjc=G1d7hEPUy_cC7bN63akJdKcQfpUQgEC+JcUdL-=0XBg@mail.gmail.com>
Subject: Re: [RFC PATCH 3/3] dt-bindings: pci: xgene pcie device tree bindings
From: Tanmay Inamdar <tinamdar@apm.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Arnd Bergmann <arnd@arndb.de>, devicetree@vger.kernel.org,
        Jon Masters <jcm@redhat.com>, linux-doc@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>, patches <patches@apm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>, Rob Landley <rob@landley.net>,
        linux-pci@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 7, 2014 at 10:31 AM, Jason Gunthorpe
<jgunthorpe@obsidianresearch.com> wrote:
> On Tue, Jan 07, 2014 at 04:35:01PM +0100, Arnd Bergmann wrote:
>
>> > >> +                       0x00000000 0x0 0xd0000000 0xe0 0xd0000000 0x0 0x00200000 /* cfg */
>> > >
>> > > config space is not normally in the ranges property, and I think you will need
>> > > it in the pcie node itself as a 'reg' property so the code can access it.
>> >
>> > pcie-designware.c does it that way. I just followed their implementation.
>>
>> I don't remember what led to that, it still seems wrong and I can't
>> find anything in the PCI binding for host bridges telling their
>> config space this way.
>
> When we discussed the mvebu PCI driver (which is, so far, the most
> throughly discussed PCI binding) it was concluded that the config
> space ranges like the above was OK only if it exactly described the
> standard ECAM layout.
>
> Idea being that standard/core code should be able to see that ranges,
> map the range and issue config accesses via the ECAM rules.

Ok. Thanks.

>
>> > >> +             interrupt-map-mask = <0x0 0x0 0x0 0x7>;
>> > >> +             interrupt-map = <0x0 0x0 0x0 0x1 &gic 0x0 0xc2 0x1>;
>> > >
>> > > Only one IRQ for all devices?
>> >
>> > The node represents a port. I believe that Linux framework uses only
>> > one of the legacy IRQs per port. Rest all remain unused. Hence I
>> > removed them. Please correct me if I am wrong.
>>
>> Any PCI device can normally have four interrupts (IntA through
>> IntD), which are traditionally separate pins on a PCI bus, but get
>> emulated on PCIe. While it's not common for any normal device to use
>> more than one IRQ, a bridge device will swizzle these (virtual) IRQ
>> lines, so a device behind the bridge actually gets a different host
>> IRQ.
>
> Agree, the binding should handle all four INTA,B,C,D assertions
> delivered to the port.
>
> If HW is able to decode the 4 ints into seperate Linux interrupt
> numbers then that should be described. If HW routes them all to a
> single number then interrupt-map-mask should be all 0.
>
> Arnd's point about swizzling effects the layout of the
> interrupt-map. When it is placed at the pcie-controller node level the
> map will incorporate one swizzle of the on-the-wire INTx messages. If
> the HW doesn't swizzle the INTx as the TLP passes through the bridge
> then it probably makes more sense to put the interrupt-map in the DT
> node of the bridge like mvebu does.
>

Ok.

> Jason

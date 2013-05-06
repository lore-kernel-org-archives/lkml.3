Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119Ab3EFMIr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 08:08:47 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:46219 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525Ab3EFMIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 08:08:45 -0400
MIME-Version: 1.0
In-Reply-To: <CAAMvbhHy6iMweh1Pm_H1Oc2Z+TOypL-ACYnfsfQwzL2+0O3MFg@mail.gmail.com>
References: <CAPweEDym3TSEKWB1PsRWZ77irkTPF-Qdm9nRGfRBrv72CQ8zJA@mail.gmail.com>
	<51872CF6.5070409@gmail.com>
	<CAPweEDz-Zp91zLG2H_bdj_Z5BSgKaXj6Hc8+OOp1_6Cm01xrFA@mail.gmail.com>
	<CAAMvbhHy6iMweh1Pm_H1Oc2Z+TOypL-ACYnfsfQwzL2+0O3MFg@mail.gmail.com>
Date: Mon, 6 May 2013 13:08:44 +0100
X-Google-Sender-Auth: iy7yu4MSkOaddIWskmtx-iCOpnQ
Message-ID: <CAPweEDwZrXQ4Wqw6_-YvmR7uNxWWNvE_c0-8UMuEhFzYW-BZWQ@mail.gmail.com>
Subject: Re: device tree not the answer in the ARM world [was: Re: running
 Debian on a Cubieboard]
From: Luke Kenneth Casson Leighton <lkcl@lkcl.net>
To: James Courtier-Dutton <james.dutton@gmail.com>
Cc: Robert Hancock <hancockrwd@gmail.com>,
        David Goodenough <david.goodenough@btconnect.com>,
        debian-arm@lists.debian.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux on small ARM machines 
	<arm-netbook@lists.phcomp.co.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

james, hi - top-posting or not you make some valid points, and i don't
believe you're subscribed to arm-netbooks so i'm going to take a
liberty and reply briefly inline but keep most of what you've written
intact, apologies to debian-arm and lkml.

On Mon, May 6, 2013 at 10:04 AM, James Courtier-Dutton
<james.dutton@gmail.com> wrote:
> The real problem with any new system, is the hardware is designed and
> then it is a challenge for the software developer to get the software
> to boot on the new hardware.
> The nirvana here would be to take the original hardware circuit
> diagram, and process it to automatically create a config file.
> The config file would then be used by the software to configure itself
> to boot the new hardware.
> I think the device tree config file is going some way to help here.
> X86 is lucky in that there are config standards out there, and people
> are actually using them. PCI, USB, ACPI.
> ARM is different

 insanely so.  only the instruction set is guaranteed to be common...
oh wait, it's not, is it?  insanely so.  this was the mistake that
linus made at that conference in 2007, by telling the arm
representatives to "go away and come back with only one person to
future conferences".

> and does not have this yet.

 ... and won't.  many SoCs don't - and won't have - USB3 because it
uses too much power [to drive the high-speed signal lanes].  the
percentage of SoCs that have PCIe is extremely small, and those that
do typically have only a 1x lane (iMX6).  samsung and marvell's
higher-power offerings have 2x and 4x PCIe.

 ACPI?  flat-out forget it!  really.  sorry, brief answer there.
running out of time here, apologies.  see previous reply (to oliver)

> Also, so long as there is some way to uniquely identify the hardware
> with, for example a model number, quirks can be written into the
> software to handle special cases, and the config file identify which
> quirks need to be used.
> As more and more hardware manufactures report their quirks and device
> drivers to the mainline kernel, the closer we will get to an automated
> process to boot new hardware.

 again, see previous reply to oliver (overlapped) which points out
that this is an "after-the-fact" burden on the linux kernel developers

> There are already efforts around the ARM multi-platform where a single
> kernel can boot multiple ARM CPUs.

 ... but it can't do all of them, can it?

> I suppose that ARM multi-platform will never cover all ARM CPUs, but
> the more it covers, the easier and cheaper it will be to work with new
> hardware and ARM.

 no.  no, no no and wrong.  absolutely dead wrong.  you're completely
misunderstanding the economics of large and mass-volume product
development.  the hardware cost is
EEEEEEVVVEEERRRRRRYYYTTHHHHIIINNNNGGGG.

 the software development cost because it is a one-off (non-recurring
expense) is completely and utterly irrelevant.  again, see reply to
oliver's message.


> Say, if a manufacturer has 20 different models of mobile phone out
> there, all based on ARM.
> Currently, they need a different kernel for each one. If they could
> use the same kernel across all 20 models, that would reduce their
> development costs considerably.

 let's do some maths.  let's say that the cost of re-using a DT-based
kernel is $50k, but the custom development (not using DT) is $250,000.

 let's say that you have to use a freescale $20 processor (iMX6 Dual)
with that, because linaro is being paid $1m per year to help freescale
to make devicetree work, and it gets them in on that
one-kernel-across-20-models thing.

 so they work out the BOM, against the projected expenditure over say
2 years they expect to sell say 100 million phones.

 iMX6 Dual phone's expenditure (based on processor and software NREs
alone): $20 * 100 million + $50k = $2.00005 billion.

 even if you don't have the custom development, the cost is $2.00025
billion which, i know i said it might be the profit margin but hey,
we're still looking at the 4th decimal place here.

 now let's compare that to e.g. the allwinner A20, which is coming in
at the *same* functionality, less power than the iMX6 Dual, and the
price i've learned recently could well be the same as the A10 in
mass-volume (but don't quote me on that).

 so we work out a BOM on 100 million phones:

 A20 (Dual-Core Cortex A7 remember) based on processor and software
NREs alone: $7.50 * 100 million + $50k = $0.75005 billion.

 do you see the point, james?  the cost of the software development is
utterly, utterly, utterly irrelevant.

 the cost of the hardware *is everything*.

 ok, that's not quite true.  if the amount of *time* taken on the
software development is too great, then it puts your entire hardware
development NREs at risk because you're so far behind the curve that
nobody will buy the product even when it's out.

 but the amount of time taken on software development is *not* the
same as the *cost* of the software development.

 ok.  now i really have to give it a rest.  another 25 mins gone.  whoops :)

l.

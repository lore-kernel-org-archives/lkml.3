Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755AbaE0ULL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 16:11:11 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:61711 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585AbaE0ULI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 16:11:08 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v4 2/8] OF: Introduce DT overlay support.
To: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Cc: Guenter Roeck <linux@roeck-us.net>, Sebastian Reichel <sre@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pete Popov <pete.popov@konsulko.com>,
        Dan Malek <dan.malek@konsulko.com>,
        Georgi Vlaev <georgi.vlaev@konsulko.com>
In-Reply-To: <9CF30A1A-5EB6-401E-A0D5-453CB99B4A83@konsulko.com>
References: <CAMuHMdUWfQ=2xPhNsS36mT6nv-CfR3_1exZ+5qYgdkjbBntrWg@mail.gmail.com>
	<20140516105814.3EA3FC403C2@trevor.secretlab.ca>
	<CAMuHMdWw39n8O0fFWECR6v6GaEJ3aB5S3ront4eDdXwxNO6Fgw@mail.gmail.com>
	<20140520055026.E3A98C412DA@trevor.secretlab.ca>
	<CAMuHMdXjWENrq0MW-DU2x7WnaCsWyipN4DO=y0ZTL+3G_fPYGg@mail.gmail.com>
	<20140526104824.63F13C42129@trevor.secretlab.ca>
	<CAMuHMdUGdjVKBR5rRzZ274rf7p8XfztNRWEojH1RrZV8c_V1uA@mail.gmail.com>
	<20140526112348.907B7C421A5@trevor.secretlab.ca>
	<A6195DFD-0447-4444-AC09-501C43F09924@konsulko.com>
	<20140526213303.C1C73C40E11@trevor.secretlab.ca>
	<20140526223630.GA32691@earth.universe> <5383D174.8070304@roeck-us.net>
	<20140527121236.3B818C40A5A@trevor.secretlab.ca>
	<9CF30A1A-5EB6-401E-A0D5-453CB99B4A83@konsulko.com>
Date: Tue, 27 May 2014 21:11:02 +0100
Message-Id: <20140527201102.BE7F4C40BD2@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 May 2014 15:24:35 +0300, Pantelis Antoniou <pantelis.antoniou@konsulko.com> wrote:
> Hi Grant,
> 
> On May 27, 2014, at 3:12 PM, Grant Likely wrote:
> 
> > On Mon, 26 May 2014 16:42:44 -0700, Guenter Roeck <linux@roeck-us.net> wrote:
> >> On 05/26/2014 03:36 PM, Sebastian Reichel wrote:
> >>> Hi,
> >>> 
> >>> On Mon, May 26, 2014 at 10:33:03PM +0100, Grant Likely wrote:
> >>>> After thinking about it more, I think it is very likely that removing
> >>>> all the overlays is the correct thing to do in the kexec use-case. When
> >>>> kexec-ing, it makes sense that we'd want the exact same behaviour from
> >>>> the kexec'ed kernel. That means we want the device drivers to do the
> >>>> same thing including loading whatever overlays they depend on.
> >>>> 
> >>>> If the flattened tree was left applied, then the behaviour becomes
> >>>> different.
> >>>> 
> >>>> I say always remove the overlays unless explicitly told not to, but I'm
> >>>> struggling to come up with use cases where keeping them applied is
> >>>> desirable.
> >>> 
> >>> I would assume, that I want them applied in most cases. DT describes
> >>> the hardware. If I kexec into a new kernel I change software, not
> >>> hardware.
> >>> 
> >>> Maybe I'm missing the main purpose of the feature. I currently see
> >>> two useful usecases for DT overlays:
> >>> 
> >>> 1. The dtb the kernel is booted with cannot be changed for some
> >>>    reason, but the board has additional hardware attached (e.g.
> >>>    the user added a sensor on the i2c bus)
> >>> 2. The hardware is changed on the fly (e.g. the user flashed the
> >>>    FPGA part of a zynq processor), sensors on i2c bus, ...
> >>> 
> >>> In both cases the kernel should be booted with the additional
> >>> overlay information IMHO. Though for the second case it should
> >>> be possible to remove the "programmed" hardware information
> >>> somehow.
> >>> 
> >> 
> >> 3. Some hot-plug device or card is inserted or removed.
> >> 
> >> I would argue that the kernel should _not_ be booted with the overlay in place.
> >> Otherwise the code handling overlays would have to have special handling
> >> for the restart case, which is much more complex than just to re-insert
> >> the overlay when it is determined that the device or card is still there.
> > 
> > Exactly.
> > 
> 
> Looks like we are levitating to the 'remove overlays on kexec' approach.
> Is that correct?

Yes. What form that takes is yet to be decided. Kexec traditionally has
worked by userspace extracting the device tree from /proc/device-tree,
getting a kernel image into memory, and then doing the kexec call. It
wouldn't be very friendly to have kexec force all the overlays to be
removed while the kernel is still running.

We could solve this by making kexec use the original dtb blob instead of
the livetree. Otherwise we'd need an interface for userspace to extract
the original tree, or have the information to unwind the overlays. Not
exactly simple.

g.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163AbaEZVdT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 17:33:19 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:48640 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750AbaEZVdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 17:33:14 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v4 2/8] OF: Introduce DT overlay support.
To: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Guenter Roeck <linux@roeck-us.net>,
        Dirk Behme <dirk.behme@gmail.com>,
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
In-Reply-To: <A6195DFD-0447-4444-AC09-501C43F09924@konsulko.com>
References: <1396615441-29630-1-git-send-email-pantelis.antoniou@konsulko.com>
	<1396615441-29630-3-git-send-email-pantelis.antoniou@konsulko.com>
	<20140514100856.5198DC4153D@trevor.secretlab.ca>
	<E204285C-D6CD-4518-A94F-26BF0570C1B1@konsulko.com>
	<CAMuHMdUWfQ=2xPhNsS36mT6nv-CfR3_1exZ+5qYgdkjbBntrWg@mail.gmail.com>
	<20140516105814.3EA3FC403C2@trevor.secretlab.ca>
	<CAMuHMdWw39n8O0fFWECR6v6GaEJ3aB5S3ront4eDdXwxNO6Fgw@mail.gmail.com>
	<20140520055026.E3A98C412DA@trevor.secretlab.ca>
	<CAMuHMdXjWENrq0MW-DU2x7WnaCsWyipN4DO=y0ZTL+3G_fPYGg@mail.gmail.com>
	<20140526104824.63F13C42129@trevor.secretlab.ca>
	<CAMuHMdUGdjVKBR5rRzZ274rf7p8XfztNRWEojH1RrZV8c_V1uA@mail.gmail.com>
	<20140526112348.907B7C421A5@trevor.secretlab.ca>
	<A6195DFD-0447-4444-AC09-501C43F09924@konsulko.com>
Date: Mon, 26 May 2014 22:33:03 +0100
Message-Id: <20140526213303.C1C73C40E11@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 May 2014 14:55:37 +0300, Pantelis Antoniou <pantelis.antoniou@konsulko.com> wrote:
> Hi Grant,
> 
> On May 26, 2014, at 2:23 PM, Grant Likely wrote:
> 
> > On Mon, 26 May 2014 12:57:32 +0200, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> >> Hi Grant,
> >> 
> >> On Mon, May 26, 2014 at 12:48 PM, Grant Likely
> >> <grant.likely@secretlab.ca> wrote:
> >>> On Tue, 20 May 2014 09:38:49 +0200, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> >>>> On Tue, May 20, 2014 at 7:50 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
> >>>>>> Why has the overlay system been designed for plugging and unpluging whole
> >>>>>> overlays?
> >>>>>> That means the kernel has to remember the full stack, causing issues with
> >>>>>> e.g. kexec.
> >>>>> 
> >>>>> Mostly so that drivers don't see any difference in the livetree data
> >>>>> structure. It also means that userspace sees a single representation of
> >>>>> the hardware at any given time.
> >>>> 
> >>>> Sorry, I don't follow the argument about the "single representation of the
> >>>> hardware".
> >>> 
> >>> Er, s/of the hardware/of the tree/. Right now the overlay design
> >>> modifies the live tree which at the same time modifies the tree
> >>> representation in /sys/firmware/devicetree. If the design was changed to
> >>> keep the overlay logically separate, then I would think we want to
> >>> expose that information to usespace also. In fact, I think we would need
> >>> to for usecases like kexec.
> >> 
> >> OK, so it does modify the real tree, and doesn't keep the actual overlays.
> >> 
> >> I was under the impression the overlay stack was also kept in memory, to allow
> >> reversal, so there was a misunderstanding.
> >> 
> >> Hence for kexec, the tree in /sys/firmware/devicetree can just be passed
> >> to the new kernel, as that's the current representation of the hardware?
> > 
> > Heeheehee. We're back where we started. The original question is whether
> > or not that is a valid approach. If the overlay represents something
> > that can be hot plugged/unplugged, then passing it through to the second
> > kernel would be the wrong thing to do. If it was a permenant addition,
> > then it probably doesn't need to be removed.
> > 
> > We do actually keep the overlay info in memory for the purpose of
> > removal exactly so we can support hot unbinding of devices and drivers
> > that make use of overlays.
> > 
> 
> We can support either method. I am not feeling any wiser about which one should be
> the default TBH, so what about exporting a property and let the platform 
> figure out which is more appropriate?

After thinking about it more, I think it is very likely that removing
all the overlays is the correct thing to do in the kexec use-case. When
kexec-ing, it makes sense that we'd want the exact same behaviour from
the kexec'ed kernel. That means we want the device drivers to do the
same thing including loading whatever overlays they depend on.

If the flattened tree was left applied, then the behaviour becomes
different.

I say always remove the overlays unless explicitly told not to, but I'm
struggling to come up with use cases where keeping them applied is
desirable.

g.


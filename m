Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab3F0Trf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 15:47:35 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:54640 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753288Ab3F0Trd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 15:47:33 -0400
Message-ID: <1372362418.21065.25.camel@cumari.coelho.fi>
Subject: Re: [PATCH] Documentation: dt: bindings: TI WiLink modules
From: Luciano Coelho <coelho@ti.com>
To: Nishanth Menon <nm@ti.com>
CC: <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        "Tony Lindgren" <tony@atomide.com>,
        linux-omap <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Thu, 27 Jun 2013 22:46:58 +0300
In-Reply-To: <51CC8E80.5030206@ti.com>
References: <1372149330-24335-1-git-send-email-coelho@ti.com>
	  <51CBC1C8.1040301@gmail.com> <1372322851.18889.53.camel@cumari.coelho.fi>
	  <20130627125131.GA27285@kahuna>
	 <1372337887.8383.12.camel@cumari.coelho.fi>
	  <CAGo_u6qbt9dANgKq49xR=1qsCpUBhmVaPL4EK04XvTw+=4Z23g@mail.gmail.com>
	  <1372339148.8383.17.camel@cumari.coelho.fi> <51CC3CEE.3050004@ti.com>
	  <1372339810.8383.20.camel@cumari.coelho.fi>
	  <CAGo_u6pWZX9gbHgBae=gcWk8i6-TnhxH1TdM9QdEDLTow6Pn5A@mail.gmail.com>
	 <1372359090.21065.12.camel@cumari.coelho.fi> <51CC8E80.5030206@ti.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-27 at 14:12 -0500, Nishanth Menon wrote:
> On 06/27/2013 01:51 PM, Luciano Coelho wrote:
> > On Thu, 2013-06-27 at 08:39 -0500, Nishanth Menon wrote:
> >> On Thu, Jun 27, 2013 at 8:30 AM, Luciano Coelho <coelho@ti.com> wrote:
> >>> On Thu, 2013-06-27 at 08:23 -0500, Nishanth Menon wrote:
> >>>> On 06/27/2013 08:19 AM, Luciano Coelho wrote:
> >>>>> On Thu, 2013-06-27 at 08:15 -0500, Nishanth Menon wrote:
> >>>>>> On Thu, Jun 27, 2013 at 7:58 AM, Luciano Coelho <coelho@ti.com> wrote:
> >>>>>>> For the actual DTS files, I could add a wilink.dtsi with enumerations
> >>>>>>> for these values so they could be used in the node definitions.  But I'm
> >>>>>>> not sure it's going to be that valuable in the end.
> >>>>>> The  way GPIO HIGH was defined might help to provide guidance I think :)
> >>>>>
> >>>>> Where? As far as I can see, the GPIO flags are defined in a bitmap.
> >>>>
> >>>> include/dt-bindings/gpio/gpio.h
> >>>
> >>> Thanks! I don't see these macros used anywhere, though.
> >> umm... I'd think you have'nt looked deep enough / lists :)
> >
> > If you mean mailing lists, you're right, I didn't.  I just did a git
> > grep for the macros and didn't find any users.
> git grep "GPIO_ACTIVE_[HIGH|LOW]" arch/arm/boot/dts/|wc -l
> 344
> on next-20130626. anyways, besides the point.
> 
> 
> >>> This seems to be a completely different thing.  This is the header that
> >>> contains the helper functions to get GPIO-related device tree nodes,
> >>> isn't it?
> >> That is true, but it also contains the flag for level which needs to
> >> be in sync with the gpio.h dts header.
> >>>> just a hint. not saying frequencies were defined in header. for systems
> >>>> that define frequencies - example cpufreq OPPs, clock node usage, we do
> >>>> not use indexing to frequency, instead, that is the responsibility of
> >>>> driver to convert frequency back to required index.
> >>>> git grep frequency Documentation/devicetree/bindings gives you how the
> >>>> precedence looks like.
> >>>>
> >>>> Personally, if given a choice, I'd go with actual frequencies rather
> >>>> than indexes.
> >>>
> >>> If I do that, I need to add also a separate flag to define whether the
> >>> XTAL clock is used or not.  For instance, we have 26MHz and 26MHz
> >>> crystal; and 38.4MHz and 38.4MHz crystal...
> >> Yes, you would have to. at the same time, it is easy for module maker
> >> to provide dtsi corresponding to exact h/w representation on his
> >> module using wilink chip without being worried about weird index value
> >> whose meaning is hidden in binding
> >
> > The module makers need to know about the bindings and read the document
> > before they specify the node in DTS.  I think for clarity, a comment in
> > the DTS file stating the actual frequency is good enough.  Simpler and
> > more efficient (in terms of DT binary size and module code size) than
> > adding the actual frequencies.
> >
> >
> >> On the flip side, It also allows driver to reject frequencies /
> >> configurations that are not supported by the corresponding chip.
> >
> > It's actually much easier to reject frequencies that are not valid with
> > the enumeration.  "if (refclock > 5) { bail_out(); }".  If I need to
> > check every frequency, I need to add an array of valid frequencies and
> > so on.  Waste of code, IMHO.
> >
> >
> >> As I said, just my 2 cents. Personally, I'd like dts files to be as
> >> readable as c files without having to dig through bindings document.
> >
> > As I said before, for readability, adding a comment with the frequency
> > is good enough.  This is what I did for PandaES's DTS (not sent out
> > yet):
> >
> > 	wlan {
> > 	     compatible = "ti,wilink6";
> > 	     interrupt-parent = <&gpio2>;
> > 	     interrupts = <21 0x4>;	/* gpio line 53, high level triggered */
> > 	     refclock = <2>;		/* 38.4 MHz */
> > 	 };
> >
> > Looks more readable to me than:
> >
> > 	wlan {
> > 	     compatible = "ti,wilink6";
> > 	     interrupt-parent = <&gpio2>;
> > 	     interrupts = <21 0x4>;	/* gpio line 53, high level triggered */
> > 	     refclock = <38400>;
> > 	     refclock_xtal = <0>;
> > 	 };
> >
> > The macro idea sounds better to me, but in this case this code is so
> > simple that I don't think it's really worth it.
> >
> > And, from another point of view, I see this as only a specification of
> > the module's details.  The frequency value is not really used anywhere
> > outside the module, so we don't see it.  I don't think there's a good
> > reason to expose the actual frequency to the kernel (and parse it back
> > to the values the firmware needs), since nothing else inside the kernel
> > will care about it.
> Overview: we are adding bindings for 
> Documentation/devicetree/bindings/net/wireless/ti-wilink.txt Which I 
> believe is intended to be generic.
> 
> Current frequencies supported for tcxoclock is the following for WiLink7
> +	0 = 19.200 MHz
> +	1 = 26.000 MHz
> +	2 = 38.400 MHz
> +	3 = 52.000 MHz
> +	4 = 16.368 MHz
> +	5 = 32.736 MHz
> +	6 = 16.800 MHz
> +	7 = 33.600 MHz
> Say wilink9 comes along and redefines this map OR introduces support for 
> 20MHz support making the map 0-8, you'd no longer be able to support 
> this map. or say a new update of firmware magically changes this mapping 
> or something unexpected.

No problem with adding 20MHz support.  Look at 6 = 16.800 MHz.  That's
already out of order, so why would 20MHz have to change the mapping?

It is true that stupid changes happen in the firmware from time to time.
But if it happens, the translation could still be done in the driver.

> If the translation and validation is done in the driver, it is trivial 
> to handle without redefining the binding and breaking older dtbs (if 
> relevant)

The validation can still be done in the driver.  I don't think anything
has to break here.  The bindings document is the de-facto specifications
of this stuff.  If something in the lower layers (ie. firmware) breaks,
the driver can do the translation without having to change anything in
the DTS.


> Indexes to another entity is always a maintenance burden in the longer 
> run and needs judicious control. If it is possible to avoid it by 
> selecting the right parameters, I am a hard advocate for the same.

I tend to agree.  But you need a balance.  In theory you're right.  But
I think if you take the real world example, it is over-engineering.

Anyway, if you *really* think this needs to be changed, I think we're in
a deadlock here and I'd like to hear other people's opinions.  I don't
mind making the change, but I'm still not convinced it is worth it,
since it just adds complexity.

And hey, this is too much bikeshedding for such a small detail.

--
Luca.


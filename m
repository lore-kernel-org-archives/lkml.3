Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569Ab3FQWXu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 18:23:50 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:39995 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab3FQWXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 18:23:49 -0400
Date: Mon, 17 Jun 2013 15:23:53 -0700
From: Olof Johansson <olof@lixom.net>
To: Jonas Jensen <jonas.jensen@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        arm@kernel.org
Subject: Re: [PATCH 2/3] ARM: mach-moxart: add MOXA ART device tree files
Message-ID: <20130617222353.GB13266@quad.lixom.net>
References: <1371040448-28742-1-git-send-email-jonas.jensen@gmail.com>
 <1371040448-28742-3-git-send-email-jonas.jensen@gmail.com>
 <20130612224952.GB8146@quad.lixom.net>
 <CACmBeS0T1n92CcGN6kR+eBcFPuwsWc+PsUx7Cms+4vbeVFhQKg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACmBeS0T1n92CcGN6kR+eBcFPuwsWc+PsUx7Cms+4vbeVFhQKg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 04:34:24PM +0200, Jonas Jensen wrote:
> Hi,
> 
> Thanks for the replies.
> 
> What isn't commented below should already be fixed.
> 
> On 13 June 2013 00:49, Olof Johansson <olof@lixom.net> wrote:
> > Hi,
> >
> > You should add a bindings description for the MOXA SoC platforms, similar to
> > how others do it, under Documentation/devicetree/bindings/arm/.
> 
> The following is now added under Documentation:
> 
>  Documentation/devicetree/bindings/arm/moxart.txt   |    8 +++
>  .../arm/moxart/moxart-interrupt-controller.txt     |   29 ++++++++++++
>  .../bindings/arm/moxart/moxart-timer.txt           |   17 +++++++
> 
> > Same goes for other device bindings below -- they all need to be added to the
> > bindings documentation. You might be better off removing some of them until you
> > post and merge the corresponding drivers.
> 
> I'll remove them for now with the intent of adding them later. Maybe
> when (and if) all drivers are posted and merged.
> 
> >> +/dts-v1/;
> >> +/include/ "moxart.dtsi"
> >> +
> >> +/ {
> >> +     model = "MOXA UC-7112-LX";
> >> +     compatible = "moxa,moxart-uc-7112-lx";
> >
> > Is there a generic board design / eval board that you can have as a fallback
> > compatible value? That way you won't have to add every board to the table in
> > the c file.
> 
> There isn't really a generic board but the same can be accomplished by
> adding "moxa,moxart" to compatible? New boards can then be added
> without patching arch/arm/mach-moxart/moxart.c.

Sounds good. See comment on the other email about checking for machine
compatible in the init setup function too, that'll work well.

> 
> >> +     mxser@98200040 {
> >> +             compatible = "moxa,moxart-mxser";
> >> +             reg =   <0x98200040 0x00000080>,        /* UART "3" base */
> >> +                             <0x982000e4 0x00000080>,        /* UART mode base */
> >> +                             <0x982000c0 0x00000020>;        /* UART interrupt vector */
> >
> > Are there other registers for other devices inbetween, or could you just do one
> > large memory area here?
> 
> No, reg could simply be 0x98200040 to 0x982000e0. I split them out as
> documentation but those could be defined in the driver instead, also
> because it's sort of easier to assign values with of_iomap.

I'd say just go with one register area, it's how most other drivers do it so
it's most familiar to someone else coming in and reading your code to fix bugs
or whatnot.

> >> +             interrupts = <31 1>;
> >> +     };
> >> +
> >> +     mac0: mac@90900000 {
> >> +             compatible = "moxa,moxart-mac0";
> >> +             reg =   <0x90900000 0x1000>,
> >> +                             <0x80000050 0x5>;                       /* MAC address stored on flash */
> >
> > This is a pretty unusal way to indicate mac address location. While I suppose
> > it works, I'd like to get the device tree maintainers in the loop. ADding them
> > to cc.
> >
> > Also, there should be a bindings doc for this device (and a driver)
> 
> I'm removing ethernet until the driver is submitted. This allows me to
> submit bindings doc later?

Yep.

> 
> > I'm also surprised that you have a 5-byte mac address. 6 bytes is much more
> > common. :)
> 
> That _is_ surprising :) Corrected to 6 bytes.

:)

> > Finally, are the two MACs using the same driver? if so, using the same
> > compatible value makes more sense.
> 
> Yes, using the same driver is the point. I see now they can use the
> same value, they'll still be probed from the DT entries.

Yeah. Let's discuss that further when the driver is ready if needed.


-Olof

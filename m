Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752320Ab3JUXZp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 19:25:45 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:36859 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449Ab3JUXZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 19:25:43 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Grant Likely <grant.likely@linaro.org>,
        Alexander Holler <holler@ahsoftware.de>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>, Balaji T K <balajitk@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jon Hunter <jgchunter@gmail.com>
Subject: Re: [PATCH] RFC: interrupt consistency check for OF GPIO IRQs
Date: Tue, 22 Oct 2013 01:26:05 +0200
Message-ID: <3264724.noW9GbyjJ9@avalon>
User-Agent: KMail/4.10.5 (Linux/3.10.7-gentoo-r1; KDE/4.10.5; x86_64; ; )
In-Reply-To: <52644C88.5060608@wwwdotorg.org>
References: <1375101368-17645-1-git-send-email-linus.walleij@linaro.org> <1805938.y3dym69kEh@avalon> <52644C88.5060608@wwwdotorg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Sunday 20 October 2013 22:35:04 Stephen Warren wrote:
> On 10/20/2013 01:41 PM, Laurent Pinchart wrote:
> > On Tuesday 17 September 2013 17:36:32 Grant Likely wrote:
> >> On Thu, 12 Sep 2013 17:57:00 +0200, Alexander Holler wrote:
> >>> Am 12.09.2013 17:19, schrieb Stephen Warren:
> >>>> IRQs, DMA channels, and GPIOs are all different things. Their bindings
> >>>> are defined independently. While it's good to define new types of
> >>>> bindings consistently with other bindings, this hasn't always happened,
> >>>> so you can make zero assumptions about the IRQ bindings by reading the
> >>>> documentation for any other kind of binding.
> >>>> 
> >>>> Multiple interrupts are defined as follows:
> >>>> 	// Optional; otherwise inherited from parent/grand-parent/...
> >>>> 	interrupt-parent = <&gpio6>;
> >>>> 	// Must be in a fixed order, unless binding defines that the
> >>>> 	// optional interrupt-names property is to be used.
> >>>> 	interrupts = <1 IRQF_TRIGGER_HIGH> <2 IRQF_TRIGGER_LOW>;
> >>>> 	// Optional; binding for device defines whether it must
> >>>> 	// be present
> >>>> 	interrupt-names = "foo", "bar";
> >>>> 
> >>>> If you need multiple interrupts, each with a different parent, you need
> >>>> to use an interrupt-map property...
> 
> ...
> 
> >> Actually, I think it is solveable but doing so requires a new binding
> >> for interrupts. I took a shot at implementing it earlier this week and
> >> I've got working patches that I'll be posting soon. I created a new
> >> "interrupts-extended" property that uses a phandle+args type of
> 
> >> binding like this:
> ...
> 
> >> device@3000 {
> >> 	interrupts-extended = <&intc1 5> <&intc2 3 4> <&intc1 6>;
> >> };
> 
> ...
> 
> > Any progress on this ? I'll need to use multiple interrupts with different
> > parents in the near future, I can take this over if needed.
> > 
> > I've also been thinking that we could possibly reuse the "interrupts"
> > property without defining a new "interrupts-extended". When parsing the
> > property the code would use the current DT bindings if an
> > interrupt-parent is present, and the new DT bindings if it isn't.
> 
> interrupt-parents doesn't have to be present in individual nodes; it can
> be inherited from the parent. That means you'd have to convert whole
> sub-trees at once.

Very good point. I agree with you, a new property is then better.

> It seems much more flexible to use a new property and hence make it explicit
> what format the data is in.

-- 
Regards,

Laurent Pinchart


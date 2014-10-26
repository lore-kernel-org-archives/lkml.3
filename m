Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751623AbaJZS1f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 14:27:35 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:35229 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbaJZS1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 14:27:33 -0400
Date: Sun, 26 Oct 2014 19:25:41 +0100
From: Beniamino Galvani <b.galvani@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Carlo Caione <carlo@caione.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jerry Cao <jerry.cao@amlogic.com>,
        Victor Wan <victor.wan@amlogic.com>
Subject: Re: [PATCH 2/3] pinctrl: meson: add device tree bindings
 documentation
Message-ID: <20141026182541.GA23020@gmail.com>
References: <1412717576-19737-1-git-send-email-b.galvani@gmail.com>
 <1412717576-19737-3-git-send-email-b.galvani@gmail.com>
 <CACRpkdb4WLX+FeEAuh=YZteaNPzq0WMN0PTTpHnMWmwTts6=Bg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdb4WLX+FeEAuh=YZteaNPzq0WMN0PTTpHnMWmwTts6=Bg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 01:53:28PM +0200, Linus Walleij wrote:
> On Tue, Oct 7, 2014 at 11:32 PM, Beniamino Galvani <b.galvani@gmail.com> wrote:
> 
> > Add device tree bindings documentation for Amlogic Meson pinmux and
> > GPIO controller.
> >
> > Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
> (...)
> > +Required properties for gpio sub-nodes:
> > + - reg: should contain address and size for mux, pull-enable, pull and
> > +   gpio register sets
> > + - reg-names: an array of strings describing the "reg" entries. Must
> > +   contain "mux", "pull" and "gpio". "pull-enable" is optional and
> > +   when it is missing the "pull" registers are used instead
> 
> So it seems segmenting the registers is done to sort of control the
> hardware versioning.
> 
> I think it's better to use the compatible string to indicate different
> versions of the hardware and then have just have one big
> regs to cover all registers.

The problem here is that the register ranges are not contiguous and
the holes in between are used by other devices, so I can't use a
single range.

> 
> > +Valid gpio sub-nodes name are:
> > + - "banks" for the standard banks
> > + - "ao-bank" for the AO bank which belong to the special always-on
> > +   power domain
> 
> I think it's unnecessary to split up banks, the compatible property
> should be enough to know how many banks this controller has
> and where they are located in relation to the base offset.

I wanted to avoid a reg property with a list of 7 ranges. Anyway, I
agree that the split seems a bit arbitrary; I'll remove it.

> > +Required properties for configuration nodes:
> > + - pins: the name of a pin group. The list of all available groups can
> > +   be found in driver sources.
> > + - function: the name of a function to activate for the specified set
> > +   of groups. The list of all available functions can be found in
> > +   driver sources.
> 
> This is interesting. I have established that for controllers mapping
> functions to groups we use
> "function" and "groups".
> 
> So for per-pin configuration, "function" and "pins" would be
> apropriate.

I will use "groups" instead of "pins" for the pinmux configuration.

Thanks!
Beniamino

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655Ab3KRJcp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 04:32:45 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:48340 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194Ab3KRJck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 04:32:40 -0500
Date: Mon, 18 Nov 2013 09:32:29 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        angus.clark@st.com, Mark Brown <broonie@linaro.org>
Subject: Re: [PATCH 02/10] mtd: st_spi_fsm: Supply all register address and
 bit logic defines
Message-ID: <20131118093229.GB13640@lee--X1>
References: <1384438956-31153-1-git-send-email-lee.jones@linaro.org>
 <1384438956-31153-3-git-send-email-lee.jones@linaro.org>
 <CACRpkdaccxcTfKc-y7rPEH1H3yua3ubLvuvTzWnMs1rOwjiVNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdaccxcTfKc-y7rPEH1H3yua3ubLvuvTzWnMs1rOwjiVNw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Nov 2013, Linus Walleij wrote:

> On Thu, Nov 14, 2013 at 3:22 PM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > Here we provide the FSM's register addresses, register bit names/offsets
> > and some commands which will prove useful as we start bulk the FMS's
> > driver out with functionality.
> >
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> OK...
> 
> > +/*
> > + * FSM SPI Controller Registers
> > + */
> > +#define SPI_CLOCKDIV                   0x0010
> > +#define SPI_MODESELECT                 0x0018
> > +#define SPI_CONFIGDATA                 0x0020
> (...)
> 
> So what we want to know here is whether this is a general-purpose
> SPI block, or if it's a special-purpose SPI block that can only be
> used for accessing flashes.
> 
> If it's the former that part should be broken out into drivers/spi
> of course...
> 
> But the register map seems a bit special-purpose so it could
> very well be that this is for flash control only. So maybe you can
> spill some beans from a datasheet here?
> 
> A clock divider at offset 0x10 already tells us that this is probably
> a PL022 derivate, just that we don't know how much it has
> been hacked with... does this thing contain AMBA identifiers
> at the end of the IO-region, usually at 0x0fe0 thru 0x0fff?

You've just opened a massive can of worms. Let me try to catch and put
them all back as quickly as possible.

The FSM Controller is a derivative of an SPI controller, but it's so
highly specialised that it can't do anything else but talk to Serial
Flash devices.

I've actually travelled down the route of separating the SPI
Controller parts to drivers/spi. It's possible to do that and perhaps
we could then use the generic m25p80 Serial Flash driver as the
back-end, but it would be incredibly complicated and would mean we'd
need to duplicate almost all of the m25p80 driver into the SPI
Controller. The Falcon SPI driver tried to do something similar, but
now looks broken due to some incompatible changes in m25p80. We also
want to avoid putting ourselves in that position of fragility.

There are a list of other reasons why this wouldn't work well. I have
asked the original author of this driver (whom I've spent quite a few
hours in face-to-face meetings with over the past couple of weeks) to 
jot them all down so I can reply to these kinds of requests, but I
just don't have it yet.

Take my word for it for now and I'll get back to you when I can.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

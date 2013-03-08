Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756338Ab3CHJA1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 04:00:27 -0500
Received: from vsp-authed02.binero.net ([195.74.38.226]:61890 "HELO
	vsp-authed-01-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756236Ab3CHJAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 04:00:24 -0500
Subject: Re: [PATCH v3] gpio: Add device driver for GRGPIO cores and
 support custom accessors with gpio-generic
From: Andreas Larsson <andreas@gaisler.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        software@gaisler.com
In-Reply-To: <CACRpkdaC9DsNj56_q33Z5N3_90Ffdq9qZeOxrFdrVSoL4wrTbQ@mail.gmail.com>
References: <1360653873-25368-1-git-send-email-andreas@gaisler.com>
	 <CACRpkdaYQSrzm_Yj3ZH9YZLC_zPJN06X-9ZM9jd7=X0OB1shXQ@mail.gmail.com>
	 <51346D7C.5080307@gaisler.com>
	 <CACRpkdaC9DsNj56_q33Z5N3_90Ffdq9qZeOxrFdrVSoL4wrTbQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Mar 2013 10:00:17 +0100
Message-ID: <1362733217.26956.2.camel@andreas>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-07 at 04:44 +0100, Linus Walleij wrote:
> On Mon, Mar 4, 2013 at 10:46 AM, Andreas Larsson <andreas@gaisler.com> wrote:
> > [Me]
> >>> +struct grgpio_priv {
> >>> +       struct bgpio_chip bgc;
> >>> +       struct grgpio_regs __iomem *regs;
> >>> +
> >>> +       u32 imask;      /* irq mask shadow register */
> >>> +       s32 *irqmap;    /* maps offset to irq or -1 if no irq */
> >>
> >>
> >> irqmap? Argh what is this... I think you want to use irqdomain
> >> for this instead. (Documentation/IRQ-domain.txt)
> >
> >
> > Yeah, that comment is not clear. An entry in the irqmap array (for a gpio
> > line) can be either -1 indicating no irq for that line or an index into the
> > array of irq:s for the of device. Thus it is simply either -1 or a valid
> > second argument to irq_of_parse_and_map.
> 
> So just make the mapping function in the irqdomain handle that?
> 
> Maybe I'm talking weird, I'm not really familiar with
> irq_of_parse_and_map().
> 
> > Given that this is generally running on SPARC, it seems irqdomain is not an
> > option (IRQ_DOMAIN is not selected by SPARC).
> 
> That has nothing to do with this. This driver can just select IRQ_DOMAIN
> in *it's* Kconfig entry.

Oh, excellent! I'll look into an irqdomain solution then.

Thanks for the feedback!

Cheers,
Andreas Larsson



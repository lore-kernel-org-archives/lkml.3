Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303Ab3GJVtf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 17:49:35 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:22996 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792Ab3GJVtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 17:49:33 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18WvAKVosBSBE/3bxHWnEYjqjn3zCR7dbA=
Date: Wed, 10 Jul 2013 17:49:22 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Matt Sealey <neko@bakuhatsu.net>
Cc: Neil Zhang <zhangwm@marvell.com>, grant.likely@linaro.org,
        haojian.zhuang@gmail.com, arnd@arndb.de,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V3 1/3] dts: change Marvell prefix to 'marvell'
Message-ID: <20130710214922.GQ11908@titan.lakedaemon.net>
References: <1373352166-10064-1-git-send-email-zhangwm@marvell.com>
 <1373352166-10064-2-git-send-email-zhangwm@marvell.com>
 <20130709124900.GG11908@titan.lakedaemon.net>
 <CAHCPf3u=Zu2-4RsWzi17rB_FmStwcf-Pt_7oRzAEnxN_w=a7cA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHCPf3u=Zu2-4RsWzi17rB_FmStwcf-Pt_7oRzAEnxN_w=a7cA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 10, 2013 at 03:50:10PM -0500, Matt Sealey wrote:
> On Tue, Jul 9, 2013 at 7:49 AM, Jason Cooper <jason@lakedaemon.net> wrote:
> > Neil,
> >
> > I agree with the need to change, however, this has been in the binding
> > documentation since v3.5.  I wish we had caught this when we decided
> > against using stock ticker symbols (not all stock markets use
> > alphabetical abbreviated names, not all companies are listed on any
> > stock exchange).
> 
> Who decided that?

Now you're going to make me dig ;-)  iirc, we were going the stock
ticker route, but then noticed that powerpc dts files had been using
"marvell,..." for a _long_ time.  How long?  I'll leave that as an
exercise for the reader. :-P  Because we shared at least the ethernet
driver with them, we decided to conform with what was already present in
the kernel and use "marvell,..." for all of the dt bindings we were
creating for kirkwood/dove/mvebu (and eventually orion5x, mv78xx0).

As for who is 'we'?

http://lists.infradead.org/pipermail/linux-arm-kernel/2012-May/101337.html

> You can't just "stop using stock ticker symbols" - FDT is inherently
> based on the original OpenFirmware device tree and therefore any
> existing bindings which are done on real OpenFirmware solutions where
> using stock ticker symbols is entirely appropriate (although, these
> days, not useful) is counter-productive.
> 
> If Marvell had originally had mrvl as their ticker, and used this in
> OF DTs (and it is..), then mrvl it stays. In the case where new
> devices are added with marvell, this is in this case wrong. You should
> keep using the old one. A good example of this; Freescale. Nobody is
> saying everyone should move to "freescale,imx-this" or
> "freescale,vybrid-that" - it's fsl and it stays fsl for
> backwards/forwards compatibility because things exist already.

I agree, that's why I'm arguing for *maintaining* backwards
compatibility.

> Any new companies can have a long, descriptive name; a privilege of
> being late to the party, you might say :)
> 
> Having an odd mix of mrvl and marvell or moving to marvell is just
> completely obtuse, whether they had that stock ticker, will have it in
> the future, it is how they're defined and you can't in good conscience
> change the binding after devices ship with it.

See above regarding the marvell ethernet driver and powerpc...

> > To do this properly, the drivers are going to have to be compatible with
> > the old and the new names, and the binding docs updated to reflect the
> > legacy name and the preferred name.
> 
> Properly would be as above. You can stop using stock tickers for new
> company names, but anything that has been defined in a device tree
> before has to stay that way, and all the manufacturer prefixes to
> device names should be the same. What you're proposing is purely
> driver bloat and increasing the size of kernel.

*I'm* not proposing to change the name, Neil is.  I'm proposing that
*iff* they chose to do that, don't break sh*t along the way.

thx,

Jason.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595AbaKLXID (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 18:08:03 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35641 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545AbaKLXIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 18:08:00 -0500
Date: Wed, 12 Nov 2014 23:06:24 +0000
From: Mark Brown <broonie@kernel.org>
To: Andrew Bresticker <abrestic@chromium.org>
Cc: James Hartley <James.Hartley@imgtec.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Ezequiel Garcia <Ezequiel.Garcia@imgtec.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-spi@vger.kernel.org
Message-ID: <20141112230624.GA3815@sirena.org.uk>
References: <1415828274-24727-1-git-send-email-abrestic@chromium.org>
 <1415828274-24727-3-git-send-email-abrestic@chromium.org>
 <20141112220740.GR3815@sirena.org.uk>
 <CAL1qeaH1rMcy37vcoHZ9xsmYs5iHz3Pp0GrC7agLmQ4Y7==iTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HmqCnFV+ySQ80OU5"
Content-Disposition: inline
In-Reply-To: <CAL1qeaH1rMcy37vcoHZ9xsmYs5iHz3Pp0GrC7agLmQ4Y7==iTw@mail.gmail.com>
X-Cookie: Some optional equipment shown.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] spi: Add driver for IMG SPFI controller
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HmqCnFV+ySQ80OU5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 12, 2014 at 02:54:57PM -0800, Andrew Bresticker wrote:
> On Wed, Nov 12, 2014 at 2:07 PM, Mark Brown <broonie@kernel.org> wrote:

> >>  drivers/spi/spi-img.c | 703 ++++++++++++++++++++++++++++++++++++++++++++++++++

> > How about spi-img-spfi?  That way if someone makes another SPI
> > controller (say a more generic one, this one seems flash specialized)
> > there won't be a collision.

> Despite the name, I believe this controller is used for generic SPI
> stuff as well.  I'm not sure if there is a separate one which is more
> generic (James?).

It would still be better to use a name less impressively generic - this
is an entire company, not even a product line.

> >> +             cpu_relax();

> > Seems random - we already relax in the data transfer?

> We don't relax in the transfers - would that be a better place to put
> it?  I thought it was better here since we reach this point once the
> TX FIFO has filled or RX FIFO has emptied.

Oh, that was the FIFO drain I was thinking of.  I guess here is fine.

> >> +     if (tx_buf)
> >> +             spfi_flush_tx_fifo(spfi);
> >> +     spfi_disable(spfi);

> > What does the enable and disable actually do?  Should this be runtime
> > PM?

> It starts/stops the transfer.  The control registers (bit clock,
> transfer mode, etc.) must be programmed before the enable bit is set
> and the bit does not clear itself upon completion of the transfer.  I
> don't think it makes sense to have this be part of runtime PM.

Perhaps these functions need to be called start() and stop() then - the
names sound like they gate the IP?

> > This will unconditionally claim to have handled an interrupt even if it
> > didn't get any interrupt status it has ever heard of.  At the very least
> > it should log unknown interrupts, ideally return IRQ_NONE though since
> > it seems to be a clear on read interrupt that's a bit misleading.

> There's a clear register actually (see the writel() above), but yes,
> an error and returning IRQ_NONE sound appropriate in the event of an
> unexpected interrupt.

Don't add the error print - the interrupt core has diagnostics already
and it won't be nice if the interrupt ends up shared.  My recommendation
was intended as an either/or.

--HmqCnFV+ySQ80OU5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUY+fwAAoJECTWi3JdVIfQ8+AH/iKP7McJD0aZPpdX46LKx+HX
KqmdqIQAipOA5CKYEXcSNnX0RbzJ1+odvGgxjnOET0KddT85SWAXqjI9ZAq5gQQQ
Kqj1SdOJ1t6lMXEmePAYlGHiWqSwrGXf+XGemwEfj20UBPmBA0u9VUvTxDYBvXeA
m44PvzhXER2yvhIJd2QOQ15DDU+6CqAMXvK4ESgrfJNWMB2tHNTNRhHsUYSsvuKj
iQAt3X+IpXbzmAnSjW1wVjke5TU/ncowYz0V0pYMeJieB1xluEjMWQNoJCXq9KLl
aG/E9Mk1saDw2Dnx/sf8zD/Oq+1OSgfU+X814KGyy5smROC2cA+6PDxW5yZFIU8=
=tazb
-----END PGP SIGNATURE-----

--HmqCnFV+ySQ80OU5--

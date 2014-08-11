Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100AbaHKMbz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 08:31:55 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:58071 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbaHKMbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 08:31:53 -0400
Date: Mon, 11 Aug 2014 13:31:46 +0100
From: Mark Brown <broonie@kernel.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>
Message-ID: <20140811123146.GA17528@sirena.org.uk>
References: <1406808468-12559-1-git-send-email-broonie@kernel.org>
 <CACRpkdaD2K4L+dF3iaXqQTsYJpoVRnRnp-4La38BWC3cRVUm7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3YrECMwokT/57evM"
Content-Disposition: inline
In-Reply-To: <CACRpkdaD2K4L+dF3iaXqQTsYJpoVRnRnp-4La38BWC3cRVUm7g@mail.gmail.com>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] gpiolib: Don't allow drivers to specify a base with DT
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3YrECMwokT/57evM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 11, 2014 at 09:26:49AM +0200, Linus Walleij wrote:
> On Thu, Jul 31, 2014 at 2:07 PM, Mark Brown <broonie@kernel.org> wrote:

> > -       if (base < 0) {
> > +       if (base < 0 || of_have_populated_dt()) {
> >                 base = gpiochip_find_base(chip->ngpio);

> But here I worry about breaking in-transition systems, e.g.
> defining part of the peripherals through DT but adding a
> GPIO device with AUXDATA, setting up base that way.

> Not that it should stay that way for sure, but it does need
> some consideration...

Could we add a flag that the boards can use to override this behaviour?

--3YrECMwokT/57evM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT6LevAAoJELSic+t+oim9tTcP/ie5aeUkoIiscmD6JMRS1FxC
ZpSwWVfyKY+jsHUCGbSXCd/2uVKrYvL6c6tu3Itpsr2oDDPp0iM53EckArmpfDt7
esp5+fzABKnvAS9JI0qXY6rUvGBqK7zMqJVhrTQSwt1MQ4xlX93MtzEGPa3pQJbP
hPlEdrRv/m14B8DNSOOpOhcRjvgdcEjCsG69yokdEeXgHTXfShdgxV0VqV5a+hea
lshZ42rWXCs8dkOBRC9pzv1CgBUVWzRM5sf7t1B/i9buvBTPcu7aZhmrSa41NArn
FNrCmxReJ0NtYdiNBhqAlzUpPIa89RRKC+2uFqbdvvFQAgKQOde7BkRK4pgmOOON
+QOslZk+CVuCvPbBCDikM/XtbSxEIC9IUuj0DRxZe15I3AFRw57gXUqkwLzI8ryY
+Hk9CkSVyfiffO47oj5Kmg0/lQkuA/jommKWJFOL0RzpqN5kVPqY+F72Y/+/+5j5
sglMFor5xaO6LcSKgOGIouvOMMrTbM45k2jmzYF7+TKuMcGp6meHkL9yyBSMNOOu
OELadzrW3p3Vz3Lw0m2j3PRb5jkUMChLzXBlK/IU636sNRjiurVtCq+C3Y1N1II/
fqMm6BUOWUAqLE/VY+czNasLHd7Bazfgk4deiDbA3+9Acyt5ZGRCYdzJ8HURaES0
kjIcLZN4Q6eErkkkFlgn
=ewhf
-----END PGP SIGNATURE-----

--3YrECMwokT/57evM--

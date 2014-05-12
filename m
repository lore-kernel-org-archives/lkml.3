Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917AbaELTpF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 15:45:05 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33162 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751937AbaELTpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 15:45:03 -0400
Date: Mon, 12 May 2014 21:42:41 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: Re: [PATCH] RFT: pinctrl: sunxi: convert to GPIO irqchip helpers
Message-ID: <20140512194241.GF17154@lukather>
References: <1399621082-10712-1-git-send-email-linus.walleij@linaro.org>
 <20140511212514.GV7047@lukather>
 <CACRpkdZip4S7ySAVA4xtXxU-Y5DeXfVjK67aJOe_RiXG7iT15g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ls2Gy6y7jbHLe9Od"
Content-Disposition: inline
In-Reply-To: <CACRpkdZip4S7ySAVA4xtXxU-Y5DeXfVjK67aJOe_RiXG7iT15g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Ls2Gy6y7jbHLe9Od
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 12, 2014 at 11:29:11AM +0200, Linus Walleij wrote:
> On Sun, May 11, 2014 at 11:25 PM, Maxime Ripard
> <maxime.ripard@free-electrons.com> wrote:
>=20
> > What I did so far is having a single domain, with the same handler
> > registered for all the interrupts, and the various interrupts from the
> > various banks just being at a different offsets in the domain.
> >
> > Basically, something like that:
> > http://code.bulix.org/ym3zuv-86191
> >
> > Do you know if it would be possible to use the generic gpiolib
> > behaviour in such a case?
>=20
> Basically the helpers are for the simple case where every pin
> can fire an independent interrupt.
>=20
> Since there is just one single irqdomain for the entire chip, the
> helpers require that all mappings go through the same domain.
>=20
> If having several domains or other split-up results in more
> elegant code, then code another solution locally, because we
> just want to cover the generic cases, the special cases will still
> be special.
>=20
> Unless you see some really elegant way forward of course...
> always choose the most elegand refactoring if you can.

Ok, I'll see what I can come up with then, and give your patch some
testing.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--Ls2Gy6y7jbHLe9Od
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTcSQxAAoJEBx+YmzsjxAgNscP/3rDGpAlNkgNw+nwq7f6/Ohs
V2jdFPviXU5R0J3ylIZHX1Zv5aqvoOQSdFbW1HKNie9s8mudIHe9GDest2Dg5LVg
OxNUt8DG9zrnIL6z4Q6Zt+xFJO/9qi5hDxCF7qZNeRNj7mh38OK1oneX9eM+LRiG
+P3EZS3jbSdcBMh7Z8oPN+P+12vHFkq1sz9f0QgxJPPc6LQn+vppfftHH1Z80fXw
3vXe4j4IltrqkbVZsxHI6wGZz0KazdVgDS6w0tpAzNUQKEGaUkVcXI6LB4AM+yMm
V8EiagqgWBSU/ZwibF4gIlyx/IsTuC4jEr0ccKLDQT4CrnkAIdoj8ytKg0btoiig
oIdbREx9WRGc+ChrNzGKc/on6T06uhtNht7tlkULGJRgqUtzEalAOBgh1huvLF1D
jvHmWSdX7y3gzUuF7MSrHj3xWRfOlrqhFMqlyFi2jBoWvtYxMrm6+lxNatIsuMEX
smPz0gQBmX6iVZiGeF/QeA+SAShe8J6VTEFmMv687rBoR/QcG29oXpEVfUhnYvhm
n/fhEXnqZLuhIV79wdSGV04ApggHAIajlohLP4yAa9r/bJekBnEBYLJjheesQ5oq
7YKsiJdzTYTR+9p+xle8k7E0IzVMoUU97cJ/3LgHgqQM6iV/Fh/aGkCzm/aEOwNh
MhkxV/uOja5u868UOSm4
=8y6i
-----END PGP SIGNATURE-----

--Ls2Gy6y7jbHLe9Od--

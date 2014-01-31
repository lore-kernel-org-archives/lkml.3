Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382AbaAaOZZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 09:25:25 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39654 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753859AbaAaOZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 09:25:23 -0500
Message-ID: <1391178285.4405.78.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 3/3] net: via-rhine: add OF bus binding
From: Ben Hutchings <ben@decadent.org.uk>
To: Alexey Charkov <alchark@gmail.com>
Cc: netdev <netdev@vger.kernel.org>, Tony Prisk <linux@prisktech.co.nz>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Roger Luethi <rl@hellgate.ch>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 31 Jan 2014 14:24:45 +0000
In-Reply-To: <CABjd4Yx5HtbGjo_ZsOJ5SvqFQZey1fv5K36PD=D9fUUn0SanVQ@mail.gmail.com>
References: <1385227995-3956-1-git-send-email-alchark@gmail.com>
	 <1390823503-24087-1-git-send-email-alchark@gmail.com>
	 <1390823503-24087-4-git-send-email-alchark@gmail.com>
	 <1390834654.2735.148.camel@deadeye.wl.decadent.org.uk>
	 <CABjd4Yz2Kfed_qBfSAEXoAcVxfsmhTBA-83YJ9_iSwPZ+r1qYQ@mail.gmail.com>
	 <1390866011.4405.2.camel@deadeye.wl.decadent.org.uk>
	 <CABjd4Yx5HtbGjo_ZsOJ5SvqFQZey1fv5K36PD=D9fUUn0SanVQ@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-Ukx7+zuu4lv+42VvjKMo"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 80.76.121.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Ukx7+zuu4lv+42VvjKMo
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2014-01-28 at 22:31 +0400, Alexey Charkov wrote:
> 2014/1/28 Ben Hutchings <ben@decadent.org.uk>:
> > On Mon, 2014-01-27 at 19:34 +0400, Alexey Charkov wrote:
> >> 2014/1/27 Ben Hutchings <ben@decadent.org.uk>:
> >> > On Mon, 2014-01-27 at 15:51 +0400, Alexey Charkov wrote:
> >> >> This should make the driver usable with VIA/WonderMedia ARM-based
> >> >> Systems-on-Chip integrated Rhine III adapters. Note that these
> >> >> are always in MMIO mode, and don't have any known EEPROM.
> >> > [...]
> >> >> --- a/drivers/net/ethernet/via/Kconfig
> >> >> +++ b/drivers/net/ethernet/via/Kconfig
> >> >> @@ -19,7 +19,7 @@ if NET_VENDOR_VIA
> >> >>
> >> >>  config VIA_RHINE
> >> >>         tristate "VIA Rhine support"
> >> >> -       depends on PCI
> >> >> +       depends on (PCI || USE_OF)
> >> >>         select CRC32
> >> >>         select MII
> >> >>         ---help---
> >> >
> >> > This seems like the right thing to do, but it means you need to add
> >> > #ifdef CONFIG_PCI and #ifdef CONFIG_USE_OF around the driver structu=
res
> >> > and related functions.
> >>
> >> Frankly, I would like to avoid that if possible (as pointed out in the
> >> cover email), as I believe we would get a cleaner driver without
> >> #ifdef. This is also the way it was done in via-velocity, and it works
> >> just fine.
> >
> > OK, I'm surprised that all the PCI functions have dummy definitions.
> >
> >> > You should compile-test in configurations that have just one of thos=
e
> >> > dependencies enabled.
> >>
> >> This has been compile-tested and runtime-tested in OF-only
> >> configuration on WM8950, and Roger also tested it in PCI-only
> >> configuration, so it seems to work fine.
> > [...]
> >
> > Good, then I have no objection.
>=20
> Thanks Ben! Would it be fine to add your Reviewed-by at the next
> iteration, once I fix indentation of function arguments and
> dev_is_pci()?

Sorry, I don't think I know enough to claim that I've reviewed the whole
thing properly.

Ben.

--=20
Ben Hutchings
It is easier to write an incorrect program than to understand a correct one=
.

--=-Ukx7+zuu4lv+42VvjKMo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUAUuuyLee/yOyVhhEJAQqvzg//caUdw/Wy0UwppsS6BH3mjNN2YpXpreaL
XOXbY2Q9Ii4ficGl3/bs8aHs0soIMYUa8p87nXubSZrb8AF2bULav7Su/HgKJsyX
AaYRIAMrPPkooFQPUoyL32LSMMVXV8K8+Inrc9H+Xf8IpwpKs+HDILw52zhL7The
LpG8SkeDEQveKkSeOF5l/DARpM0ZlSINvSSpBeN5BFCXJ7NVgzONX/fkBrw0ZbbD
zWiyk31TjVySuGrcf/z8031GLj0t1fG2ZnCiFreMUPeFd/i9c6XhEhxUrz8nnZQp
k1NVYjGRIf6BQVpm1xT3N8tMV5RAY8yimQo3V2quIbvnOH+35+TgpqT2caWN8lKh
c39XtdujUe/G2JsG31nP6tAIvJYY3wEFaIIfIFN5s5EwbJkSeR9WpSMeYCw84y5r
Hi01TphAjaKDZpEprzwzURfSvp6suu8hV3gIdXtmAlfaInsolfoFJsw1l83V5mcG
nnZS/a8gIR5V4qbMg2zilGdxSySKDTGspENimT3lp59tlo9Ob4dRFhTuuYlRBt97
OUQwcPKqeHxAYbzZ15spztPFO9p3ckLY6Bt5ZIqR2m2C/I3X2N4Xspj/Yw+TIxte
+M6NREFIaAUN4nz6zgU+8A0NVFzGYUHEhpSGMswYDD79L2D3r5EXCP+tyNBKZiwH
owAkBVdKcSY=
=iOTg
-----END PGP SIGNATURE-----

--=-Ukx7+zuu4lv+42VvjKMo--

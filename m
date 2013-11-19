Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751732Ab3KSImx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 03:42:53 -0500
Received: from mail-bk0-f44.google.com ([209.85.214.44]:61168 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529Ab3KSImu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 03:42:50 -0500
Date: Tue, 19 Nov 2013 09:42:24 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rhyland Klein <rklein@nvidia.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Bernie Thompson <bhthompson@chromium.org>,
        Andrew Bresticker <abrestic@chromium.org>
Subject: Re: [PATCH 1/3] mfd: cros ec: spi: Add delay for raising CS
Message-ID: <20131119084223.GC31504@ulmo.nvidia.com>
References: <1384770649-8593-1-git-send-email-treding@nvidia.com>
 <20131118114810.GE30853@e106331-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kfjH4zxOES6UT95V"
Content-Disposition: inline
In-Reply-To: <20131118114810.GE30853@e106331-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kfjH4zxOES6UT95V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 18, 2013 at 11:48:10AM +0000, Mark Rutland wrote:
> On Mon, Nov 18, 2013 at 10:30:47AM +0000, Thierry Reding wrote:
> > From: Rhyland Klein <rklein@nvidia.com>
> >=20
> > The EC has specific timing it requires. Add support for an optional del=
ay
> > after raising CS to fix timing issues. This is configurable based on
> > a DT property "google,cros-ec-spi-msg-delay".
> >=20
> > If this property isn't set, then no delay will be added. However, if set
> > it will cause a delay equal to the value passed to it to be inserted at
> > the end of a transaction.
> >=20
> > Signed-off-by: Rhyland Klein <rklein@nvidia.com>
> > Reviewed-by: Bernie Thompson <bhthompson@chromium.org>
> > Reviewed-by: Andrew Bresticker <abrestic@chromium.org>
> > Cc: Rob Herring <rob.herring@calxeda.com>
> > Cc: Pawel Moll <pawel.moll@arm.com>
> > Cc: Mark Rutland <mark.rutland@arm.com>
> > Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
> > Signed-off-by: Thierry Reding <treding@nvidia.com>
> > ---
> >  Documentation/devicetree/bindings/mfd/cros-ec.txt |  4 +++
> >  drivers/mfd/cros_ec_spi.c                         | 30 +++++++++++++++=
++++++++
> >  2 files changed, 34 insertions(+)
> >=20
> > diff --git a/Documentation/devicetree/bindings/mfd/cros-ec.txt b/Docume=
ntation/devicetree/bindings/mfd/cros-ec.txt
> > index 5f229c5f6da9..fb3034a87ae0 100644
> > --- a/Documentation/devicetree/bindings/mfd/cros-ec.txt
> > +++ b/Documentation/devicetree/bindings/mfd/cros-ec.txt
> > @@ -17,6 +17,10 @@ Required properties (SPI):
> >  - compatible: "google,cros-ec-spi"
> >  - reg: SPI chip select
> > =20
> > +Optional properties (SPI):
> > +- google,cros-ec-spi-msg-delay: This property is how long of a delay, =
in usecs,
> > +  to use on the last transfer of a message, to force time between tran=
sactions.
> > +
>=20
> Lose the "This property is", that's obvious from the structure of the
> document.

Will do.

> It would be nice to have an explanation in the binding document as to
> _why_ you might want to do this (e.g. the HW expects the rising edge to
> come some number of uS after the data, if it comes too early it
> explodes).

=46rom what I can tell, this might differ on the exact variant of the EC,
but generally it seems that when the interval between two transactions
isn't long enough the EC won't be able to respond properly in time and
cause subsequent transactions to hang. Perhaps Rhyland, Bernie or Andrew
are more familiar with the details and therefore can provide a better or
more accurate explanation.

> Otherwise this looks fine to me.

Thanks,
Thierry

--kfjH4zxOES6UT95V
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSiyRvAAoJEN0jrNd/PrOh6WMP/izwiUWLUoqH6v/krQzhJW24
CsyHdFQxWBjVnFvPjcxPuJkA0inOC8vvxvvOZxVu/tMqZgkcz9XSzZYp+R/71wam
lzMjp+8IS8iHROeQAEMZEA3lErUzKPP5kZXzJFlSrRb72/vUVjZKyN3iQ0Lnl8KB
ktbH3mLdayIV5PsD4MtCRjvE/P8H/cFu5G+81+oda2nrL5PrNT22AmicPNAtPTrQ
F1LdVPTjKiOYd5qtesoi9xfaB1o1+lTXKOpVMzwqFujVmC9tBklI0gze9HQmkGqH
ReuGm+kY73w67sMaoKrJs6+jQW54A4Ax49qEp6QSV9xI3Iq9K1XMWvWyNxA/+c8G
T5zfgsr6GoCBaz8pmJHoas0gk9uFR6Qqr1d4pQRc1ped2YDuwDeZ5IGkaHnhPs+C
I9or/ZvFN5/wYqk7JB25ajuy3s3zX4hLFrqY1ZEpjt3DPHhJ1si5HdBNvlFf/D2G
BUBcq6RSh3VwkTzkmivJmlIgZMIjbf1iM+26xTigAiH4uLf4x7LTX3cN+1eKqdGq
hzogI5095mohvnZuG+XB8AG+ISMdIdGeMNqif/Iyl5EwP1haLSbxanyaGqjs27eN
FUXByTD9QWCLs7NOvsfxZhA+tfIa2ONUnV5ZV4CC+VIDOU/9I83ahXCzdnjtClcP
3Uq26ccabAUQHTQ/Fp5y
=NMqI
-----END PGP SIGNATURE-----

--kfjH4zxOES6UT95V--

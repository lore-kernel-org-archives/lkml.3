Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868AbaJBSF4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 14:05:56 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37733 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208AbaJBSFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 14:05:54 -0400
Date: Thu, 2 Oct 2014 13:05:53 -0500
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: Michael Welling <mwelling@ieee.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Cameron <jic23@kernel.org>, <linux-iio@vger.kernel.org>,
        <pmeerw@pmeerw.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND PATCH] iio: light: add support for TI's opt3001 light
 sensor
Message-ID: <20141002180553.GI7933@saruman>
Reply-To: <balbi@ti.com>
References: <20140924143610.GA17997@saruman>
 <20140925221619.GA10644@saruman>
 <20140927041959.GA28445@saruman>
 <20140929140227.GD32403@saruman>
 <20140929183856.GA11871@sysresccd>
 <20140929185325.GA1939@saruman>
 <20140929223833.GA13111@sysresccd>
 <20140929224638.GA21681@saruman>
 <20140929234159.GB13111@sysresccd>
 <20140930212204.GC13806@saruman>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FK65GREB+Evh/hTL"
Content-Disposition: inline
In-Reply-To: <20140930212204.GC13806@saruman>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--FK65GREB+Evh/hTL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Sep 30, 2014 at 04:22:04PM -0500, Felipe Balbi wrote:
> On Mon, Sep 29, 2014 at 06:41:59PM -0500, Michael Welling wrote:
> > On Mon, Sep 29, 2014 at 05:46:38PM -0500, Felipe Balbi wrote:
> > > Hi,
> > >=20
> > > On Mon, Sep 29, 2014 at 05:38:33PM -0500, Michael Welling wrote:
> > > > > > > Alright, this is already ridiculous. Andrew, if I resend the =
patch can
> > > > > > > you apply it since maintainer has been ignoring this thread a=
nyway ?
> > > > > > >=20
> > > > > >=20
> > > > > > Do you reall think this is the best way to approach this?
> > > > >=20
> > > > > when maintainer doesn't respond for weeks, yeah! Sure it is.
> > > > >=20
> > > > > > Perhaps it would be better to explain what each field of the
> > > > > > configuration register does and then we can move on.
> > > > >=20
> > > > > perhaps Jonathan could tell me exactly what he wants because I ca=
n't
> > > > > handle back-and-forth anymore. Specially when he complains about =
stuff
> > > > > he asked me to modify himself.
> > > > >
> > > > > > In particular the OPT3001_CONFIGURATION_L field needs to be exp=
lained
> > > > > > such that the ABI can be properly applied.
> > > > > >=20
> > > > > > Looking at the docs for the Windows demo program the field is a=
ssociated
> > > > > > with a latch configuration. What does this bit field actually d=
o?
> > > >=20
> > > > Still no technical information. Without all the facts how can you e=
xpect
> > > > him to tell you what he wants?
> > >=20
> > > yeah, because clearly he doesn't know himself, right ?
> >=20
> > Could you explain how it works to me then?
>=20
> checking how much of the docs I can expose now, gimme a couple days.

alright, here's a snippet of what's on preliminary docs:

Latch field (read or write).
The latch field controls the functionality of the interrupt reporting
mechanisms: the INT pin, the flag high field (FH), and flag low field (FL).
This bit selects the reporting style between a latched window-style compari=
son
and a transparent hysteresis-style comparison.

0 =3D The device functions in transparent hysteresis-style comparison opera=
tion,
where the three interrupt reporting mechanisms directly reflect the compari=
son
of the result register with the high- and low-limit registers with no
user-controlled clearing event. See the Interrupt Operation, INT Pin, and
Interrupt Reporting Mechanisms section for further details.

1 =3D The device functions in latched window-style comparison operation, la=
tching
the interrupt reporting mechanisms until a user-controlled clearing event.

[...]

7.4.2.2 Transparent Hysteresis-Style Comparison Mode
The transparent hysteresis-style comparison mode is typically used when a
single digital signal is desired that indicates whether the input light is
higher than or lower than a light level of interest. If the result register=
 is
higher than the high-limit register for a consecutive number of events set =
by
the fault count field, the INT line is set to active, the flag high field is
set to 1, and the flag low field is set to 0. If the result register is low=
er
than the lowlimit register for a consecutive number of events set by the fa=
ult
count field, the INT line is set to inactive, the flag low field is set to =
1,
and the flag high field is set to 0. The INT pin and flag high and flag low
fields do not change state with configuration reads and writes. The INT pin=
 and
flag fields continually report the appropriate comparison of the light to t=
he
low-limit and high-limit registers. The device does not respond to the SMBus
alert response protocol while in either of the two transparent comparison m=
odes
(configuration register, latch field =3D 0).

--=20
balbi

--FK65GREB+Evh/hTL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJULZQAAAoJEIaOsuA1yqREQTEP/1cZ0zj52i8KKfyHA0r3r0m0
mJf4kikkBs3Cty/oxC4DLFVb2rR5bfYdSTp2CeFaqdN7/nQf/2PhW+zy0kIIv3JP
VLThdUcQkIaF+bSYHtHQ/BNzX8LcTbxnEGcHEC7f13VbKkXka0yLCCejvq6wq0ja
2LGBldi8hiwGvMx/fgIY3GKr3vfFFtIF6Nyw4v6xR/RmgxgzM04S1jB0EVOb++Bx
OmTxRp7aYr4j86nfPY7QGXGGsO/N3mzlv1siMutChZV39pADfymkZH8WfQh4BBUD
d9TJBPdNK+eRLw6/8pSEg082vVjbmMRUyloJqrR25fE2/4f3NJTH1CDzn9FTvKGV
NpekSPsGOVUtlA721Ic32r9XcAekgWT13XgWoUNCo/Z68X7XJb036VdDMPd4WL4v
gdfr8avOThlCJ/W49tMw2PvCG+DKWwDP4OwzfdcqA4Rd4ujTXJoi5+x01slZkuKe
ULeOeJ0lluOTcmtg9q21P29VpXsX3GaJg1Yfo/mevUBjOZr036HvmfehBCIj7zIM
dCCVdKp+aVLcbtyTmzt7uXavwmlz+AqYIYTC8/XOc8Vj/GMqb0HAGhE9igQSdeJM
OTOLqghUAR9JL9wIcx+8FMowgbfbTXOMN7kPGTEttC4W9XYrmskDpnyy1Zo+j4/U
n+0HKKA5sFwX6Bcn/UQv
=Pg79
-----END PGP SIGNATURE-----

--FK65GREB+Evh/hTL--

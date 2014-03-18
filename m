Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339AbaCRG2C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 02:28:02 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46397 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753019AbaCRG17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 02:27:59 -0400
Message-ID: <5327E74A.8030705@ti.com>
Date: Tue, 18 Mar 2014 08:27:22 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Robert Schwebel <r.schwebel@pengutronix.de>,
        Grant Likely <grant.likely@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Greg KH <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Rob Herring <robh+dt@kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: Re: [GIT PULL] Move device tree graph parsing helpers to drivers/of
References: <1394126000.3622.66.camel@paszta.hi.pengutronix.de> <5321CB04.6090700@samsung.com> <20140314070505.GV1629@pengutronix.de> <5247436.pV9jXGKXCJ@avalon>
In-Reply-To: <5247436.pV9jXGKXCJ@avalon>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="HuPr66pmeGGMMPoRd6Wom8fe3jAgko9Fm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--HuPr66pmeGGMMPoRd6Wom8fe3jAgko9Fm
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 18/03/14 01:30, Laurent Pinchart wrote:

> I agree with you. I know that DT bindings review takes too much time, s=
lows=20
> development down and is just generally painful. I'm trying to reply to =
this e-
> mail thread as fast as possible, but I'm also busy with other tasks :-/=

>=20
> The lack of formal consensus comes partly from the fact that people are=
 busy=20
> and that the mail thread is growing big. There's still two open questio=
ns from=20
> my view of the whole discussion:
>=20
> - Do we really want to drop bidirectional links ? Grant has been pretty=
 vocal=20
> about that, but there has been several replies with arguments for=20
> bidirectional links, and no reply from him afterwards. Even though that=
=20
> wouldn't be the preferred solution for everybody, there doesn't seem to=
 be a=20
> strong disagreement about dropping bidirectional links, as long as we c=
an come=20
> up with a reasonable implementation.
>=20
> - If we drop bidirectional links, what link direction do we use ? There=
 has=20
> been several proposals (including "north", which I think isn't future-p=
roof as=20
> it assumes an earth-centric model) and no real agreement, although ther=
e seems=20
> to be a consensus among several developers that the core OF graph bindi=
ngs=20
> could leave that to be specified by subsystem bindings. We would still =
have to=20
> agree on a direction for the display subsystem of course.
>=20
> If my above explanation isn't too far from the reality the next step co=
uld be=20
> to send a new version of the DT bindings proposal as a ping.

I agree with the above.

However, I also think we should just go forward with the bidirectional
links for now. The bindings for bidir links are already in the mainline
kernel, so they can't be seen as broken.

When we have an agreement about the direction, and we've got common
parsing code, it's trivial to convert the existing links to single
direction links, and the old dts files with bidir links continue to work
fine.

This is what I'm planning to do with OMAP display subsystem, as I
_really_ want to get the DT support merged for 3.15. The current mix of
pdata + DT that we have for OMAP display is an unmaintainable mess.

So unless I get a nack from someone (I've pinged Grant twice about
this), or someone explains why it's a bad idea, I'll push the OMAP
display bindings [1] for 3.15 with bidir bindings, and change them to
single-dir later.

Note that I did remove the abbreviated endpoint format that I had there
earlier, so now the bindings are fully compatible with the v4l2 bindings.=


 Tomi

[1] http://article.gmane.org/gmane.linux.drivers.devicetree/63885



--HuPr66pmeGGMMPoRd6Wom8fe3jAgko9Fm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTJ+dLAAoJEPo9qoy8lh711zsP/RpStdfq4S+pzU/vDxItiGos
y1i+9WQMNBWXRHhx8ZYYnF8NaDsLoIxGfcInMeH9jSxkkvcqnfcZP5teSKdZrhQF
HxyiL4KZF2Fv4K2dDOKzTKttSFLKI6eDxsfO3uKibU2jBx3/tRpZoS6ha2ZoU0Bq
pxjLXbhVzIGkTzPjByy5eTmaMretDAzmSNnRZOhrN2eBINnLnPOfG/7cd3NfgeZv
N6J8H2TVtPAyT5RBwuqgqu9Nn8iVGt6H/JmvobKblBF+4Jmf1CGGOWGnI/gL8kjd
iQ9vVJyb2hKYaNFDmwtXuHX6I7nJnVAzhjZ42fvCgbMIR48Yc4VE5KiQ7QONQB7n
ff6zaPRdeTgQJ01+3yKmD/X2MO+TPfKQbDOKKVZfXSbNdVP4vYldzFKs503pmh1d
oYndnQkEigTdZlxo9X9u2asc8KOquSyiTc0UvcN4F6zRNH7Od/uc+8BRO+ASK5s0
Mq2Vo78+JPGbmHygsHoxPpwUxJCywOLTWxZoOkic4bV5LyLhJXfmpTgj2+MoXtI/
HyhUc4Z7a4sRTspkGf8kFqonJCo6k0x1M4CnxBiZ2l3pck0chYKe5MhCzkYaIm/m
sg2ec0WO18NKVZGABCBOoUozIbcASc0KWPpDmcdVDePQW2bxgN+ihPxC1OpiKWj+
UXqlJN6TtZ2tDVNQBVb5
=NAN+
-----END PGP SIGNATURE-----

--HuPr66pmeGGMMPoRd6Wom8fe3jAgko9Fm--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086Ab3GPJml (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 05:42:41 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:41594 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815Ab3GPJmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 05:42:40 -0400
Date: Tue, 16 Jul 2013 12:42:12 +0300
From: Felipe Balbi <balbi@ti.com>
To: Hein Tibosch <hein_tibosch@yahoo.es>
CC: <balbi@ti.com>, Tony Lindgren <tony@atomide.com>,
        linux-i2c <linux-i2c@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i2c-omap: always send stop after nack
Message-ID: <20130716094212.GL8880@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <51E50217.1000507@yahoo.es>
 <20130716090300.GG8880@arwen.pp.htv.fi>
 <51E5137B.7000302@yahoo.es>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="q8dntDJTu318bll0"
Content-Disposition: inline
In-Reply-To: <51E5137B.7000302@yahoo.es>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--q8dntDJTu318bll0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jul 16, 2013 at 05:33:47PM +0800, Hein Tibosch wrote:
> On 7/16/2013 5:03 PM, Felipe Balbi wrote:
> > Hi,
> >
> > On Tue, Jul 16, 2013 at 04:19:35PM +0800, Hein Tibosch wrote:
> >> Hi Vikram,
> >>
> >> On a OMAP4460, i2c-bus-3:
> >>
> >> A driver (lm75) is causing many 'timeout waiting for bus ready' errors.
> >> SDA remains high (as it should), but SCL remains low after a NACK.
> >> The bus becomes _unusable for other clients_.
> >>
> >> While probing, "lm75" writes a command, followed by a read + stop,
> >> but the write command is NACK'd. The chip does accept other writes/rea=
ds,
> >> it just refuses to ack invalid commands.
> >>
> >> Can you tell me if the patch below would make any sense? Or is it the
> >> responsibility of the client to reset the i2c_smbus?
> > patch below breaks repeated start.
> Hi,
>=20
> No, after the NACK, no more commands are being processed,
> including a repeated start. omap_i2c_xfer() returns -EREMOTEIO
> without ever freeing the bus.
>=20
> The bus is left in an impossible state with SCL constantly low
> and all next commands (to different chips) will therefore get
> a -ETIMEDOUT
>=20
> With this patch, the bus will become idle again and new commands
> can be processed normally

but you mentioned that if you have IGNORE_NAK set, everything is fine,
since lm75 will get a return value of 0 and things will work just fine,
right ?

Also, you also said that the chip 'refuses to ack invalid commands', why
are you sending invalid commands to start with ? This could be a bug in
i2c-omap.c, sure, but let's try to figure out why IGNORE_NAK helps and
why is lm75 driver sending invalid commands.

--=20
balbi

--q8dntDJTu318bll0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR5RV0AAoJEIaOsuA1yqREpygP/ipVcvfnN78uLBUqhCHYv7MQ
AEcY4FGzhVz5NnfwqKU15iz8EWT1HBEjXzQAFmcph6bKM+w+aHeLxoaYJFOKjcZN
wgysI8q4xWMizjrQOgXprzMg3TYUW0VLVgZ3GJDILMpzCyp7MfZ9mT111d52ERVL
MSz0v0Q+rXmJcKXJpbIPkpffYEGw2oI6/p1xsPP3vanR5abmSkq1V0h99mYEXF7k
t0vBipPtnIRJJ8yCfkCNmXrtEqJFdBkIpUvV9g8Fg6l1a9XDiVkrJd2vC33n3URO
YiOl6D90XVutBYxQQUgDCUZZ4oyYve1zaT7ZduPSlrixnKcxo+FnciGKS3qY0MQj
qqDhZjpuC/BN9TbjLdFnBhzSDUvSSk2RhCczEcz0LKXAckGTyTqVgYDh0g1a1yAT
4z/RUuUpxgOVYnh0Zbdek0YtUC3gBqG7JScOy9PCzjMgZVJC1bWxefRk288GHtB9
BDRwz3L37zE5yj/rK1cIENswNoOYvo6D38tIFwpoaE7xfRiKLj/EyYnhSS9ysXip
ajBV0qjjyJaYwyaFutXmoelxaOHOXSqtxqw+qlF+EisVxwYupKDq4TWfdNGUPn3h
ordXYiXbes8mnbJyi03rzx5XsWWFRkU753Mr1bxZpVRlw3tB+uFKNcFi9+JWTMyT
Ey+4jhFsHl90lnNZMDy5
=5TVr
-----END PGP SIGNATURE-----

--q8dntDJTu318bll0--

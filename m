Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751786AbaLLFGT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 00:06:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44863 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069AbaLLFGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 00:06:18 -0500
Date: Fri, 12 Dec 2014 16:06:07 +1100
From: NeilBrown <neilb@suse.de>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Rutland <mark.rutland@arm.com>, Jiri Slaby <jslaby@suse.cz>,
        NeilBrown <neil@brown.name>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] TTY/slave: add driver for w2sg0004 GPS
Message-ID: <20141212160607.361d20db@notabene.brown>
In-Reply-To: <20141211231100.05782a30@lxorguk.ukuu.org.uk>
References: <20141211214801.4127.93914.stgit@notabene.brown>
	<20141211215944.4127.57146.stgit@notabene.brown>
	<20141211231100.05782a30@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 3.10.1-162-g4d0ed6 (GTK+ 2.24.25; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/bLC/IEv4J8WX/Uoqrn=Vqhz"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/bLC/IEv4J8WX/Uoqrn=Vqhz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 11 Dec 2014 23:11:00 +0000 One Thousand Gnomes
<gnomes@lxorguk.ukuu.org.uk> wrote:

> > +w2sg0004 UART-attached GPS receiver
> > +
>=20
> I'm wondering why it's tied to the w2sg0004
>=20
>=20
> > +struct w2sg_data {
> > +	int		gpio;
> > +	int		irq;	/* irq line from RX pin when pinctrl
> > +				 * set to 'idle' */
> > +	struct regulator *reg;
> > +
> > +	unsigned long	last_toggle;	/* jiffies when last toggle completed. */
> > +	unsigned long	backoff;	/* jiffies since last_toggle when
> > +					 * we try again
> > +					 */
> > +	enum {Idle, Down, Up} state;	/* state-machine state. */
> > +	bool		requested, is_on;
> > +	bool		suspended;
> > +	bool		reg_enabled;
> > +
> > +	struct delayed_work work;
> > +	spinlock_t	lock;
> > +	struct device	*dev;
> > +
> > +	struct rfkill	*rfkill;
>=20
> So its
> - a regulator (optional)
> - an irq (optional)
> - a gpio  (could be optional)
> - an optional rfkill
> - a pulse time (10ms fixed)
> - a backoff time (1 second fixed)
>=20
>=20
> It looks identical to half a dozen other widgets that are found in
> Android phones. Would it perhaps be better to make the tiny tweaks to
> make it generic
>=20
> - make the timers configurable
> - make the pulse time or high/low selectable for on/off
> - make the gpio optional
>=20
> and just have one driver with the right DT for all similar devices?
>=20
> Am I missing some w2sg004 specific bits here ?

There is particular behaviour that the device is both turned on and turned
off by toggling a GPIO, and the only way to detect which state it is in is
to watch the RX uart line (by reconfiguring it as a GPIO).

I'm sure that could describe other devices, but I don't personally know of
any.

I want to avoid premature generalisation.   When we have another device it
would certainly make sense to extend this driver to support the new device.
Values like the timeouts could be tied to the particular 'compatible' value.

I guess the one drive could support both of my devices, as the simpler one
just needs a regulator to be enabled/disabled, and this driver can do that.

But then we would need a name for this driver.  "generic.c" ???

>=20
>=20
> I think the general model is right, and there will be other slaves that
> don't fit the pattern but I do think this one could be generalised.

Thanks,
NeilBrown

>=20
> Alan
>=20


--Sig_/bLC/IEv4J8WX/Uoqrn=Vqhz
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVIp3vznsnt1WYoG5AQKYIBAAnEJCBDk6Dv4tQitreni4dxr35vceIfxt
mAqE/J+F+OwRGdzVq1gQmF31wMTIOoFLBq/c/afkdXTAxL26T03HYKCpwL7ci/Zo
uYkCwcs3uH4PcbKaFgt+bxi9p394LhVqP2WN489tsiq1SMfrcZ3ojDvj1kSWCUuH
Dio1g4KTUVCPJ3gSL6ce4Lyhat/cXTBDTbgNk+VA6Bi+f0tJtakGCtXwEQJAQ9R1
Pcpz79T+pKljeik3IPzSUeawfjpZ841WDCmA0cLy3kvQemcDInYy7XIxGzyN2imI
/ekU920Gy1PiaJkGmB5dkxJ9zw3U84xe9ek+B37Bu3TK944yhtRNm3LQ3eEB0Bim
2q9jFb+pM3UccvArSxERzO+lyEY6OIFLgttMHec8FPtux17zi9d2nQ8PC44dsrNQ
T/tn28+qIXixRykDtKMwUUSkUHtoQIzdZO18e3VxJthwMZAx0ddEiH5aUFlI0Kz/
ZlWgRscBfkqY+xXDkkscRkmUJG89cVM4wCvtmUjqMpzroBNYM4vWjysb4LOwL3eH
B1ZW4gJH4RNnhyb1dLUn2ds5ByQkBk3uZsCrlq9TytDekU+YKjVwa4dZwrTB5L3p
9vHGxcRSqSxyynINmsb68HOxHHv5yAMYNuTYJ0pkC1eI7nbN27PZnbeZ1Z1NAS0H
zFXP12auiM8=
=pbBu
-----END PGP SIGNATURE-----

--Sig_/bLC/IEv4J8WX/Uoqrn=Vqhz--

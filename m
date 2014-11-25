Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751152AbaKYOtH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 09:49:07 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:49249 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879AbaKYOtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 09:49:05 -0500
Date: Tue, 25 Nov 2014 08:49:09 -0600
From: Felipe Balbi <balbi@ti.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: <balbi@ti.com>, George Cherian <george.cherian@ti.com>,
        <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: musb: core: Disable the Interrupts till BABBLE is
 fully handled
Message-ID: <20141125144909.GD6360@saruman>
Reply-To: <balbi@ti.com>
References: <1415953486-6000-1-git-send-email-george.cherian@ti.com>
 <20141118211734.GA19146@saruman>
 <54736FBE.6060505@linutronix.de>
 <20141124182053.GD25712@saruman>
 <20141124203908.4425.qmail@stuge.se>
 <54739B7C.7020102@linutronix.de>
 <20141125010939.GA17125@saruman>
 <54743CCE.20202@linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UoPmpPX/dBe4BELn"
Content-Disposition: inline
In-Reply-To: <54743CCE.20202@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--UoPmpPX/dBe4BELn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Nov 25, 2014 at 09:24:46AM +0100, Sebastian Andrzej Siewior wrote:
> On 11/25/2014 02:09 AM, Felipe Balbi wrote:
> >=20
> >> I *think* for some reason the host did not really receive ep0
> >> set_config request as planned. And device's answer is probably then
> >> interpreted as data which is not expected (as Felipe said "device side
> >> tries to move data without the host asking for anything").
> >=20
> > that's definitely a bug, unfortunately I can't think of any Erratum
> > right now.
>=20
> maybe there will be a new one :)

maybe :-)

> >>>> That's certainly babble :-)
> >>>
> >>> Certainly! But musb shouldn't fall over or lock up because of it,
> >>> should it?
> >>
> >> No and the patch fixes the issue. The strange thing is that it only
> >> happens on the same device. Not if you connect host<->device with two
> >> boards.
> >=20
> > probably some crap going on within the interconnect when both instances
> > are used.
> Either that or something is synchronized since both instances use
> probably the same clock source. But there is definitely something
> switched off since it does not happen without PM enabled.

ok, then we can blame somebody else. Good. We're off the hook, next!

I think it might be wise to look at which clocks the USB block is using
and making sure drivers/clk/ti/ waits for clocks to be stable before
returning control to caller.

cheers ;-)

--=20
balbi

--UoPmpPX/dBe4BELn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUdJblAAoJEIaOsuA1yqRE6O4P/1fjk5WzlTCIaVdnhZf8JaH+
FgZ0yI2U9brLdhbbY2UwL75W+pbM7fGc4ZeXG9X/bfHrf6JTmgN6Elj1Z43ENmO7
QjuWRrG7n7044WvBvGj6hS4YxfAZK7lXK5gb/6HD3zY5yhd/kYcvwZu7/bn2cWHs
exW5HOVKhaL9J3IlNgUK5tqT/e3iGtKupE0cgWomeuxdwCAOl7ZX9dK35UfMQfSz
2TBapgUn9jmj+efmwleLkuggjI9mt4XEuHta+MsO8cbRU1ymhrawpMRpZX5vc0aA
RxjV04CdjbWv0EX3QHvhn8KJLiZ813GB8ipDbosFiDeXHMJ2ZHdGpsOBr5xTo8Gz
8U/cPy3fmFq+YNIgILWzpgdo1No5dK1uGKurixNXJzofyMqG8bQWBg/jwP/sxg51
+oBWlDYVd0mfzBEYRNRgHdrJ/f9bOp7vVyxbPHMcugPcw1sehTqHdFMxRdixHfc3
mFOc1xlj+MahW7Kpuz74yiCo0Le4hzvoecBkq9ltV5LaLputNPBMgax/5VzhaEug
JRjcIyZ82peU7CGCDqyTLilGhUP1WJRAxSIQ16mJq0oLSIHcGfcdH6p3GYnAK+DU
ZLIQN92r/cLs0i5NTmZJWDbQz80JgYzZ06O/p+5Nh/ZF13qIwEYi+7Lf9k1tEVEe
ZZ6l6AUvQxgbpo6JoTXh
=klIO
-----END PGP SIGNATURE-----

--UoPmpPX/dBe4BELn--

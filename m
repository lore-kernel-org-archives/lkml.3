Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703Ab3GAQt5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 12:49:57 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:35968 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752799Ab3GAQt4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 12:49:56 -0400
Date: Mon, 1 Jul 2013 19:49:20 +0300
From: Felipe Balbi <balbi@ti.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: Roger Quadros <rogerq@ti.com>, <balbi@ti.com>, <tony@atomide.com>,
        <ruslan.bilovol@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 4/6] USB: ehci-omap: Suspend the controller during
 bus suspend
Message-ID: <20130701164920.GA31370@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <51D13AED.4010307@ti.com>
 <Pine.LNX.4.44L0.1307011209440.1547-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3V7upXqbjpZ4EhLz"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1307011209440.1547-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 01, 2013 at 12:24:07PM -0400, Alan Stern wrote:
> On Mon, 1 Jul 2013, Roger Quadros wrote:
>=20
> > On 06/28/2013 10:06 PM, Alan Stern wrote:
> > > On Fri, 28 Jun 2013, Roger Quadros wrote:
> > >=20
> > >>> That's not what I meant.  Never mind the pinctrl; I was asking about
> > >>> the EHCI controller itself.  Under what circumstances does the
> > >>> controller assert its wakeup signal?  And how do you tell it to stop
> > >>> asserting that signal?
> > >>
> > >> I believe this would be through the EHCI Interrupt enable register (=
USBINTR).
> > >> I'm not aware of any other mechanism.
> > >=20
> > > That's strange, because ehci_suspend() sets the intr_enable register =
to=20
> > > 0.  So how do you ever get any wakeup interrupts at all?
> >=20
> > Because after ehci_suspend() for OMAP, we solely rely on the out of ban=
d wake up
> > mechanism. i.e. Pad wakeup.
>=20
> I don't know what Pad wakeup is.  The wakeup signal has to originate=20
> from the EHCI controller, doesn't it?  If not, how does the Pad know=20
> when a wakeup is needed?

That's really an OMAP thing, I guess. Pad wakeup sits in the PRCM (IIRC)
inside and always on power domain. EHCI sits in another power domain
which be turned off. When it's turned off (power gated and clock gated)
the EHCI block has no means to wakeup whatsoever. That's when pad wakeup
comes into play. It is generated when PRCM sees a change in the actual
pad of the die. To check who should 'own' the wakeup, it checks the
muxing settings to verify whose pad is that.

--=20
balbi

--3V7upXqbjpZ4EhLz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR0bMQAAoJEIaOsuA1yqRECD8P/jlQijLFRJxVxGMLdx0yB3qB
X2EbdxRZfDi6NC9OuUYGxueFlz4lUFnoZbmThc/hqV8ctzqbxRM2cchYgs70iRTx
vNUbV9AdF8ib7t14GNQQ76Dx8HOVsiFn+DcgmUq2K+mK/S0stJlyMh5tMt8RDfyd
7N+OzzQwHLtLW3uWXPwoBwjHFqiQX3zQHkw0vcmh1H/EWgHC4EYIv387qf9QlmTy
eFa/W0C9rNxVwQe4djD2eJUudOAskOfRj/z7zBwXYmhaI4ecJhQtE9raddOaDTaO
VXau8Hse8IHH80KNcr9KWnjVphFFNZfZHbTruazMCaBGYbW3GK/dNxpNlzkVraJC
ICWhL/HGVFkv6yGP2xfPYf1M1DtyepCxiNTlFaIURoZXPEiwJKSeDrAe2sZFnx+Y
2Jy2hYHJMwMQPJ4ZZktk88l4Ag549IZJujAq/tb+G4xGmw9LIPknP+eFPuVF/cfx
TnH1VKWo/y0cPMsoap0i2OM+34NZapp++NtsZXnQpaEKGvqhPIhNU82Jxzl+YujO
DtEtDUZ9gG/Us4d66/HuIK+2huMC0jR2W5DEgYqLZjJ+ve9atne6++3MSyAcvTJC
nqPXRZEb+d6GEx8XYWYxWQUUhdbtWNqmKIwstLXuph8zUGxDweffkrkTbDV+P22l
OqnQ7czTR/W/KDazhc8w
=z3VI
-----END PGP SIGNATURE-----

--3V7upXqbjpZ4EhLz--

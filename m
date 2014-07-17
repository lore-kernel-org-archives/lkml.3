Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934681AbaGQQFG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 12:05:06 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58226 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757532AbaGQQFD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 12:05:03 -0400
Date: Thu, 17 Jul 2014 11:04:21 -0500
From: Felipe Balbi <balbi@ti.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: <balbi@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Tony Lindgren <tony@atomide.com>, <linux-kernel@vger.kernel.org>,
        <linux-serial@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 5/5] tty: serial: Add 8250-core based omap driver
Message-ID: <20140717160421.GJ10459@saruman.home>
Reply-To: <balbi@ti.com>
References: <1405521903-5877-1-git-send-email-bigeasy@linutronix.de>
 <1405521903-5877-6-git-send-email-bigeasy@linutronix.de>
 <20140717145430.GF10459@saruman.home>
 <53C7E7BE.7030403@linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="j+MD90OnwjQyWNYt"
Content-Disposition: inline
In-Reply-To: <53C7E7BE.7030403@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--j+MD90OnwjQyWNYt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 17, 2014 at 05:11:58PM +0200, Sebastian Andrzej Siewior wrote:
> On 07/17/2014 04:54 PM, Felipe Balbi wrote:
> > Hi,
> >=20
> > On Wed, Jul 16, 2014 at 04:45:03PM +0200, Sebastian Andrzej Siewior wro=
te:
> >> +static int omap_8250_startup(struct uart_port *port)
> >> +{
> >> +	struct uart_8250_port *up =3D
> >> +		container_of(port, struct uart_8250_port, port);
> >> +	struct omap8250_priv *priv =3D port->private_data;
> >> +
> >> +	int ret;
> >> +
> >> +	if (priv->wakeirq) {
> >> +		ret =3D request_irq(priv->wakeirq, omap_wake_irq,
> >> +				port->irqflags, "wakeup irq", port);
> >> +		if (ret)
> >> +			return ret;
> >> +		disable_irq(priv->wakeirq);
> >> +	}
> >> +
> >> +	ret =3D serial8250_do_startup(port);
> >> +	if (ret)
> >> +		goto err;
> >> +
> >> +	pm_runtime_get_sync(port->dev);
> >=20
> > should this pm_runtime_get_sync() be placed above
> > serial8250_do_startup() call ?
>=20
> I don't think it matters since serial8250_do_startup() has its own
> pm_runtime_get_sync().

oh right, saw that now.

> ->startup(), ->shutdown() are called via omap callbacks so we could
> spare in the 8250-core if we do it in the omap code before invoking the
> function. The same goes for serial8250_set_termios() which is not used
> by omap but has those runtime-pm stuff, too.
> It would be wrong if someone would use the serial8250_do_startup()
> without his own runtime-pm get but it is omap only which does this
> things.
> So it is not used by anyone else (right now) and if you want to keep it
> to a minimum I could remove them from those places.

I don't think it matters as long as the calls are balanced.

--=20
balbi

--j+MD90OnwjQyWNYt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTx/QFAAoJEIaOsuA1yqRECxgP/j5ZgCwoXVdZQl8R5uuilUlf
bnRvlHiA9nQ8pBma2/4MDWaDNKF0QpEGVNLn6qwG+CR93o+DtjtcZcCQRnW+iDSX
1OX2Y98UY0yecnHZ15bUCivFv7ISGBFMuL4UVnionS0KIf74jVjWpkN4ZIRWYmmM
s//OlMjvPlhiNCXl7w/4nljw1uSYV3TWdlsad3AWsYE5rVCKux3NLoUWZFvqONjP
86sIzmEQv5vaC4ALVtutdcJwaOth9rpWQAFlrszOL+FI1lIYJPCMUesArDkEAHbK
4Ak70I51dAhKBZlDLj5QtCm8BdwjnesEg+sWisVEyxI18McfTEaVP4i7lQH5PNLJ
a3n5ErUcbvv0E5ieLTVsSjb+KNJmmmP/SoF5meIc5K6a+7/dtma05ekuSakrlEuK
Txy+Zv6rhBvUtAK3fmkneySbNRsv1hNqtZ9b3KgP2NASB3JAQQUiZySJyFSmNwu8
n8fJaNETlpcbOwdeMZfoVkQIN8OSim5hjKNpgsEHONgooBv5iebCxozOPb2p9wvk
vXOxiIqXuJjMclLUW33pKCxYlv7/5x9FWtb2Cuwf3SXd4BEut/Jh8jAOt3siEg0k
FgvBRiYzwxX4Ykv9oqTpqVT2ITWsF0FXysBBCKLthTMnmb+5L59kivKCdYrBHc0e
h1GRJ5TWWOL8d/JkKyt8
=B4+R
-----END PGP SIGNATURE-----

--j+MD90OnwjQyWNYt--

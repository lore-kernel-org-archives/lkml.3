Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346AbaHURI2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 13:08:28 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:39235 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284AbaHURI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 13:08:26 -0400
Date: Thu, 21 Aug 2014 12:08:19 -0500
From: Felipe Balbi <balbi@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Kishon Vijay Abraham I <kishon@ti.com>,
        Grazvydas Ignotas <notasas@gmail.com>, Felipe Balbi <balbi@ti.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] usb: phy: twl4030-usb: Fix lost interrupts after ID pin
 goes down
Message-ID: <20140821170819.GH11146@saruman.home>
Reply-To: <balbi@ti.com>
References: <20140821164803.GB10066@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="54u2kuW9sGWg/X+X"
Content-Disposition: inline
In-Reply-To: <20140821164803.GB10066@atomide.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--54u2kuW9sGWg/X+X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 21, 2014 at 09:48:04AM -0700, Tony Lindgren wrote:
> Commit 249751f22380 ("usb: phy: twl4030-usb: poll for ID disconnect")
> added twl4030_id_workaround_work() to deal with lost interrupts
> after ID pin goes down. However, this currently only works for the
> insertion. The PHY interrupts are not working after disconnecting
> an USB-A device from the board, and the deeper idle states for
> omap are blocked as the USB controller stays busy.
>=20
> The issue can be solved by calling delayed work from twl4030_usb_irq()
> when ID pin is down and the PHY is not asleep like we already do
> in twl4030_id_workaround_work().
>=20
> But as both twl4030_usb_irq() and twl4030_id_workaround_work()
> already do pretty much the same thing, let's call twl4030_usb_irq()
> from twl4030_id_workaround_work() instead of adding some more
> duplicate code.
>=20
> Fixes: 249751f22380 ("usb: phy: twl4030-usb: poll for ID disconnect")
> Cc: stable@vger.kernel.org # v3.12+
> Signed-off-by: Tony Lindgren <tony@atomide.com>

looks ok to me:

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--54u2kuW9sGWg/X+X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT9ieDAAoJEIaOsuA1yqREolIP/jwEmWIVb5Euzt4yO/bUGS3R
ax8zjj3I34i/HsgAojAnRABvG0GshmwP1nuIrgOSkVu7XVqOUJ/gN78URhZ3Dgl9
o8aPqRbz2GCPBdunHzqNHb1PuAP1LuICDOwnR45YrkpYqI5FlL/062sywZKDVN7c
xvWkfgEosg0mZQLG4+jxsQCOuGH21xvdHffp543xDMoUuqiMA1IcruTheImY49I8
9TnF0zQzr5nZPeQVdySKCbEQcune0ngrS4bzwwCFJD5XPa6w/5hs95dtixzF0T7E
XHjo2atsuXW41RtVwtbukIXZr6rRVR/bja4cSaygFeDNbSAP0JUhTVXzLBcP70TE
hVfKJV+zuWvUspYavAr0ypIixHSg69kT2WYtDTpCelU2EpHptUyHofd99HL7Bl7l
Qp7I2C1DqPcd+5cV6hzUQSg11Tn0Camw5vyu067Qcu5SvpJmiKgFEVUKwm/QNCwB
OX6b3lPy5GZa+XTnJBGYy43+GJITjfx4Uh9IZrQ0UPZU56R6kOIX5KG92wlFNqfO
vi/sq2ptjfRvzWTHOsSYdy2W0DQcQWylg5TOOA+aDKVV3dzhGDg55WoXimlnkX1x
+4WoMPkkhUM3w2GB2eAWVVUdcq56xdX9PwIfMp3/ofo6Wmo9XW7eeoyaJwT7qZdE
p/UXtTAJdvuf/FASssfJ
=3L/c
-----END PGP SIGNATURE-----

--54u2kuW9sGWg/X+X--

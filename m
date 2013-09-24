Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417Ab3IXRFx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 13:05:53 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:49504 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528Ab3IXRFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 13:05:51 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        freemangordon@abv.bg, aaro.koskinen@iki.fi, pavel@ucw.cz
Subject: Re: [PATCH 4/4] RX-51: Add platform function and data for bq24150a charger
Date: Tue, 24 Sep 2013 19:05:47 +0200
User-Agent: KMail/1.13.7 (Linux/3.11.0-1+synaptics-generic; KDE/4.11.1; x86_64; ; )
References: <1378630239-10006-1-git-send-email-pali.rohar@gmail.com> <201309232206.47391@pali> <20130923204714.GB22995@earth.universe>
In-Reply-To: <20130923204714.GB22995@earth.universe>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart12110048.YEdymJpjU4";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201309241905.48301@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart12110048.YEdymJpjU4
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Monday 23 September 2013 22:47:15 Sebastian Reichel wrote:
> On Mon, Sep 23, 2013 at 10:06:46PM +0200, Pali Roh=C3=A1r wrote:
> > On Monday 23 September 2013 22:00:09 Sebastian Reichel wrote:
> > > On Mon, Sep 23, 2013 at 09:16:18PM +0200, Pali Roh=C3=A1r wrote:
> > > > It is not as simple as it looks. This is reason why I
> > > > submited this patch long time after I submited bq2415x
> > > > driver.
> > > >=20
> > > > Problem is that for rx51 is needed specific function
> > > > which connect to two drivers (bq2415x and isp1704) plus
> > > > it call specific rx51 board functions.
> > > >=20
> > > > Something which cannot be in DT (unless DT support C/ASM
> > > > code).
> > >=20
> > > mh could isp1704 driver expose the data via the regulator
> > > framework?
> >=20
> > No, isp1704 is power supply driver and export data via power
> > supply (sysfs) interface. It is not regulator but charger
> > driver.
>=20
> well it does not charge the battery directly, but just
> provides a power line with 5 Volt and a specified amount of
> current to the system, doesn't it?
>=20

No, isp1704 driver is doing fastcharger detection (and then=20
export charger type via sysfs power supply) based on musb usb=20
events.

Real charging (enabling/disabling and setting properties) is done=20
by bq24150a chip which has own power driver bq2415x_charger.

As already wrote this is not simple and this is reason why I sent=20
board data and functions only now...

> From my POV this is a candiate for the regulator framework:
>=20
> https://www.kernel.org/doc/Documentation/power/regulator/overv
> iew.txt
>=20
> -- Sebastian

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart12110048.YEdymJpjU4
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlJBxmwACgkQi/DJPQPkQ1Kp7wCcC1XPLWrKuH4C2G1cXP6IjM7o
p1EAoIMQl6pR0zV6eyhWzX2nXDwZk4eU
=Lrlw
-----END PGP SIGNATURE-----

--nextPart12110048.YEdymJpjU4--

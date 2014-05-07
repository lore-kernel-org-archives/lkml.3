Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597AbaEGWFK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 18:05:10 -0400
Received: from top.free-electrons.com ([176.31.233.9]:34252 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751777AbaEGWFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 18:05:08 -0400
Date: Wed, 7 May 2014 17:00:49 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Emilio Lopez <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>, kishon@ti.com,
        hdegoede@redhat.com, Boris Brezillon <boris@free-electrons.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        zhuzhenhua@allwinnertech.com, linux-sunxi@googlegroups.com,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH 4/7] usb: ehci-platform: add optional reset controller
 retrieval
Message-ID: <20140507220049.GC7047@lukather>
References: <1399434623-20383-5-git-send-email-maxime.ripard@free-electrons.com>
 <Pine.LNX.4.44L0.1405071020490.1325-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7gGkHNMELEOhSGF6"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1405071020490.1325-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7gGkHNMELEOhSGF6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 07, 2014 at 10:25:55AM -0400, Alan Stern wrote:
> On Tue, 6 May 2014, Maxime Ripard wrote:
>=20
> > From: Boris BREZILLON <boris.brezillon@free-electrons.com>
> >=20
> > On the Allwinner's A31 SoC the reset line connected to the EHCI IP has =
to
> > be deasserted for the EHCI block to be usable.
> >=20
> > Add support for an optional reset controller that will be deasserted on
> > power off and asserted on power on.
> >=20
> > Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
>=20
> Is this really a _reset_ line?  That is, when you assert the reset=20
> line, does it actually reset the EHCI controller, or does it merely=20
> leave the controller in a partially powered-down state?

It actually resets the whole controller.

> The difference is important.  During suspend, the controller is
> supposed to remember the state of the port connections as well as other
> settings.  If it doesn't, the controller and all attached USB devices
> will have to be reinitialized every time the controller resumes, which
> will increase the latency.

So you're saying that we should move this to the probe then?

Thanks,
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--7gGkHNMELEOhSGF6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTaq0RAAoJEBx+YmzsjxAgi4AP/02ZdeNJtibPjwsygnQAnJkD
ndwlSTxAPpWn0NXQg5KltvQHNndUyI1GZmqYRT2HfHWpJn9jEWdwII+C+Ny4QpWo
mASD5mPQSx/c0aePDibEtIQ8lAIxZcwYOx30C5WUex3h/avykBoTwN2dv6hBRWOt
EXUmZN057pFcK9/d+b5jCbGLoY8wiSGa6SjojFb64N36iIqCSMLQyHPU6SRt9/nv
UzMDCIEVMMfeiJ59EmmsMBfcxhP4BM7irmUH8lgwfriE2X+2pGDaZUNI/le9tiyR
E1pTFZd1D2zS+Mq9TjMGqiAfbFkAMnRP3RFb1adjBmFmTxjgLKC7QIkQ0YZyZ7gx
lQsy+JukpueEwh00pQp7fZs5P4wc3y/8BKDNYYSWSTORG11MztAEntoUHDq/ou7F
CrW68Guw5GXg+OhHuEyupqUKm7KY2zWDbyxMNoq/eE9AQRFsFxOcEKotU8rtGt5I
HKflfuHlKTNefFfLWLQIDICy1NnG+Egbo24ZP61Y7/1bStnwfae+cBUbrrAWpdhw
xdNMkmMHaA0yqsBBL6fl7TwAvHnJHDrYlAGJH8sp+7wRbAqkugQbJgmc5vUcng5w
VKUTJP0v5XvRo4VCfEXvZ9LA54eT+6VslL7fOrebW6SprodxumxyjtkWKCG43spy
bCHuoc1ilh4GexJ6uwhu
=rEfp
-----END PGP SIGNATURE-----

--7gGkHNMELEOhSGF6--

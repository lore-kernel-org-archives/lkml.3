Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604AbaGJN4U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 09:56:20 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:45063 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753249AbaGJN4Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 09:56:16 -0400
Date: Thu, 10 Jul 2014 08:56:00 -0500
From: Felipe Balbi <balbi@ti.com>
To: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
CC: Felipe Balbi <balbi@ti.com>, <gregkh@linuxfoundation.org>,
        <Peter.Chen@freescale.com>, <kishon@ti.com>,
        <stern@rowland.harvard.edu>, <alexandre.belloni@free-electrons.com>,
        <thomas.petazzoni@free-electrons.com>, <zmxu@marvell.com>,
        <jszhang@marvell.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] usb: chipidea: add support to the PHY framework for
 ChipIdea
Message-ID: <20140710135600.GN15340@saruman.home>
Reply-To: <balbi@ti.com>
References: <1404901036-27682-1-git-send-email-antoine.tenart@free-electrons.com>
 <1404901036-27682-5-git-send-email-antoine.tenart@free-electrons.com>
 <20140710134227.GL15340@saruman.home>
 <20140710135124.GB32462@kwain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8MZM6zh5Bb05FW+3"
Content-Disposition: inline
In-Reply-To: <20140710135124.GB32462@kwain>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--8MZM6zh5Bb05FW+3
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 10, 2014 at 03:51:24PM +0200, Antoine T=E9nart wrote:
> On Thu, Jul 10, 2014 at 08:42:27AM -0500, Felipe Balbi wrote:
> > On Wed, Jul 09, 2014 at 12:17:16PM +0200, Antoine T=E9nart wrote:
> > > This patch adds the support to the PHY framework for ChipIdea drivers
> > > while keeping the USB PHY compatibility. Changes are done in both the
> > > ChipIdea common code and in the drivers accessing the PHY. This is do=
ne
> > > by renaming 'phy' into 'usb_phy' and adding a new 'phy' member into t=
he
> > > ci_hdrc structre.
> > >=20
> > > Signed-off-by: Antoine T=E9nart <antoine.tenart@free-electrons.com>
> > > ---
> > >  drivers/usb/chipidea/ci.h          |  4 ++-
> > >  drivers/usb/chipidea/ci_hdrc_imx.c |  2 +-
> > >  drivers/usb/chipidea/ci_hdrc_msm.c |  6 ++--
> > >  drivers/usb/chipidea/core.c        | 67 ++++++++++++++++++++++++++++=
+++-------
> > >  drivers/usb/chipidea/debug.c       |  4 ++-
> > >  drivers/usb/chipidea/host.c        | 17 ++++++----
> > >  drivers/usb/chipidea/otg_fsm.c     |  6 ++--
> > >  drivers/usb/chipidea/udc.c         |  4 +--
> > >  include/linux/usb/chipidea.h       |  4 ++-
> > >  9 files changed, 86 insertions(+), 28 deletions(-)
> > >=20
> > > diff --git a/drivers/usb/chipidea/ci.h b/drivers/usb/chipidea/ci.h
> > > index 9563cb56d564..139589c8ab90 100644
> > > --- a/drivers/usb/chipidea/ci.h
> > > +++ b/drivers/usb/chipidea/ci.h
> > > @@ -201,7 +201,9 @@ struct ci_hdrc {
> > > =20
> > >  	struct ci_hdrc_platform_data	*platdata;
> > >  	int				vbus_active;
> > > -	struct usb_phy			*transceiver;
> > > +	struct phy			*transceiver;
> > > +	/* old usb_phy interface */
> > > +	struct usb_phy			*usb_transceiver;
> >=20
> > while at that, do you mind calling all struct usb_phy pointers
> > 'usb_phy' ?
>=20
> Not at all.
> With s/usb_transceiver/usb_phy/, what about 'transceiver'?

perhaps call it phy ? That way all drivers have similar naming scheme.
Plus, I rather type 3 letters than 11 :-p

--=20
balbi

--8MZM6zh5Bb05FW+3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTvptwAAoJEIaOsuA1yqRET3kP/0Gjmhsh2qdSidiFTc73VOuC
/Mu/jc428b3TPVlH8UeRfGbGq9ycpIShmNoxhXdwAN5Gmuy3nDqaYlQXZqi897cr
cNW3wFGb930bPwNB/Bts6qRhjmbAyP2THpC9oywwJyF/bkzjHWnmtR2xCzu3gjWa
wKNCT+oyKkJTtU5BMibULP+/CmVvJxRTenp6nwnsIM2YOQDgiHFk0CaeO7+KxI44
PpTDPUnUSXvlks8Kf9E2F6tdj88psIv8TsIC84BKt+F8gjA2SEptWe+sbitPvUvw
THV1tnvvsaFESTWkwuApM031dmEN73J9YzSX+rEfvaV5h16neGQcfrZ1Ydn4sMOJ
3IpG/ySTGf1BdwWvbsSswIUwOKEgtq9AeeeRyLwyCYM+LxXcbqMZ1YBRZWevTSxW
48pwZqyaZROfIWSm7hQOo5hNHUzhsdaFLzf7ZPkPujFNyYnYU6GZmm9XQzf6FUV+
r1D9I2PufrhZZvhoDJy15N83Z9gr91e9ZteQS+sbOd1KSliF+2zBZGGahrTM5Xf7
D8O4mgmt4pZy9s4bbX9QKxSUXTSp0pCW1e0A/H/3kJh7CoKMy0FdKtxG745NNcr+
UT8nZzspAQSH+yVKlL2srHMWt88vRGw/G/t8TCIqRSE2TZ1gPjy7aPzq6JacAWt1
v65ELHGY9rua8SKXswtt
=JPj2
-----END PGP SIGNATURE-----

--8MZM6zh5Bb05FW+3--

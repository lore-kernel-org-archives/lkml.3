Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324AbaEMP7y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 11:59:54 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:49277 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753667AbaEMP7W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 11:59:22 -0400
Date: Tue, 13 May 2014 10:58:58 -0500
From: Felipe Balbi <balbi@ti.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: Felipe Balbi <balbi@ti.com>, <p.zabel@pengutronix.de>, <marex@denx.de>,
        <wsa@the-dreams.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] reset: stub out devm_reset_control_get()
Message-ID: <20140513155858.GP1151@saruman.home>
Reply-To: <balbi@ti.com>
References: <1399995245-15095-1-git-send-email-balbi@ti.com>
 <20140513155401.GD29258@lukather>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CKf/2jVYos1l2hij"
Content-Disposition: inline
In-Reply-To: <20140513155401.GD29258@lukather>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--CKf/2jVYos1l2hij
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 13, 2014 at 05:54:01PM +0200, Maxime Ripard wrote:
> On Tue, May 13, 2014 at 10:34:05AM -0500, Felipe Balbi wrote:
> > without that stub, drivers will fail to build
> > when CONFIG_RESET_CONTROLLER=3Dn.
> >=20
> > Signed-off-by: Felipe Balbi <balbi@ti.com>
> > ---
> >  include/linux/reset.h | 6 ++++++
> >  1 file changed, 6 insertions(+)
> >=20
> > diff --git a/include/linux/reset.h b/include/linux/reset.h
> > index c0eda50..aa94420 100644
> > --- a/include/linux/reset.h
> > +++ b/include/linux/reset.h
> > @@ -75,6 +75,12 @@ static inline struct reset_control *devm_reset_contr=
ol_get_optional(
> >  	return ERR_PTR(-ENOSYS);
> >  }
> > =20
> > +static inline struct reset_control *devm_reset_control_get(
> > +					struct device *dev, const char *id)
> > +{
> > +	return ERR_PTR(-ENOSYS);
> > +}
> > +
>=20
> reset_control_get should only be used in cases where the reset
> controller is mandatory for the driver to work, and hence, this driver
> should select or depend on CONFIG_RESET_CONTROLLER
>=20
> If the reset controller is optional, reset_control_get_optional should
> be preferred, that is stubed out.

fair enough, depends on it is

--=20
balbi

--CKf/2jVYos1l2hij
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTckFCAAoJEIaOsuA1yqREeMUP/RYF57xLOjg/XsrV1zEqG4ws
HhjsXk5Cgf1LmblQsG33DqqkQs/A14BILs+ssBQdRVF8krly6QJ+dYaQQEHt9NfV
cX8+/GHwFVnQ5vvBD/Jnwf4g2IKMI2v6+JXL7ytooGKwYMiujrt1sULjzyK5ihYa
phGXiLXVpufqzbo+ALb21vkzWn+pJqHhlKzipgnW75w30I5MJpbSn8RBDar9Of0M
hk8L0gScfBrroy8p29I/CM8LjjWO8vM+FAXY+MtqygH9rIzYBe2Bt11gwjbIhG5T
vjrnFfbIw07fu0ifdQrIDkRnjb7FPoTjrO/w4N5sY3iVYBQbjQK0IYDyQ3/rxMLP
U8rV+fudAaR1MhEoCQtH8Mm0fAaZI17NYdfEsBa7IWfxxmFGxvYH53c4Vt4vBNz0
dbvyUW16EUlLbrHEVlX+GpRic4YdCPJSvfXRb37p80xkMv+LcGRG3qbxZv9TBTOU
L4ggTiZiRBBYvpEjr2pLZAvyoWwPeRi9uBz/gmAlMPrI3lsyN/Srbf2nG9FXbL+h
EUS0CMRDNHixFa4DKYfmroIQMQFgXIWc5jc40BI3K0DuSOydeSNYuSSBhowCPxNJ
sg4YLlhhywXNu13MNM8dPKDrJ8epH9Y7gp9wbFdDkh0V3B2z2KJ/8MUR1c4WBiac
wvv7QoxHqaTwVdnI+fid
=gY3a
-----END PGP SIGNATURE-----

--CKf/2jVYos1l2hij--

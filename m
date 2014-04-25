Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935AbaDYRc5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 13:32:57 -0400
Received: from mail.kernel.org ([198.145.19.201]:56776 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539AbaDYRcy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 13:32:54 -0400
Date: Fri, 25 Apr 2014 19:32:47 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>, Tony Lindgren <tony@atomide.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        Joni Lapilainen <joni.lapilainen@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: Re: [PATCHv3 05/14] HSI: Add channel resource support to HSI clients
Message-ID: <20140425173247.GA22721@earth.universe>
References: <1396053110-21639-1-git-send-email-sre@kernel.org>
 <1396053110-21639-6-git-send-email-sre@kernel.org>
 <20140419191126.GE5148@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="6c2NcOVqGQ03X4Wi"
Content-Disposition: inline
In-Reply-To: <20140419191126.GE5148@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 19, 2014 at 09:11:26PM +0200, Pavel Machek wrote:
> Hi!
>=20
> > Make HSI channel ids platform data, which can be provided
> > by platform data.
> >
>=20
> >  static void hsi_client_release(struct device *dev)
> >  {
> > -	kfree(to_hsi_client(dev));
> > +	struct hsi_client *cl =3D to_hsi_client(dev);
> > +
> > +	if (cl->tx_cfg.channels)
> > +		kfree(cl->tx_cfg.channels);
> > +	if (cl->rx_cfg.channels && cl->rx_cfg.channels !=3D cl->tx_cfg.channe=
ls)
> > +		kfree(cl->rx_cfg.channels);
> > +
> > +	kfree(cl);
>=20
> Can cl->rx_cfg.channels =3D=3D cl->tx_cfg.channels happen? That seems
> like quite a hack :-(.

Yes it could happen. I have updated this for PATCHv4 (so that it can
no longer happen).

-- Sebastian

--6c2NcOVqGQ03X4Wi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTWpw/AAoJENju1/PIO/qaxVkP/0CXhPFJ+8E9LhSZubCzLzxu
4J+2sW1a9WEDlOwdO+8CUtms7sBsAmWqMjc/WbUH8cV7ItiBrIgKaUOIZFWQKHkm
wJW57BOciOf9+Fm3bj5/+BVesJUPF17uYX2RpJwE/yvRixtLVA6ls3MaHZSNo1E8
5WrkuyxEPIyti8je5RK9i/g72rAcFUZ+/6VmBr8H8DBqN2WX+C02BXaZeM1vTfAw
RgaVlOszn/9PVO6LrY0FgLywxny8UECnJl6oEvtDas9EJzJ8bdmdFm6CptIvLtsI
eoRibCW4uxNvUwJIlcnm/qSI4dVH/qtZZMNY1G4en3mqvE1uwqxycVRVefoBRGBM
7zI4TbViFPpQOyhBRqzGZxkuu3BvZHB4sD0VnHcxRk1w4S2fxv+x+SvJLt36/PZO
aIfUSI+e8q0hqNf6HU5a1mUP5bDs7n+ysTRLprotdTbahamdmEsB36cPT0oC9ypt
gdo10k9pBy8WIEBSonKeeMmRU93KrphNq59rKZ8vjd0ubaHnu3AOvXcANUpYrnIZ
5GEc37ITlsu1Pk9mnz4HP/1zVR2zMP0lmKshQ7oba+Rx4RydI4y8BKUFwGdM4/1T
qhZzz9jEiaqHkSqihq7SOVsKy/5paMcRYsxp1CQuFXg2LbI1CwFrq4HJxYWBXomb
z38L07/gFnggjwYQHgYe
=Cf+p
-----END PGP SIGNATURE-----

--6c2NcOVqGQ03X4Wi--

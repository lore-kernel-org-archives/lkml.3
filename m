Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005Ab3FXJ3q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 05:29:46 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:35076 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160Ab3FXJ3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 05:29:45 -0400
Date: Mon, 24 Jun 2013 11:29:42 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Oliver Schinagl <oliver+list@schinagl.nl>, arnd@arndb.de,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        andy.shevchenko@gmail.com, linux@arm.linux.org.uk,
        linus.walleij@linaro.org, linux-sunxi@googlegroups.com,
        Oliver Schinagl <oliver@schinagl.nl>
Subject: Re: [PATCH 1/2] Initial support for Allwinner's Security ID fuses
Message-ID: <20130624092942.GG26008@lukather>
References: <1371502778-15849-1-git-send-email-oliver+list@schinagl.nl>
 <1371502778-15849-2-git-send-email-oliver+list@schinagl.nl>
 <20130617225847.GA9494@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5L6AZ1aJH5mDrqCQ"
Content-Disposition: inline
In-Reply-To: <20130617225847.GA9494@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5L6AZ1aJH5mDrqCQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Mon, Jun 17, 2013 at 03:58:47PM -0700, Greg KH wrote:
> On Mon, Jun 17, 2013 at 10:59:37PM +0200, Oliver Schinagl wrote:

[..]

> > +static int __init sunxi_sid_probe(struct platform_device *pdev)
> > +{
> > +	u8 entropy[SID_SIZE];
> > +	unsigned int i;
> > +	struct resource *res;
> > +	void __iomem *sid_reg_base;
> > +	int ret;
> > +
> > +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +	sid_reg_base =3D devm_ioremap_resource(&pdev->dev, res);
> > +	if (IS_ERR(sid_reg_base))
> > +		return PTR_ERR(sid_reg_base);
> > +	platform_set_drvdata(pdev, sid_reg_base);
> > +
> > +	ret =3D device_create_bin_file(&pdev->dev, &sid_bin_attr);
> > +	if (ret)
> > +		return ret;
>=20
> You just raced with userspace, having the file show up after the device
> was announced to users that it was there.  Please use the proper device
> file api to add default attributes to prevent this from happening.

Sorry if the question looks dumb, but what kind of race can we generate
here?

The device_create_bin_file is the last call that we make (if we except
the entropy stuff, but it doesn't really matter here), so after we
created the file, we have everything properly initialised so that our
functions can be called, right?

And another dumb question for you, what is the "proper device file API"
you are referring to ? :)

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--5L6AZ1aJH5mDrqCQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRyBGGAAoJEBx+YmzsjxAgYgoP/03lrJk7jnBbS5VB69ZvniFf
vCRppuJmvZU/xtgVqrkjYWSCk8VuxBhyRpQTXJ2GSLUZloTbu0vtAgXSyjSCoLxd
HR2nlHngPazITrS6GmVBd/5nziRTBrZtvS2TxydzUVW8Wl/h1YdDIUOPRIVHlsIL
KLkEfCWeHpTOYbgeBvHUc+X8iWWSeU6wXzf+iFp2lXkKKlAfPi1JAhPM8w3uWBW8
UI2t9+TmhW9mBF192thg6Dzj8cAzzfgXcnn2wrpP02ckMZfx+ZKWHQW0NBovMRgr
0AGTlLx3a85s5G7rShQNi/B+RIbjEQAA0TMq8jJHZnzFPJlgLuRSge0jzhFGNkGv
L1G8gr4ou7TXfel28/2ocQO45EmXPMgPj5OPZ5xU6rA8K+W5yNYY7ZFSdJQCPGEQ
2rD0SLh2gRAoT2UVgma+opN01vdSvIfYsfBmDqvYUDye9AU+X0KbGLjE7ZwHmJtC
b94HG6ILBJBffHvECJux4n+vtPSc4cp8Nov9rxWGY23WQjDYz/AAzE0fe25D7dN1
wU3cKRoLpiajc8yr+MaC3xwj+dG8Hs9ZmCqiwKCgFo3y0vkRhDJVNJTwfZlAS/sL
9/AoCFE5f4SbXeTiQadU5FXY3k5FefveLAPF3laBfm6Scyt38pw9iypj7pIQfA9Y
7vsy7SGk44guJIKwocOP
=vz44
-----END PGP SIGNATURE-----

--5L6AZ1aJH5mDrqCQ--

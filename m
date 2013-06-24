Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751505Ab3FXVE7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 17:04:59 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:38830 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab3FXVE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 17:04:58 -0400
Date: Mon, 24 Jun 2013 23:04:55 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Oliver Schinagl <oliver+list@schinagl.nl>, arnd@arndb.de,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        andy.shevchenko@gmail.com, linux@arm.linux.org.uk,
        linus.walleij@linaro.org, linux-sunxi@googlegroups.com,
        Oliver Schinagl <oliver@schinagl.nl>
Subject: Re: [PATCH 1/2] Initial support for Allwinner's Security ID fuses
Message-ID: <20130624210455.GJ26008@lukather>
References: <1371502778-15849-1-git-send-email-oliver+list@schinagl.nl>
 <1371502778-15849-2-git-send-email-oliver+list@schinagl.nl>
 <20130617225847.GA9494@kroah.com>
 <20130624092942.GG26008@lukather>
 <20130624160440.GA15201@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AXxEqdD4tcVTjWte"
Content-Disposition: inline
In-Reply-To: <20130624160440.GA15201@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AXxEqdD4tcVTjWte
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 24, 2013 at 09:04:40AM -0700, Greg KH wrote:
> On Mon, Jun 24, 2013 at 11:29:42AM +0200, Maxime Ripard wrote:
> > Hi Greg,
> >=20
> > On Mon, Jun 17, 2013 at 03:58:47PM -0700, Greg KH wrote:
> > > On Mon, Jun 17, 2013 at 10:59:37PM +0200, Oliver Schinagl wrote:
> >=20
> > [..]
> >=20
> > > > +static int __init sunxi_sid_probe(struct platform_device *pdev)
> > > > +{
> > > > +	u8 entropy[SID_SIZE];
> > > > +	unsigned int i;
> > > > +	struct resource *res;
> > > > +	void __iomem *sid_reg_base;
> > > > +	int ret;
> > > > +
> > > > +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > > > +	sid_reg_base =3D devm_ioremap_resource(&pdev->dev, res);
> > > > +	if (IS_ERR(sid_reg_base))
> > > > +		return PTR_ERR(sid_reg_base);
> > > > +	platform_set_drvdata(pdev, sid_reg_base);
> > > > +
> > > > +	ret =3D device_create_bin_file(&pdev->dev, &sid_bin_attr);
> > > > +	if (ret)
> > > > +		return ret;
> > >=20
> > > You just raced with userspace, having the file show up after the devi=
ce
> > > was announced to users that it was there.  Please use the proper devi=
ce
> > > file api to add default attributes to prevent this from happening.
> >=20
> > Sorry if the question looks dumb, but what kind of race can we generate
> > here?
>=20
> Userspace gets told about the device from the driver core, udev runs and
> reads all of the attributes, then your probe function comes along and
> adds a new attribute.  Userspace will then not know about it at all.

Hmm, I see.

Thanks for the explanations!

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--AXxEqdD4tcVTjWte
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRyLR3AAoJEBx+YmzsjxAgxq0QAJpuJ2sClab/Vy6mqPTKVW7e
+5tHBw26xrNpskYpTDmqlMOVDaewbzQxdImvm5xA0xRKajFGbGGNGmJNnpzCR5i6
HpXrSxYs519tPDGdeO9jmdZXzlptpkBcmYyfgF1cc6StDXSy7HhFoI4VToEWyWWj
7EA2zkBwL/ck/Yici+u/IWEBbNfIrmPNE+agVK1dw4So6b+E1Q57aUxP3Sai1uBk
ubLU3EcQXCJ/ATDMkxQ13dWprF+vdzqHWQuZhbjzKq6nCMvp96+5avn9ObPEKFtv
TTNxqlREIcWuzMy3pgphorQ1UUqYgcY+xdiD61LWiTGp3+PGgu2fgkExYseXlBCG
XgRh772lPLjNhrELNCCU6gr5rdL/yvkOMHny60xUtYrxbMJLC0/ofELswWGsvGYo
UYXYFY+i74oXMjxoHW5Xtp0uOgiKcret5dPca2XmXocmFGF45BgHF5qY9DIahvdR
l51zwXkFed7GFC9OWAAXxMXHjT/YtcU+tw4tatkNOWD9JA5qeGASWBsKFX/YaSIl
iDaSsZUCylfzpemeYbzc/SDhYta9x7Q8Py3BfhGN7VYgnTnsVBY72BJa1/G7e7dI
FL1Lngj8HMUMx9P8N3A0vHIdsN3rjK3YKqDqMJl4DNdGISEG+SrU4Nx4IFZY3li3
34UQ6Bs8htM6QnadoVBU
=6hvg
-----END PGP SIGNATURE-----

--AXxEqdD4tcVTjWte--

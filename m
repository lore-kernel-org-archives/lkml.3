Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758959AbaEMHzG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 03:55:06 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35760 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753108AbaEMHzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 03:55:04 -0400
Date: Tue, 13 May 2014 09:51:33 +0200
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
Subject: Re: [PATCH v3 5/8] usb: ehci-platform: add optional reset controller
 retrieval
Message-ID: <20140513075133.GA16873@lukather>
References: <1399923274-6017-6-git-send-email-maxime.ripard@free-electrons.com>
 <Pine.LNX.4.44L0.1405121604140.1202-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vtzGhvizbBRQ85DL"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1405121604140.1202-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 12, 2014 at 04:06:16PM -0400, Alan Stern wrote:
> On Mon, 12 May 2014, Maxime Ripard wrote:
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
> > Reviewed-by: Hans de Goede <hdegoede@redhat.com>
>=20
> ...
>=20
> > @@ -208,6 +210,18 @@ static int ehci_platform_probe(struct platform_dev=
ice *dev)
> >  		}
> >  	}
> > =20
> > +	priv->rst =3D devm_reset_control_get_optional(&dev->dev, NULL);
> > +	if (IS_ERR(priv->rst)) {
> > +		err =3D PTR_ERR(priv->rst);
> > +		if (err =3D=3D -EPROBE_DEFER)
> > +			goto err_put_clks;
> > +		priv->rst =3D NULL;
> > +	} else {
> > +		err =3D reset_control_deassert(priv->rst);
> > +		if (err)
> > +			goto err_put_clks;
> > +	}
> > +
> >  	if (pdata->big_endian_desc)
> >  		ehci->big_endian_desc =3D 1;
> >  	if (pdata->big_endian_mmio)
>=20
> You don't re-assert the reset control if an error happens later on=20
> during probe.  Was that intentional?

No, it wasn't. I'll resubmit another version.

Thanks,
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--vtzGhvizbBRQ85DL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTcc8FAAoJEBx+YmzsjxAg5wsP/1SHWvWp4GiO3FOXbiCIap9i
df2BXwUQv0XhbGEYhTosdTIoxBGspsL4qYK/5JQMSkq/ikPwPWGt9GezW8sHOxB5
GY/yioSSim/gU5Gkwc0ZddcYBc5PvHxLc8OBZTnZKWQIieWarJY7yCRAIUZPbKHd
4oBknewwNgPbJeNA5SH6IAAKlCEZA74WHIgWxQGnpU1dSRctlNiw6fCIH15do0Rb
/8ehA7kznDU9M8imtjJdv76ZbaBtjvuaqIByXRwNIdyEsY6+6kM25Bqzc6L2ngLd
B1l1Zh8VHmr1XMJm29RhS0jLDVYKfewgrcGBK/s7J+bLmtuvqM+rCRPKU+urA0GX
esd/2TiLWXLnvxiF0K6F6mj5h1BPGKBWH1+SMPUGW1OUgBL4sLu++/oPbdE5fWWO
nR0FWAuYTpUHFC0TAFp4WbD1EcRQYT/IH8DxTaPHGBQDTIsMVzeoTnVtJLL/rd5F
y8BFc/CRZ3iA0FI8yv6xFQgmGbS022vUhjyYQCNnF7mOrbFcq84KUu5lEX5GvE2g
VtWZRI0RYqmJaHkSBCzBTjximSvRgYpKBpdR7Nv9BYSkF1n6F1xcRs8ZhV55VlFF
giAcXTs7OtOgtPcHzVDASjGxDc0BKE8LWXAMAQPfRwDOuljvZpLFLaFuCk9MWwXa
jkvFaJAhvTqlduEKy4oY
=2AMz
-----END PGP SIGNATURE-----

--vtzGhvizbBRQ85DL--

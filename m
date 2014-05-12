Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758620AbaELOf0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 10:35:26 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58857 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758509AbaELOfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 10:35:23 -0400
Date: Mon, 12 May 2014 16:30:52 +0200
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
Subject: Re: [PATCH v2 4/7] usb: ehci-platform: add optional reset controller
 retrieval
Message-ID: <20140512143052.GA17154@lukather>
References: <1399726619-30150-5-git-send-email-maxime.ripard@free-electrons.com>
 <Pine.LNX.4.44L0.1405101023510.1268-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sm4nu43k4a2Rpi4c"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1405101023510.1268-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alan,

On Sat, May 10, 2014 at 10:35:49AM -0400, Alan Stern wrote:
> > @@ -206,6 +208,19 @@ static int ehci_platform_probe(struct platform_dev=
ice *dev)
> >  				break;
> >  			}
> >  		}
> > +
> > +		priv->rst =3D devm_reset_control_get_optional(&dev->dev,
> > +							    NULL);
>=20
> I hate the style that matches arguments on a continuation line with the
> opening paren of the function call, for a couple of reasons.  Instead I
> simply indent continuation lines by two or more tab stops.  But some
> people seem to be incurably attached to it.

Ok, I'll change it.

> > +		if (IS_ERR(priv->rst)) {
> > +			err =3D PTR_ERR(priv->rst);
> > +			if (err =3D=3D -EPROBE_DEFER)
> > +				goto err_put_clks;
> > +			priv->rst =3D NULL;
> > +		} else {
> > +			err =3D reset_control_deassert(priv->rst);
> > +			if (err)
> > +				goto err_put_clks;
> > +		}
> >  	}
> > =20
> >  	if (pdata->big_endian_desc)
>=20
> The new code was added inside an "if" statement, which will cause it to
> apply only to OF devices.  Is there any reason not to put the new code
> outside the "if" statement, so it applies to all devices?

Hmmm, I did this because so far, the reset framework only handles the
DT case. But that's right that it can be extended in the future, I'll
update it.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--sm4nu43k4a2Rpi4c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTcNsbAAoJEBx+YmzsjxAgdgwP/RS4zhOyZDTRfizcUu+r128K
vzMapJtXT72V+Q7/yrBjJiCFX1OrWPGQHTk8r/ohcmJ22N2vsh33Y50Us2DQWFjr
OkJl7FfMY+bpBlhLSH/gHsHmVdVoT+EyI2Oux0VADVIGLOVPHtevB9oQw7ulceDD
BXE3XsvwBttYcTo5x4qf9abCb1VtiGGLKUtwl6EFMzvbe/HIzykGAfd1jfyxIaLe
wBM6vPVMr3BuT1+uNhhXgrfeKFVSsVgb3auxAkPWjn+qJitQX9zI4DJhMaKEofLu
OpubOQlRp+jRAhW2F9XlFH/t4kwlwl/UXI/DiZitONA49jpfX237M/pknRBOIhRH
I54Q3fqM2fWYE6hFpTiRhdvlZGLjbQC0Lz/uBvcFhg9g+ANammoElIX2K9VcIKOU
CQ5M4tFYBMP4Mt6ZWcvDRp8FmIc8+v4wwCdEmvH5Gl4MiuxBUB72F9WlAFT5b5zw
6ok4uu40aJaWmZb9O8BnY3qatv3q3mmvMSUpN0SQCY4gy3s5McelkD3Kmi+6VLw3
kJ9aNgNV4fI5KFQ2DZQ01VivohjQvKgs92ijSfCtAz1L1UiBxis9GfqVYaLc884b
g3u7QA1TqTWImrdHBAx1R9Kd9VAsPsKuso4xbnS3enpNmqhiaUZ6eYUu345sE3On
qWGWuIkSIZgfbdBAX7pR
=FxkU
-----END PGP SIGNATURE-----

--sm4nu43k4a2Rpi4c--

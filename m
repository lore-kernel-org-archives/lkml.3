Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751377AbaJAMhf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 08:37:35 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:56551 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbaJAMhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 08:37:33 -0400
Date: Wed, 1 Oct 2014 13:37:08 +0100
From: Mark Brown <broonie@kernel.org>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Dave Airlie <airlied@gmail.com>,
        Andrew Jackson <Andrew.Jackson@arm.com>, Jyri Sarha <jsarha@ti.com>,
        alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Message-ID: <20141001123708.GZ4273@sirena.org.uk>
References: <cover.1411547014.git.moinejf@free.fr>
 <4b3d35a14461ed164956b7f5aa77b29170bc393d.1411547014.git.moinejf@free.fr>
 <20140930192540.GL4273@sirena.org.uk>
 <20141001112846.0dbc80ae@armhf>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="diT81a9gloLbuVo+"
Content-Disposition: inline
In-Reply-To: <20141001112846.0dbc80ae@armhf>
X-Cookie: So you're back... about time...
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v6 2/2] drm/i2c:tda998x: Use the HDMI audio CODEC
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--diT81a9gloLbuVo+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 01, 2014 at 11:28:46AM +0200, Jean-Francois Moine wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > > +	request_module("snd-soc-hdmi-codec");
> > > +	pdev =3D platform_device_register_resndata(&priv->hdmi->dev,
> > > +						 "hdmi-audio-codec",
> > > +						  PLATFORM_DEVID_NONE,
> > > +						  NULL, 0,
> > > +						  &tda998x_hdmi_data,
> > > +						  sizeof tda998x_hdmi_data); =20

> > Why is this request_module() needed?  If there is a good reason for it
> > we should have some documentation.

> The reason is simple: as the HDMI CODEC is not declared in the DT, the
> associated module must be loaded in memory.

No, that doesn't make sense - there's absolutely no dependency on DT for
module loading, non-DT boards work perfectly fine.  Think about this for
a minute, we don't have lots of request_module() calls in board files.
You're working around some other bug here.

--diT81a9gloLbuVo+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUK/VzAAoJECTWi3JdVIfQCeoH/RUU/tCbsxm0OWbFFEVXIG8u
G8Gmihvxh1PHcxbuG8SzC5daFf3Txe4ZhFd5WavEXzfKmzjqtl+NwYd5Zhwu3G9X
lu+GNZniDIXN6rIoMfIamDzsa4opFYtn0X0mXSO7XLWf5mCKaq5Oe4Lh1qdQGX+V
x38s/jkWKaMk5PeNhTUFf9CbPnwLslQseoX6eRECKWMFy6k0vLlrHR+goXkclABC
M6qpC16HwQLL0prmML/GwkDxdALQzg7ktdZsmvlrfXspCdF8TwD2kClo0YG6P8IK
nJ4V2iAbWkfs1XbSUbbXzzyBVMsXBjLtx0NarOyoMBBInLGBnIw0/MiYXviQzGI=
=SOfX
-----END PGP SIGNATURE-----

--diT81a9gloLbuVo+--

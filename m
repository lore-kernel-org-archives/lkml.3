Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758369AbaJaKAG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 06:00:06 -0400
Received: from down.free-electrons.com ([37.187.137.238]:41412 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756295AbaJaKAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 06:00:04 -0400
Date: Fri, 31 Oct 2014 10:57:06 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Corentin LABBE <clabbe.montjoie@gmail.com>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, davem@davemloft.net, grant.likely@linaro.org,
        akpm@linux-foundation.org, gregkh@linuxfoundation.org, joe@perches.com,
        mchehab@osg.samsung.com, crope@iki.fi, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH v5 4/4] crypto: Add Allwinner Security System crypto
 accelerator
Message-ID: <20141031095706.GA8054@lukather>
References: <1413728182-13569-1-git-send-email-clabbe.montjoie@gmail.com>
 <1413728182-13569-5-git-send-email-clabbe.montjoie@gmail.com>
 <20141021191149.GQ21108@lukather>
 <544A9FEA.6020304@gmail.com>
 <20141030171933.GR21251@lukather>
 <20141031072030.GA7563@gondor.apana.org.au>
 <20141031081323.GS21251@lukather>
 <20141031081803.GA8012@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LZvS9be/3tNcYl/X"
Content-Disposition: inline
In-Reply-To: <20141031081803.GA8012@gondor.apana.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 31, 2014 at 04:18:03PM +0800, Herbert Xu wrote:
> On Fri, Oct 31, 2014 at 09:13:23AM +0100, Maxime Ripard wrote:
> >
> > I don't understand here. Why would other drivers *not* being affected?
> >=20
> > If the scatter list passed by AF_ALG can be in highmem, I guess it's
> > the case for every driver out there. Almost every kernel code I've
> > seen so far makes the assumption that the memory it has is mapped and
> > accessible.
> >=20
> > Somehow, it's the driver's fault now, and not the part of kernel that
> > actually does the allocation?
>=20
> If you are implementing a crypto driver that is meant to handle
> requests from the crypto API then yes you need to handle highmem.

Is that documented somewhere?

> As I said if enough drivers are unable to address highmem and
> require copying/software fallbacks then we could provide this
> through the API and the driver would then only need to declare
> its lack of highmem support or use a helper.

On a 3.18-rc2 kernel:

$ git grep kmap -- crypto/
crypto/ahash.c:                         walk->data =3D kmap(walk->pg);
crypto/ahash.c:                         walk->data =3D kmap_atomic(walk->pg=
);
crypto/async_tx/async_memcpy.c:         dest_buf =3D kmap_atomic(dest) + de=
st_offset;
crypto/async_tx/async_memcpy.c:         src_buf =3D kmap_atomic(src) + src_=
offset;
crypto/scatterwalk.c:                   return kmap_atomic(scatterwalk_page=
(walk)) +
crypto/shash.c:                         data =3D kmap_atomic(sg_page(sg));
crypto/shash.c:                         data =3D kmap_atomic(sg_page(sg));

None of the drivers are.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--LZvS9be/3tNcYl/X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUU1zyAAoJEBx+YmzsjxAgSSgQAIZXxg1D8HkY10+VlsBYBuQw
htcdf6kd8lNh5VbUzBQ8MrFBJZ0a3mO/LPyF/A0seq6woYHxr65RM/BrnHwdj27j
DMy8+rEhWLljmyRbHKN868Q5SeMHXS3ASNyd7yrJSvWVztYUPN1jguNN7mdH+gK3
c5eylJeha8zHsjoi8u15Nyyfg8770l1yO7NUnT/QJNto+E314XLQGYLc1+1cec0t
VeeiDZqaAOkdNytqIB1Dlth7WBSiCId4Qmb0HRNU4htv2wyxr1Kdk6+61HTkT08z
h884R79SbbZ26Ox5jGHnn4RKnvUqY2nw1/k3D3l/dabGJ+ppLqZoUx1Z7iOHITj/
SW1yg5sE7sueYTaT0EMsUXhgvjadu9XDHQgPxsbCtS4N0jscQHfwWIt1iwLqyL8i
Sb7m4tzE8p1gMrpALnXC0sH/Tn/f48bPIhuysXi5OoQxqQp0/EUZ42HsvLiW4mVG
gli4I+Sv8tRfLkafqWLs7txq/BXh/W2v3KhqqDHCrEZGSaE9UVA1e9vuqNQah6/X
xcDlMMdKuKeM/VGuCY5OMsK3Lwh43ydWV6lL6GBlij8SV49aYIUAjOCnNHVZmfQA
B9zQ/Ga70uEGIhWJ/+bLA9mVKumHPLhNLMPGb4LGolBFlv2K5hcTehELPyBJFtlo
O9vtMX+R55Bs/o8iR+PK
=wXO4
-----END PGP SIGNATURE-----

--LZvS9be/3tNcYl/X--

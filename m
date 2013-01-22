Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604Ab3AVVAl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 16:00:41 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:59151 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267Ab3AVVAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 16:00:38 -0500
Date: Tue, 22 Jan 2013 22:00:29 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [PATCH 01/33] lib: devres: Introduce devm_ioremap_resource()
Message-ID: <20130122210029.GA13324@avionic-0098.adnet.avionic-design.de>
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
 <1358762966-20791-2-git-send-email-thierry.reding@avionic-design.de>
 <20130122174043.GA1411@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="y0ulUmNC+osPPQO6"
Content-Disposition: inline
In-Reply-To: <20130122174043.GA1411@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:GLghhW0zvfTPV7hFnqZh472VbvGjiYzAmB3qsS+rNeo
 8YKjbMwh7mjXnRCzorQz3KdLdFdOatulhjSOE+YvRaUwtuUjrj
 OFiXchxU+XF5+TKfNapoyqa/EnvaiRIy6/k/RSgVuT/eCRbGkQ
 +dcTFGuMq3Gq6v2GY2B7QGGPa9n9c+ywTqOFEGvVVleJa7dhH4
 lU8pTKme8uiUxJrm1dA0z1qE+qFVG7FKXWoiKNmDACzQHXTvL6
 S4DWr17KsnZXAsY5n3I7+1APFBoRP83PWXSqy/EZmDddeQWdZP
 79/Xl9fuvyKd/vvGMuD83snGKCrygHzeG9dz4zsAonQVN76OTj
 g0WB+Q2rNxSI3nkG/ER397JjLfBlDlerV85q4hRJe7sTQyY13o
 fTIHinCCEGed9+7IkZItbbWwX+rw3Rd3/Q=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 22, 2013 at 09:40:43AM -0800, Greg Kroah-Hartman wrote:
> On Mon, Jan 21, 2013 at 11:08:54AM +0100, Thierry Reding wrote:
> > The devm_request_and_ioremap() function is very useful and helps avoid a
> > whole lot of boilerplate. However, one issue that keeps popping up is
> > its lack of a specific error code to determine which of the steps that
> > it performs failed. Furthermore, while the function gives an example and
> > suggests what error code to return on failure, a wide variety of error
> > codes are used throughout the tree.
> >=20
> > In an attempt to fix these problems, this patch adds a new function that
> > drivers can transition to. The devm_ioremap_resource() returns a pointer
> > to the remapped I/O memory on success or an ERR_PTR() encoded error code
> > on failure. Callers can check for failure using IS_ERR() and determine
> > its cause by extracting the error code using PTR_ERR().
> >=20
> > devm_request_and_ioremap() is implemented as a wrapper around the new
> > API and return NULL on failure as before. This ensures that backwards
> > compatibility is maintained until all users have been converted to the
> > new API, at which point the old devm_request_and_ioremap() function
> > should be removed. To help prevent new users from being added in the
> > meantime, devm_request_and_ioremap() is marked __deprecated.
>=20
> I've edited the patch and removed the __depreciated line as that's just
> going to cause a whole lot of noise in the kernel.  I'd recommend just
> watching to ensure that we catch all users of the current function and
> convert them to the new one, and then we can drop it, no need to use
> __deprecated at all.

Okay, works for me. Both grep and the semantic patch can easily find
users of the current function.

Thierry

--y0ulUmNC+osPPQO6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ/v3tAAoJEN0jrNd/PrOh1lIP/33bvlictuT5YDgEt8Imjzzj
Icsz6cX8OMocZH/y5BRR47i60BF7X2Wk1oVB4M5dJuq0ZMJCH0sJ7Mdsw+aBse8e
/g9RVqek0J0TBiP5UxoyXUTsuk46Y7Z26+dR35XL9zHfePAjNPXyW9sbBJAcSA3R
xi1zKDwkEJHaqoDcuTARS5y4kA+0pNFUrdH288Oi93ZSP2RGM8dgQA2vrRavT0DP
MCcqPro2fAU65DjcHf3gpaMPsDGMUvUuOS3aHd5wb3k7jWjyOjDk+nwHlm6wXNPD
3aTnrBOnAAmZAcCWCQBZtCo5050wM0pvZCt4fWfbyRyA+fVySjktPOc8b7dxliJO
1YsH/7YdRwbpCHCnbUCtl5iTccDlZK01mTHIh/ZL2ufeIhB/pCTO93g9+6AwA7rp
2/sHoW6XT5HXa4V6sYyfSVK8jSPb1l3Ee8ob6E4t8xu+Lj8IICuIROZpGEu7erla
+9QfhUtvIBzLZgcqej2hTCfMGAWC0OwHiUQokXVZFdF7ICJQwrk/SWUBom93K7vY
BwZoJZX7WV85Xz7LcRLraG0YoeDyJY+sbabINYe402ykb6iQ5ns5v687Ig6bk64T
9NLjk9Z4znZXk4UObIw66y8bfoiIbnN9s73mqZOWR6GFfRQtkhtT7xJLrK0Sr6Pb
yVBVHziNwTxdjSxXl+zC
=H1bu
-----END PGP SIGNATURE-----

--y0ulUmNC+osPPQO6--

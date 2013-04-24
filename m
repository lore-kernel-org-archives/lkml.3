Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091Ab3DXGoO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 02:44:14 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:51122 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072Ab3DXGoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 02:44:13 -0400
Date: Wed, 24 Apr 2013 08:43:59 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: grant.likely@linaro.org, rob.herring@calxeda.com, tbergstrom@nvidia.com,
        amerilainen@nvidia.com, yongjun_wei@trendmicro.com.cn,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH -next v2] gpu: host1x: gr2d: fix error return code in
 gr2d_submit()
Message-ID: <20130424064359.GB1429@avionic-0098.mockup.avionic-design.de>
References: <CAPgLHd8zemyHf9j18qUrB4DUD8Qfn5PNj+KM7YVqL0RxHSVbzw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qcHopEYAB45HaUaB"
Content-Disposition: inline
In-Reply-To: <CAPgLHd8zemyHf9j18qUrB4DUD8Qfn5PNj+KM7YVqL0RxHSVbzw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:/eoMqKEaTwUyIJds6k8D5Zk8mogXBCzPW0eb68qOYpo
 PWk/VJQMDC0zZaaEXkMT6kh5pgBBWa7Xy9wJpRQWhnEldq0QfJ
 K48GVqSY26TxhoOO8absXrll1lDzhSkY6FBqvUwF9ZHLaplQxQ
 5AIGVkOVOaylqfIb0pDy6JWJ0fH9hEYKCojR4C3VBAKK1y+Tk0
 bn8H6N++3u/9Iyc0W4+WX6s/fimAAlcbFm4daYBl6PyUKP6md2
 3sJzJjzjfG/42ziBENYdwbCS+UxRCmwct24poIIEPAHvhbN17h
 9w9yyRYzmNWpPEDThnoUu3JGLSefmsWkuMf3gvZMu6soEkm6A6
 MIiBeGqY7E0U/02ueSnpw1NcDIfhujsTKUK+hayrvHp4G+UZb7
 j9mBg0T1AD5612sXMvAiZ14O1XB0QiFAdoSjtkiEyj85NMzakX
 L4OmO
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qcHopEYAB45HaUaB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 24, 2013 at 10:44:08AM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>=20
> Fix to return -EINVAL in the host1x_bo lookup error handling
> case instead of 0, as done elsewhere in this function.

So with my comment to v1 addressed this becomes invalid again. I think
in both cases using -ENOENT is a better choice. Pretty much any instance
where drm_gem_object_lookup() fails is handled by returning -ENOENT, so
we should do the same in this driver for consistency.

Thierry

--qcHopEYAB45HaUaB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRd38vAAoJEN0jrNd/PrOhkx8QAKirR4dkrXP0hQxUzEyeBxI9
S2fyPytNZVBYQTI9pyOU1Psu/xA0u3o5qmbmdwuM76EKyWdNnXGJITr9n40XIQBU
/2F7xzDhsQbe9Pg2KMUN8h5cNAHLSBsltqHJvnr5zNsGgrF4fBOwIVnSVIjELr7A
U5mGFPI0rt5nEcGNopsuh7nf2fBcSuCrJmM3vHlBXNDSxcdMYc7zhkIBOZprTHN9
HoOrO7BiVQRNU1bOrkjHscYiKMaLJtrrLbJFlBO4QdDGQXOcxbBJlxU9kno5p8Yu
yjwI61HksrlR0l7h+s3KNGlDr7B6WuQ8WgBxFpojtO0nA7w+PWJhQODccgZ5kY5b
cTUCVpMOk8Vn6kVtii52Txdexbn7ZQPgfWwannMB/wJHG5EQb5dyOLNuGuOZZvBV
Lfw3qWY6tlEdLIPQ7bf/ETNJjGXyrNIHVb/hZFtzjU9/hoDO6pvsTxweN1nwajnP
lta8LtlsHBvK+1fI7okL2vRQe2JqwhNtSeI0IjPXjkzDI0irmkoPyfX9kBbl/99Z
9LwburFHQi8YT5wUMlFlzVCduOWiXSWpZOEwFJBMFleHZfI0ggotAQoz09op/Ce/
tv4DwOhcyGZh5o9tnlm2AyRw3mymz7oCx8nqPfQlyTKpTXy/Kbu/QSkG6zZ0eL8d
29WEKSy5q7xhIVV/wJBk
=C2h1
-----END PGP SIGNATURE-----

--qcHopEYAB45HaUaB--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880Ab3DXO0z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 10:26:55 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:55262 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755199Ab3DXO0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 10:26:54 -0400
Date: Wed, 24 Apr 2013 17:26:15 +0300
From: Felipe Balbi <balbi@ti.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC: Lee Jones <lee.jones@linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <arnd@arndb.de>,
        <linus.walleij@stericsson.com>, <mian.yousaf.kaukab@stericsson.com>,
        Felipe Balbi <balbi@ti.com>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 04/10] usb: musb: ux500: harden checks for platform data
Message-ID: <20130424142615.GF23081@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1366729394-11406-1-git-send-email-lee.jones@linaro.org>
 <1366729394-11406-5-git-send-email-lee.jones@linaro.org>
 <5176E927.908@cogentembedded.com>
 <20130424065344.GB17416@gmail.com>
 <5177E57C.3010802@cogentembedded.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ULyIDA2m8JTe+TiX"
Content-Disposition: inline
In-Reply-To: <5177E57C.3010802@cogentembedded.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ULyIDA2m8JTe+TiX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 24, 2013 at 06:00:28PM +0400, Sergei Shtylyov wrote:
> Hello.
>=20
> On 24-04-2013 10:53, Lee Jones wrote:
>=20
> >>>  	struct musb_hdrc_platform_data *plat =3D dev->platform_data;
> >>>-	struct ux500_musb_board_data *data =3D plat->board_data;
> >>>+	struct ux500_musb_board_data *data;
>=20
> >>>-	param_array =3D data->dma_rx_param_array;
> >>>+	param_array =3D (data) ? data->dma_rx_param_array : NULL;
>=20
> >>    Why enclose a simple variable in parens?
>=20
> >Because 'data' is a pointer, so it contains a memory location,

heh, I don't think you fully understood Sergei's comment. He's asking
why you used:

	param_array =3D (data) ? data->dma_rx_param_array : NULL;

instead of:

	param_array =3D data ? data->dma_rx_param_array : NULL;

He's saying, correctly so, that the parens around data is unnecessary.

--=20
balbi

--ULyIDA2m8JTe+TiX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRd+uHAAoJEIaOsuA1yqRE714P/1FAnbBlWsb/LahkYHVnSpLc
6IYdOtQP7CIYthBvAwrNj26C0BP7CXMI439UbFGS2rGI5o6pd9jVrADqvTdTnv/A
/OL8IAE1nQ7o+A3RyzE+pSSqPXiiZEAErVGYtxFGLr/RvAgC0P2lvQtpjlKj+U+S
E+XIRiZSNNK5A2kwPML6TGBfEDA4GP7wkdvpojiBMhCqW4ZARd/ekaQLydOAdP/0
lHaUi6OK4BspKjoFis5kUnLaum4N9n2wlyMJVnXeKu1me+yMvElbEF9gQ9eznWkY
un3ucPfG7Bao8darkAju4etXbSMBtNNkvugG39k8bYtjoz71RBzdC57rKyetDuyl
UTwGxm767RPuePsvrFxl7Go5l1bLzgG2hvQcZFD1yoWVtDRp8QiWQQ9I8PNeYwFs
Ul0eoHy8fcOKUnn1jIJ1vy9QZ9kycXJbBMsY0zoYTBd9uDA31vpQ91OeRjY8rskU
jX0KjlaTSoOPMvLneGQgSEgmeSriOzQVULzajcsiWf5XeuC76y4hcKNuJ3KruZkf
VthW9Fy0orbptNsO2czJUofUOItKFkaw1drrcxnMut2QbfhOMWA2BqiZUKfcP5zD
CywVTPRFTeNn1GWjK5UY+1zmipz8H6jhHp/29pk47xrLJn9xzQZaxFsZzCvquh5T
+kT/mS/mVUf4+o1gVkRQ
=dnz2
-----END PGP SIGNATURE-----

--ULyIDA2m8JTe+TiX--

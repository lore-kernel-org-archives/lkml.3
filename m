Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897AbbAGIuH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 03:50:07 -0500
Received: from down.free-electrons.com ([37.187.137.238]:50797 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751848AbbAGIuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 03:50:05 -0500
Date: Wed, 7 Jan 2015 09:49:12 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Olliver Schinagl <oliver+list@schinagl.nl>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dev@linux-sunxi.org
Subject: Re: [PATCH v1] ARM:sunxi:sid: Make use of the of_match_ptr
Message-ID: <20150107084912.GD7853@lukather>
References: <1420616468-3782-1-git-send-email-oliver+list@schinagl.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kF9LAPPYk2MosVMu"
Content-Disposition: inline
In-Reply-To: <1420616468-3782-1-git-send-email-oliver+list@schinagl.nl>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kF9LAPPYk2MosVMu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jan 07, 2015 at 08:41:08AM +0100, Olliver Schinagl wrote:
> From: Olliver Schinagl <oliver@schinagl.nl>
>=20
> I probably have forgotten to use this macro for the of_match pointer, so
> this patch adds the of_match_ptr macro.
>=20
> Signed-off-by: Olliver Schinagl <oliver@schinagl.nl>
> ---
>  drivers/misc/eeprom/sunxi_sid.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/misc/eeprom/sunxi_sid.c b/drivers/misc/eeprom/sunxi_=
sid.c
> index 8385177..5a330d9 100644
> --- a/drivers/misc/eeprom/sunxi_sid.c
> +++ b/drivers/misc/eeprom/sunxi_sid.c
> @@ -25,6 +25,7 @@
>  #include <linux/kernel.h>
>  #include <linux/kobject.h>
>  #include <linux/module.h>
> +#include <linux/of.h>
>  #include <linux/of_device.h>
>  #include <linux/platform_device.h>
>  #include <linux/random.h>
> @@ -146,7 +147,7 @@ static struct platform_driver sunxi_sid_driver =3D {
>  	.remove =3D sunxi_sid_remove,
>  	.driver =3D {
>  		.name =3D DRV_NAME,
> -		.of_match_table =3D sunxi_sid_of_match,
> +		.of_match_table =3D of_match_ptr(sunxi_sid_of_match),

Why do you need this ? The sunxi_sid_of_match array is always defined.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--kF9LAPPYk2MosVMu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUrPMIAAoJEBx+YmzsjxAgO04P/RPXtSx9sRsutblw2Yli4BA6
MZwXfBMDn8MT6zyaiLm5OZ7/TQN+wuBzRFfjVZ44KMamXggvQEVfYZSbnPx/E+08
F9EYLH3uvXBTc1n+vqJGRVTV4GweCGbBdRCMypBOlT0W+lZL8mtjU2PhUJPW6slq
FmmldvcFzO2oZwnnazc/BUBFFOmfqiMlAqTaBdEowFeZut3dsihRL7nGS1Duptr+
6GwBuJbLnXFQEnB7YJEwfX4Jb7f74/ro/HHCwLs66k7GC167XfLJGO0Hy0WwwPo+
iYTXemObXEV8Sunq72cS1xIF1DybtAl4c1erNgOg0UcWQAYZFvV9+CcvCsFUZ5rQ
PerMoLUX2flvPNZ+ZBGaJMJStpS9NxC6vE7N0hXWlM9572BQqXb/qVyb8K4yNA3Y
3ty2F/uSgOpqb//g6BzW01uLfbRark8Jz1USGCdMfFp2L/9aLR7crbuxzs5Of6V+
GT00/8PoResi9nZneCq8auOBUAncgHipPdjBEp2srxbx9oWcXljqj321BSPgxrnX
IyMWHJKsuuawKKfDeKn3ptGnzL2/9F+E4njqmt429KkfhQEL36WxsZrBHRSiKA3g
Ur4oKKTsXV6nCANzBTk0XfH40iRjKue1c3QFwQRKTRLYJigNzgBPaiSlEa7t6FtZ
+sfLrVmOsw3fnnxbdcRz
=mBj+
-----END PGP SIGNATURE-----

--kF9LAPPYk2MosVMu--

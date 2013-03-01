Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751667Ab3CAHzC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 02:55:02 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56229 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750696Ab3CAHzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 02:55:01 -0500
Date: Fri, 1 Mar 2013 15:54:30 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Thiago Farina <tfransosi@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>
Subject: Re: [PATCH 2/2] regulators: max8998.c: use dev_err() instead of
 printk()
Message-ID: <20130301075426.GM25302@opensource.wolfsonmicro.com>
References: <1361591486-12663-1-git-send-email-tfarina@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="m+utxuhC6KVTvgNz"
Content-Disposition: inline
In-Reply-To: <1361591486-12663-1-git-send-email-tfarina@chromium.org>
X-Cookie: Condense soup, not books!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--m+utxuhC6KVTvgNz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 23, 2013 at 12:51:26AM -0300, Thiago Farina wrote:
> Fixes the following checkpatch warning:
>=20
> WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(=
=2E..  to printk(KERN_ERR ...

This doesn't apply against current mainline, and...

> @@ -666,7 +666,7 @@ static int max8998_pmic_probe(struct platform_device =
*pdev)
>  		/* Check if SET1 is not equal to 0 */
>  		if (!pdata->buck1_set1) {
>  			dev_err(&pdev->dev,
> -                                "MAX8998 SET1 GPIO defined as 0 !\n");
> +				"MAX8998 SET1 GPIO defined as 0 !\n");
>  			WARN_ON(!pdata->buck1_set1);
>  			ret =3D -EIO;
>  			goto err_out;

=2E..this (which is one of the failing hunks) is an indentation change
which bears no relation to the changelog.

I've applied the final hunk which looks good but please be more careful
in future.

--m+utxuhC6KVTvgNz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRMF6sAAoJELSic+t+oim9YFwP/2Qruhg93bEM963fUvS93PnQ
EesO7Req8zTxlPTZhae0k/hggpyXkYl96gynpLD2CPDuuXBIpswnAO76Kkhi/XzO
hKw8fgRHETn44PyMXHfNBKU0kUBnNbcbnyKYXM6meInSegpoRMW8LQmTuI1zdQwe
qMku2IPC2SkeKFLFDX3hUKJUIiFjqctrQTSvN2rrxf+9TuZi0J4zoUHn/9sjh1Xi
InENAVQExafFW9RacRr9qeAWLMV0U8Zu/D5eBIJxFmr0LK5axq7MgHK5LY/wlLpR
aXplmGu7Kn+FgYRgCbHdAo1hp+/11+LQgmfv8fikGRa7H33EKJJEYUMyn5Y4L4Jz
ttS7aEbuY41RD9+c1Q7MEyePdMUR9uL7D9UYP14GcHHKEYHMVUVJsQnQe0TB4iRs
yr753RReX/j0DNkEwWWubRb/eWMrQo+fNjrquObmf4J1FhkuYxt7aCJxXB2dhsQc
FhVo2lb6spOhMuUE1L+jx8bWXZwUD8ZeZupfLJE3c8Kbj/zyJRVGGclIvWoyhY4u
4dWPjqTpxOrT1wKaq7zQoNFhjTWQuRP3b6O2FGMb7Rl1KUlSUaw653U1QwPC3n5+
WkqdPiDKMFt0DGXK+a6UAiyCUcGSUQqrOnLFkwFHTeyRbXMCaTO9yY1sY+hJtx9r
gkMohGlqeNbuY6i4kGVj
=08q2
-----END PGP SIGNATURE-----

--m+utxuhC6KVTvgNz--

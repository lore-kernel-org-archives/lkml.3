Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075AbaLHQtN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 11:49:13 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:14504 "EHLO
	imgpgp01.kl.imgtec.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752470AbaLHQtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 11:49:10 -0500
X-PGP-Universal: processed;
	by imgpgp01.kl.imgtec.org on Mon, 08 Dec 2014 16:49:08 +0000
Message-ID: <5485D683.2010100@imgtec.com>
Date: Mon, 8 Dec 2014 16:49:07 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.8.0
MIME-Version: 1.0
To: Sifan Naeem <sifan.naeem@imgtec.com>, <mchehab@osg.samsung.com>
CC: <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <james.hartley@imgtec.com>, <ezequiel.garcia@imgtec.com>
Subject: Re: [PATCH 2/5] rc: img-ir: pass toggle bit to the rc driver
References: <1417707523-7730-1-git-send-email-sifan.naeem@imgtec.com> <1417707523-7730-3-git-send-email-sifan.naeem@imgtec.com>
In-Reply-To: <1417707523-7730-3-git-send-email-sifan.naeem@imgtec.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="hfgAoa7RL0daX2dNSqdEBvnC7B6Vm5S6k"
X-Originating-IP: [192.168.154.101]
X-ESG-ENCRYPT-TAG: b93fcccb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--hfgAoa7RL0daX2dNSqdEBvnC7B6Vm5S6k
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/12/14 15:38, Sifan Naeem wrote:
> Add toggle bit to struct img_ir_scancode_req so that protocols can
> provide it to img_ir_handle_data(), and pass that toggle bit up to
> rc_keydown instead of 0.
>=20
> This is nedded for the upcoming rc-5 and rc-6 patches.

Typo (nedded).

Otherwise:
Acked-by: James Hogan <james.hogan@imgtec.com>

Cheers
James

>=20
> Signed-off-by: Sifan Naeem <sifan.naeem@imgtec.com>
> ---
>  drivers/media/rc/img-ir/img-ir-hw.c |    8 +++++---
>  drivers/media/rc/img-ir/img-ir-hw.h |    2 ++
>  2 files changed, 7 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/media/rc/img-ir/img-ir-hw.c b/drivers/media/rc/img=
-ir/img-ir-hw.c
> index 61850a6..4a1407b 100644
> --- a/drivers/media/rc/img-ir/img-ir-hw.c
> +++ b/drivers/media/rc/img-ir/img-ir-hw.c
> @@ -792,6 +792,7 @@ static void img_ir_handle_data(struct img_ir_priv *=
priv, u32 len, u64 raw)
>  	struct img_ir_scancode_req request;
> =20
>  	request.protocol =3D RC_TYPE_UNKNOWN;
> +	request.toggle   =3D 0;
> =20
>  	if (dec->scancode)
>  		ret =3D dec->scancode(len, raw, hw->enabled_protocols, &request);
> @@ -802,9 +803,10 @@ static void img_ir_handle_data(struct img_ir_priv =
*priv, u32 len, u64 raw)
>  	dev_dbg(priv->dev, "data (%u bits) =3D %#llx\n",
>  		len, (unsigned long long)raw);
>  	if (ret =3D=3D IMG_IR_SCANCODE) {
> -		dev_dbg(priv->dev, "decoded scan code %#x\n",
> -			request.scancode);
> -		rc_keydown(hw->rdev, request.protocol, request.scancode, 0);
> +		dev_dbg(priv->dev, "decoded scan code %#x, toggle %u\n",
> +			request.scancode, request.toggle);
> +		rc_keydown(hw->rdev, request.protocol, request.scancode,
> +			   request.toggle);
>  		img_ir_end_repeat(priv);
>  	} else if (ret =3D=3D IMG_IR_REPEATCODE) {
>  		if (hw->mode =3D=3D IMG_IR_M_REPEATING) {
> diff --git a/drivers/media/rc/img-ir/img-ir-hw.h b/drivers/media/rc/img=
-ir/img-ir-hw.h
> index 1fc9583..5e59e8e 100644
> --- a/drivers/media/rc/img-ir/img-ir-hw.h
> +++ b/drivers/media/rc/img-ir/img-ir-hw.h
> @@ -138,10 +138,12 @@ struct img_ir_timing_regvals {
>   *		RC_TYPE_UNKNOWN).
>   * @scancode:	Scan code of received message (must be written by
>   *		handler if IMG_IR_SCANCODE is returned).
> + * @toggle:	Toggle bit (defaults to 0).
>   */
>  struct img_ir_scancode_req {
>  	enum rc_type protocol;
>  	u32 scancode;
> +	u8 toggle;
>  };
> =20
>  /**
>=20


--hfgAoa7RL0daX2dNSqdEBvnC7B6Vm5S6k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUhdaEAAoJEGwLaZPeOHZ6mioP/1HjC71Fq8+i4U55tM7bJHbg
7mOl29aoEfUKb+zLL7m1TmzR2lNMDWItPU+0d1yn/wnv65GEHwabSaNWUBDN7ILz
ngCOIXHVZEHLm8avR3MP/9CSx8pAGc7MaY5O5TQ/9IsRyvp+VaQ93B3ELkRLh3PW
FEhYSlqjDtxmpWMeYzvZtlySK2ZP0tyIVKAn3ecvZbIO0acW9hXpqBdVzvU0HWQz
TI7guwAtmTUxr9gjz5ys98WQ8wOn9fU86/8ZaXuTIOLKOBQKsBt4pb5l/zXVgnha
nOcaRxrJSolLrX/SnIovAmoT+FV+G2CgOu7bUNB531Nf4FdxNSNofih+oWU6305Q
NmXLmYmggSozEtDtf91ywLJ3jAmmHsuh4+4TjTgY4rzT0B9+uRhHidfB78iDJyuz
Nfd7+6/OWcEAzJrdUEkJHwQyK/oWUlxDFXmPF8rxRc0WCpp3RA7fttFZ0Jxo1E99
+Pk7r4BYgqyklRw5HWPTxCs/JGCfQPXc7qO/w1DyHWr/2CLV+5vSqy64YOPLehyz
di81DFZMwPTbtedfd6QIlFXBvJvjXAQloTJ/ucF4kpB5amDgGYvQ8ODuoRU694lL
w/HeBQVw9z9P6whMi7yI7WhuonZw+ZUEoAMFqQgceB9+0+hZENu5Sw+B2knq0/jP
W7xFwtawQuaKLtmpw9Ca
=C4Mn
-----END PGP SIGNATURE-----

--hfgAoa7RL0daX2dNSqdEBvnC7B6Vm5S6k--

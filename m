Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760792Ab3B0TPE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 14:15:04 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:49843 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760768Ab3B0TPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 14:15:02 -0500
Date: Wed, 27 Feb 2013 21:14:55 +0200
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: Greg KH <gregkh@linuxfoundation.org>, Luciano Coelho <coelho@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: container_of() doubt
Message-ID: <20130227191455.GB27264@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <20130227191322.GA27264@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="61jdw2sOBCFtR2d/"
Content-Disposition: inline
In-Reply-To: <20130227191322.GA27264@arwen.pp.htv.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--61jdw2sOBCFtR2d/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi again,

On Wed, Feb 27, 2013 at 09:13:22PM +0200, Felipe Balbi wrote:
> Hi Greg,
>=20
> hehe, you must've answered this over and over again, but I don't see the
> need for __mptr in the container_of() macro. I tried googling it but
> couldn't find much.
>=20
> I get the macro, but not the need __mptr. Wouldn't this work the same
> way ?
>=20
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index 80d3687..bbce857 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -717,8 +717,7 @@ static inline void ftrace_dump(enum ftrace_dump_mode =
oops_dump_mode) { }
>   *
>   */
>  #define container_of(ptr, type, member) ({			\
> -	const typeof( ((type *)0)->member ) *__mptr =3D (ptr);	\
> -	(type *)( (char *)__mptr - offsetof(type,member) );})
> +	(type *)( (char *)(ptr) - offsetof(type,member) );})
> =20
>  /* Trap pasters of __FUNCTION__ at compile-time */
>  #define __FUNCTION__ (__func__)
>=20
> why do we need this type * NULL ?

nevermind, type safety ;-)

--=20
balbi

--61jdw2sOBCFtR2d/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRLlsvAAoJEIaOsuA1yqREqw8P/1jh/8/iD81JeiCVExKo6Qn0
G9zZrUSl3MWiRsJGkIo6zJwDuVYAU341lR7MbUrBnL2ky8EF6yyIPTZXMpyzuSu2
hcYLpPjoh+DkJ4OmuHaqRnLYhw4l4kkVbvQ5sqa1T4qmRxgPRXYUDMpcRFP4WUoi
NfrpHd+dmQi3uCRu3mKGmUaDu4i7G8/DfV1gxcd/o6TvOT44N3dEqQHtd7TNSxWP
lMUbp1znEFDGtsUVUDEV5adm0hmLYq8P+gu74hINcIWWg4lAB8pux0A5VMpn9hpI
lPcHu6cSIE14pNnjvTYzahq8kI4LbSY6M/zreXXLTZ1m1CeRG4ohI4b+MNrMQDQh
/oQdAH0FOkO6C1i+UL1Es09vG7y0CpTBRSAQzurLUg7yJqm0jQUaH0rQBcfwS9OT
8+sPpmSaqXquJ77TCHqxi+6bWQrt/RFp8gcz97KPcEUCc6b6jjYwuyownViOcN2n
dXR3R8jZFoE5Aky5Y2khr3YJSnZ1rQntNesP5PgI81zeVUmIe0xiWsyv0LsycBEE
8ZGmznuvHNmKu5LV/R8LlVxg8cYBCnDzjG+3cJoFjHQAGV1y+F8riGjcavQkd3Qa
zUDSvxbDp6t6ceZpzUi0Z01SR2TJTsFMoJoC1BGbpn7OJtzcYsj2Z7nv/4JOIiEK
vTiS0TQ3gNV/hrxKovUP
=sdxw
-----END PGP SIGNATURE-----

--61jdw2sOBCFtR2d/--

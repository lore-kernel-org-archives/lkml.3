Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460Ab3CDE5F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 23:57:05 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33892 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754503Ab3CDE5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 23:57:03 -0500
Message-ID: <1362373013.3768.295.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 052/153] idr: idr_for_each_entry() macro
From: Ben Hutchings <ben@decadent.org.uk>
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: stable@vger.kernel.org, akpm@linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 04 Mar 2013 04:56:53 +0000
In-Reply-To: <20130304033712.754098899@decadent.org.uk>
References: <20130304033712.754098899@decadent.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-BvIF4gnICbNZiyObaa/L"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-BvIF4gnICbNZiyObaa/L
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2013-03-04 at 03:37 +0000, Ben Hutchings wrote:
> 3.2-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Philipp Reisner <philipp.reisner@linbit.com>
>=20
> commit 9749f30f1a387070e6e8351f35aeb829eacc3ab6 upstream.
>=20
> Inspired by the list_for_each_entry() macro
>=20
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>

Philipp, please can I have an explicit Signed-off-by from you?  It was
missing in mainline though this change appeared in a long series of drbd
changes with proper Signed-off-by lines.

Ben.

> ---
>  include/linux/idr.h |   11 +++++++++++
>  1 file changed, 11 insertions(+)
>=20
> diff --git a/include/linux/idr.h b/include/linux/idr.h
> index 255491c..52a9da2 100644
> --- a/include/linux/idr.h
> +++ b/include/linux/idr.h
> @@ -152,4 +152,15 @@ void ida_simple_remove(struct ida *ida, unsigned int=
 id);
> =20
>  void __init idr_init_cache(void);
> =20
> +/**
> + * idr_for_each_entry - iterate over an idr's elements of a given type
> + * @idp:     idr handle
> + * @entry:   the type * to use as cursor
> + * @id:      id entry's key
> + */
> +#define idr_for_each_entry(idp, entry, id)				\
> +	for (id =3D 0, entry =3D (typeof(entry))idr_get_next((idp), &(id)); \
> +	     entry !=3D NULL;                                             \
> +	     ++id, entry =3D (typeof(entry))idr_get_next((idp), &(id)))
> +
>  #endif /* __IDR_H__ */
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--=20
Ben Hutchings
Always try to do things in chronological order;
it's less confusing that way.

--=-BvIF4gnICbNZiyObaa/L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUTQplee/yOyVhhEJAQrReg/+PPfj8U/FCDOvbAhUwWHB/LySc1GubQho
VsMD1WzpxeV1aifL8jWTIuNf0F3lHkAwpFqhoooHCm4/s7A27etdw3q6Co0LK3MF
NMpfFDCQ5bJEA5czPwkiRMWu+sbCpW7cj5nCfrZ6DjJxUY4ksYV4Kq2dYPJd/QIT
PqCp8xECIsBRm75q2tH8xdEpfAr+xH6MfLObfwQAZ1z58ziU6zEpuFyBTBbZnXrE
3yUU76zxd6O956u9G2aZMt7qQx5deXPgUuGC6WyYu4q0EMPqSTGZNwdMA6Zz2kQK
y4IlpH4I/8h59SGs5KEiAnQCo8e9x6LxpRlJNoLhbl22uMYxe8ZyIy5h9uTHlc4m
NfM5HZjwPPO4xyKCc5GwFWVXyGqbEePU1dmMhFoPosHLcF1yL0rgPbkzKAH/UpY9
lIdR0+R3uQUPAvgixUsWSkoq6JVoAhtE2eyD40pVMVIHy0uarC3/EC420QpLnijp
Pbp5DXatRxBYCqq9OHjMu6puDERPhfr8gc+H7yfjYCWcwtGCfaySsp/+nTnBQjpA
2Vcg2eqsb4DXchqXzT/jBtOUwffsrX16z9A41oZ8QN2KfPZfBjRW9DSEHL8sMNAt
numlr6cEu4roMjAjEWVtYna9XH5Am3Tb0iRpL4ifyjmSl0uE1Ffxv0gllqduitoP
qOFfIErR8Ns=
=IWuk
-----END PGP SIGNATURE-----

--=-BvIF4gnICbNZiyObaa/L--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422913Ab3CVSg3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 14:36:29 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43291 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422880Ab3CVSg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 14:36:27 -0400
Message-ID: <1363977368.3728.35.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH] register_console: prevent adding the same console twice
From: Ben Hutchings <ben@decadent.org.uk>
To: Andreas =?ISO-8859-1?Q?Bie=DFmann?= <andreas@biessmann.de>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kay Sievers <kay@vrfy.org>, stable@vger.kernel.org
Date: Fri, 22 Mar 2013 18:36:08 +0000
In-Reply-To: <1363947052-15605-1-git-send-email-andreas@biessmann.de>
References: <1363947052-15605-1-git-send-email-andreas@biessmann.de>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-IRp0Lp8FklGCz4MV84fW"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:9535:520b:eb30:917a
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-IRp0Lp8FklGCz4MV84fW
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2013-03-22 at 11:10 +0100, Andreas Bie=C3=9Fmann wrote:
> This patch guards the console_drivers list to be corrupted. The
> for_each_console() macro insist on a strictly forward list ended by NULL:
>=20
>  con0->next->con1->next->NULL
>=20
> Without this patch it may happen easily to destroy this list for example =
by
> adding 'earlyprintk' twice. This will result in the following list:
>=20
>  con0->next->con0
>=20
> This in turn will result in an endless loop in console_unlock() later on =
by
> printing the first __log_buf line endlessly.
>=20
> Signed-off-by: Andreas Bie=C3=9Fmann <andreas@biessmann.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Kay Sievers <kay@vrfy.org>
> Cc: stable@vger.kernel.org
> ---
>  kernel/printk.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
>=20
> diff --git a/kernel/printk.c b/kernel/printk.c
> index 0b31715..f78bfcd 100644
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -2254,6 +2254,14 @@ void register_console(struct console *newcon)
>  	unsigned long flags;
>  	struct console *bcon =3D NULL;
> =20
> +	if (console_drivers)
> +		for_each_console(bcon)
> +			if (bcon =3D=3D newcon) {
> +				pr_warn("prevent adding console '%s%d' twice\n",
> +					newcon->name, newcon->index);

Since this is surely a bug in the calling driver, I think the warning
should be louder, i.e. use WARN.

Ben.

> +				return;
> +			}
> +
>  	/*
>  	 * before we register a new CON_BOOT console, make sure we don't
>  	 * already have a valid console

--=20
Ben Hutchings
Make three consecutive correct guesses and you will be considered an expert=
.

--=-IRp0Lp8FklGCz4MV84fW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUUykmOe/yOyVhhEJAQq3eBAAgvLwIV251d3A82E/N9kZgFoExWO3xy31
hArNHyHXklQdukgVQH9uqKJxYpIhr9rhjf2O7TL6yBrNDA306AujTaqWM51bcqe1
vM9VwzW0jFifRTdv1tAhbm0ydZ3MiV893JYtu4vzIdV/+rAa7N0QpYjU2d0PKYpV
UpNcDfmBAJhrd6Y3kyxFqSUjhW104NU+B+RVet4cpom0EPRgjyqPHZnOf/XnbU5M
PGX/4yTVpWGI9fWFddg25qjpMRBRMmj7tDqTBOkk4LZdLbFSoRzL6JF4qWHRjiBZ
V33KxmRHCOPVaYQcExmDPFhebFCcQwBBSddBYVeLqloZpatLlVCZEvwbv3JQ3Qpl
XXvSs7GN4obQ/yA+x1CqcK6ITI39OqryAJ6cfm5BUIrQzYvDbn51oBvuBGIkF868
CRHQUFKzhLawFwuOOp8YiqbAuVdiEZsKLAkRk5tCGQqLLNlHAeGyDEnarVJvaQdU
Tpa5EVVwdDZZ58+EfM3L/tpPu08TJejbEPIbmoqhIgbAJ4COn5CWaXvacPkj0jab
IdQsDbvXK3QMc1zgEPd0mHAROroio2DzcWavEbWlEpnWztFHo/A5En5EKgJ2nxgO
PMnZZX0fWBeBweprXV4rkxjMVPYXx0sUFa+jx5ZTdaEp38Pb5upUoP/CfWy3MYq7
7eubLYaO/r8=
=LijB
-----END PGP SIGNATURE-----

--=-IRp0Lp8FklGCz4MV84fW--

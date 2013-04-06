Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932722Ab3DFT4J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 15:56:09 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37042 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756574Ab3DFT4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 15:56:07 -0400
Message-ID: <1365278155.2840.61.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 14/56] mwifiex: cancel cmd timer and free curr_cmd in
 shutdown process
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Marco Cesarano <marco@marvell.com>, Bing Zhao <bzhao@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>
Date: Sat, 06 Apr 2013 20:55:55 +0100
In-Reply-To: <20130402224713.540410031@linuxfoundation.org>
References: <20130402224711.840825715@linuxfoundation.org>
	 <20130402224713.540410031@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-UgUa29X8DMB78uTjvPYq"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a487:d53e:a04e:3a36
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-UgUa29X8DMB78uTjvPYq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-04-02 at 15:49 -0700, Greg Kroah-Hartman wrote:
> 3.0-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Bing Zhao <bzhao@marvell.com>
>=20
> commit 084c7189acb3f969c855536166042e27f5dd703f upstream.
>=20
> curr_cmd points to the command that is in processing or waiting
> for its command response from firmware. If the function shutdown
> happens to occur at this time we should cancel the cmd timer and
> put the command back to free queue.
>=20
> Tested-by: Marco Cesarano <marco@marvell.com>
> Signed-off-by: Bing Zhao <bzhao@marvell.com>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This also had:

    Cc: <stable@vger.kernel.org> # 3.8

so I wonder whether this is good/bad/indifferent for 3.0.y.

Ben.

> ---
>  drivers/net/wireless/mwifiex/init.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
>=20
> --- a/drivers/net/wireless/mwifiex/init.c
> +++ b/drivers/net/wireless/mwifiex/init.c
> @@ -561,6 +561,14 @@ mwifiex_shutdown_drv(struct mwifiex_adap
>  		return ret;
>  	}
> =20
> +	/* cancel current command */
> +	if (adapter->curr_cmd) {
> +		dev_warn(adapter->dev, "curr_cmd is still in processing\n");
> +		del_timer(&adapter->cmd_timer);
> +		mwifiex_insert_cmd_to_free_q(adapter, adapter->curr_cmd);
> +		adapter->curr_cmd =3D NULL;
> +	}
> +
>  	/* shut down mwifiex */
>  	dev_dbg(adapter->dev, "info: shutdown mwifiex...\n");
> =20
>=20


--=20
Ben Hutchings
Power corrupts.  Absolute power is kind of neat.
                           - John Lehman, Secretary of the US Navy 1981-198=
7

--=-UgUa29X8DMB78uTjvPYq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUWB9y+e/yOyVhhEJAQqC9g//RM9oGbeTZRJgnVxPwxOGqUsaJkGFBALq
Opt1gBmjc6h4mqlwFW5HCg03H87s14nHo+J+xtMROVaqOu7hTgF1xExPWBFV0uc+
uFmeiqkHqafuOwPDOyOS3WmD3nM4K/8LT3BIKMo3NJidTCx2ht1M30QnAaSt9BSp
BX2IfXQ2E4VgYEdx82BZ3EwjqT2DVd+JCJwjdA9+VLPMNd3Xjgq84ee8E5NGyqyf
tY7f2/041IUWEeA+WZZYvfZN8KpAi9K83djL6UEB6Yz74sR5YMLyvq3twkZgIbTu
h+hflSWm3nHlUu7Bn7bFggGTx2sf6Axj/XqP9rdRotbiFkVgRfhEJ7UkghyWG6V3
K24ydt5YykJZpCHDMEZlEAnjFSZZkLtIFz09AguDvxc+88XrlhbvOzq2gMdVqEZw
3sm2+IgkJpsZ5KgnxqfaqefIb4FZS4UvO0kRdFGHjZf2XwmCj23VGtQ8FzBDA637
OnMHYI+A8UErVQnRQaiXyKX9FtqC8a2AvgPP6MlwQHCkZ5EqmNlJSLzNCHbc6LR/
uZii7TqpiHLP5qV0W5Ubm0GIWWfAig6OLw00kn2eF8/zUdhiAzA6J9FaDA0XUCh1
FeZySrcbHfx7oR+gAO0Yf476v3OKMbaZtxXv0v+McFmCCe7jOV+/QGa+ouVxd1gO
g8EM1FjjqLo=
=L0tF
-----END PGP SIGNATURE-----

--=-UgUa29X8DMB78uTjvPYq--

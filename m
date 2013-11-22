Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648Ab3KVQQp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 11:16:45 -0500
Received: from mail-bk0-f44.google.com ([209.85.214.44]:53312 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755521Ab3KVQQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 11:16:44 -0500
Date: Fri, 22 Nov 2013 17:16:09 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Arnd Bergmann <arnd@arndb.de>, Rob Herring <rob.herring@calxeda.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clocksource: Do not drop unheld reference on device node
Message-ID: <20131122161607.GA5088@ulmo.nvidia.com>
References: <1382136588-15320-1-git-send-email-treding@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZPt4rx8FFjLCG7dd"
Content-Disposition: inline
In-Reply-To: <1382136588-15320-1-git-send-email-treding@nvidia.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 19, 2013 at 12:49:48AM +0200, Thierry Reding wrote:
> When booting a recent kernel on ARM with OF_DYNAMIC enabled, the kernel
> warns about the following:
>=20
> 	[    0.000000] ERROR: Bad of_node_put() on /timer@50004600
> 	[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.12.0-rc5-next=
-20131017-00077-gedfd827-dirty #406
> 	[    0.000000] [<c0015b68>] (unwind_backtrace+0x0/0xf4) from [<c00117e4>=
] (show_stack+0x10/0x14)
> 	[    0.000000] [<c00117e4>] (show_stack+0x10/0x14) from [<c055f734>] (du=
mp_stack+0x9c/0xc8)
> 	[    0.000000] [<c055f734>] (dump_stack+0x9c/0xc8) from [<c03b47d4>] (of=
_node_release+0x90/0x9c)
> 	[    0.000000] [<c03b47d4>] (of_node_release+0x90/0x9c) from [<c03b5084>=
] (of_find_matching_node_and_match+0x78/0xb4)
> 	[    0.000000] [<c03b5084>] (of_find_matching_node_and_match+0x78/0xb4) =
=66rom [<c07887c8>] (clocksource_of_init+0x60/0x70)
> 	[    0.000000] [<c07887c8>] (clocksource_of_init+0x60/0x70) from [<c076e=
99c>] (start_kernel+0x1f4/0x33c)
> 	[    0.000000] [<c076e99c>] (start_kernel+0x1f4/0x33c) from [<80008074>]=
 (0x80008074)
>=20
> This is caused by clocksource_of_init() dropping a reference on the
> device node that it never took. The reference taken by the loop is
> implicitly dropped on subsequent iterations. See the implementation of
> and the comment on top of the of_find_matching_node_and_match()
> function for reference (no pun intended).
>=20
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
>  drivers/clocksource/clksrc-of.c | 1 -
>  1 file changed, 1 deletion(-)

Can someone look at this?

Thierry

> diff --git a/drivers/clocksource/clksrc-of.c b/drivers/clocksource/clksrc=
-of.c
> index 35639cf4..b9ddd9e 100644
> --- a/drivers/clocksource/clksrc-of.c
> +++ b/drivers/clocksource/clksrc-of.c
> @@ -35,6 +35,5 @@ void __init clocksource_of_init(void)
> =20
>  		init_func =3D match->data;
>  		init_func(np);
> -		of_node_put(np);
>  	}
>  }
> --=20
> 1.8.4
>=20

--ZPt4rx8FFjLCG7dd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSj4NHAAoJEN0jrNd/PrOhAGUP+weM+fqWtxuCOVkeo1ycV82N
AytcVFwRYmyu1ImSntQfrmZtbKi5qaGGp/8IPcAEgRwsYWgFkzZ9lvJiDNFPF5qc
sAukrmpG8OmLHOhaviTW1YuWye8yAHQD3zasdqLFnzd7W3tixjzNf/Ff2+Zv0n7e
maCAx3wYhDCls0pLDf/iD3mAEJQW0e3mrraEJ4fVwyPCt5gdTsekAhrOuCUt4dWb
aQoPA7oMEOJKmCxiMRDnkVO31e0LlWJkve0UyD9//d2j1sj6npRi/B3mgpCfFzKq
BkWOEXw6/VWVB77APFpbQkbk25YFmjtYi7HVlx/jRh69sLsxBd82UbywS+vQUt2o
Nor+Mg7f9ujiSWk2jSmLQ2QOMZZUxKwhkcT+tYYv5sfVhljDc1Mr2OLyzZYMx/ld
jNUFAkgnMrA6sgJ1jDDIDSPz1aUI9hGgJecLbHdE/SezLrT0Ip6N+BBzWa0O8bba
HURw8gBKWmUl9vABi3E9QRBjh8N2WEDBC3B9JtmdwEdTObmvXUT8eMMYCtqLs/2O
WL2SLpEx9aeJOeIXJ0UrtxwYC0SgEWGNqsQvvoAbUQMH4PsaTRWxz9vG9LpauZVL
Z4YQOInF6MMo/2QWo+bWtuMV/96DFebJP81vGEFekzPZIdR1ozToiXqmP0rn5Ldm
nlL0m9WvpqFChC+W7DrI
=iCiS
-----END PGP SIGNATURE-----

--ZPt4rx8FFjLCG7dd--

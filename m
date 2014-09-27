Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751398AbaI0AzO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 20:55:14 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:42793 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbaI0AzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 20:55:13 -0400
Date: Fri, 26 Sep 2014 19:55:06 -0500
From: Felipe Balbi <balbi@ti.com>
To: Behan Webster <behanw@converseincode.com>
CC: <mturquette@linaro.org>, <t-kristo@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] clk, ti, LLVMLinux: Move __init outside of type
 definition
Message-ID: <20140927005506.GB25432@saruman>
Reply-To: <balbi@ti.com>
References: <1411777908-16016-1-git-send-email-behanw@converseincode.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2B/JsCI69OhZNC5r"
Content-Disposition: inline
In-Reply-To: <1411777908-16016-1-git-send-email-behanw@converseincode.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--2B/JsCI69OhZNC5r
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 26, 2014 at 05:31:48PM -0700, Behan Webster wrote:
> As written, the __init for ti_clk_get_div_table is in the middle of the r=
eturn
> type.
>=20
> The gcc documentation indicates that section attributes should be added t=
o the
> end of the function declaration:
>=20
>   extern void foobar (void) __attribute__ ((section ("bar")));
>=20
> However gcc seems to be very permissive with where attributes can be plac=
ed.
> clang on the other hand isn't so permissive, and fails if you put the sec=
tion
> definition in the middle of the return type:
>=20
> drivers/clk/ti/divider.c:298:28: error: expected ';' after struct
> static struct clk_div_table
>                            ^
>                            ;
> drivers/clk/ti/divider.c:298:1: warning: 'static' ignored on this
>       declaration [-Wmissing-declarations]
> static struct clk_div_table
> ^
> drivers/clk/ti/divider.c:299:9: error: type specifier missing,
>       defaults to 'int' [-Werror,-Wimplicit-int]
> __init *ti_clk_get_div_table(struct device_node *node)
> ~~~~~~  ^
> drivers/clk/ti/divider.c:345:9: warning: incompatible pointer types
>       returning 'struct clk_div_table *' from a function with result type=
 'int *' [-Wincompatible-pointer-types]
>         return table;
>                ^~~~~
> drivers/clk/ti/divider.c:419:9: warning: incompatible pointer types
>       assigning to 'const struct clk_div_table *' from 'int *' [-Wincompa=
tible-pointer-types]
>         *table =3D ti_clk_get_div_table(node);
>                ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~
> 3 warnings and 2 errors generated.
>=20
> By convention, most of the kernel code puts section attributes between the
> return type and function name. In the case where the return type is a poi=
nter,
> it's important to place the '*' on left of the __init.
>=20
> This updated code works for both gcc and clang.
>=20
> Signed-off-by: Behan Webster <behanw@converseincode.com>
> Reviewed-by: Mark Charlebois <charlebm@gmail.com>

makes sense to me:

Reviewed-by: Felipe Balbi <balbi@ti.com>

I wonder if we should add this a Sparse or Coccinelle rule.

--=20
balbi

--2B/JsCI69OhZNC5r
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUJgrqAAoJEIaOsuA1yqREFagQAI7zUfb0Zj13gBHmwg1mHGkd
Ty8C+vUqpUG4TSsPBE3fRRmR2U54jIGlr4EbqzdfIqf4ITAwI7tcj3JYdvKTSpP+
MailrooJHcfFcQLoDMYg0EUT00Wlru2voy8YTk1WTyWNeWGF5xCMsxQBukawYW//
dAPT1DKJiR2vTrq8woog+Z5igcOWV6X+hOZuSmpA3oqMbmTAVVZdHp0mvBMmewT2
1pdSMnFpyVrSoXwtpNPhYLJk1MiHHl4iq7IQ46X+Jqia8CTPgEHmlplnGY+x/hdU
jIXAStLNJZ9wCqYvztd0Hx1zF7+DCP677lgE35+Tsx6mLZq5xe+MaVH1I/tBsW4J
u1LxOYormFWJEG4+p8CykZzWo/Q6KdDk6j1MDolHCeVgzUWlNB0KDueIUTMmCIvE
R1jBb65FPH5o8w+siuxu3FznMF5qB5vC+zAkYyRqLnYXrTM9NWVQJhO7Iqj7FhSq
uoMFiVqOY8yVknrrU5jpCOhpQeLUfUmAHEuF8lAP9Fzp3zJu29omBgbrNidExtmc
X/cMW6jBnGL9Oz/3Va6zV3319mGQ8Cxqi5lnJhWkpexA4Mvn4Y8PHVIFwAV6rKK6
uVHRXAoXeTuyNmNqs6E5QsyeCgC11pcCagsoDXV17dg0oKRL/OAgVn0THrhZttQE
W/31eecgCpXW6qOuDvaL
=ThsT
-----END PGP SIGNATURE-----

--2B/JsCI69OhZNC5r--

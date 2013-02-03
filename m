Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369Ab3BCPSJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 10:18:09 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34888 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753873Ab3BCPSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 10:18:06 -0500
Message-ID: <1359904668.1822.3.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 058/128] ARM: 7628/1: head.S: map one extra section for the
 ATAG/DTB area
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, akpm@linux-foundation.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Nicolas Pitre <nico@linaro.org>, Sascha Hauer <s.hauer@pengutronix.de>,
        Tomasz Figa <t.figa@samsung.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Date: Sun, 03 Feb 2013 16:17:48 +0100
In-Reply-To: <20130203144649.188471908@decadent.org.uk>
References: <20130203144649.188471908@decadent.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-FLi89OFVLG4s/Sz5KrKK"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-FLi89OFVLG4s/Sz5KrKK
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2013-02-03 at 15:47 +0100, Ben Hutchings wrote:
> 3.2-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Nicolas Pitre <nicolas.pitre@linaro.org>
>=20
> commit 6f16f4998f98e42e3f2dedf663cfb691ff0324af upstream.
>=20
> We currently use a temporary 1MB section aligned to a 1MB boundary for
> mapping the provided device tree until the final page table is created.
> However, if the device tree happens to cross that 1MB boundary, the end
> of it remains unmapped and the kernel crashes when it attempts to access
> it.  Given no restriction on the location of that DTB, it could end up
> with only a few bytes mapped at the end of a section.
>=20
> Solve this issue by mapping two consecutive sections.
>=20
> Signed-off-by: Nicolas Pitre <nico@linaro.org>
> Tested-by: Sascha Hauer <s.hauer@pengutronix.de>
> Tested-by: Tomasz Figa <t.figa@samsung.com>
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> [bwh: Backported to 3.2:
>  - Adjust context
>  - The mapping is not conditional; drop the 'ne' suffixes]
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>

I haven't been able to test this and would really appreciate an expert
review.

Ben.

> ---
>  arch/arm/kernel/head.S |    3 +++
>  1 file changed, 3 insertions(+)
>=20
> --- a/arch/arm/kernel/head.S
> +++ b/arch/arm/kernel/head.S
> @@ -221,6 +221,7 @@ __create_page_tables:
>  	/*
>  	 * Then map boot params address in r2 or
>  	 * the first 1MB of ram if boot params address is not specified.
> +	 * We map 2 sections in case the ATAGs/DTB crosses a section boundary.
>  	 */
>  	mov	r0, r2, lsr #SECTION_SHIFT
>  	movs	r0, r0, lsl #SECTION_SHIFT
> @@ -229,6 +230,8 @@ __create_page_tables:
>  	add	r3, r3, #PAGE_OFFSET
>  	add	r3, r4, r3, lsr #(SECTION_SHIFT - PMD_ORDER)
>  	orr	r6, r7, r0
> +	str	r6, [r3], #1 << PMD_ORDER
> +	add	r6, r6, #1 << SECTION_SHIFT
>  	str	r6, [r3]
> =20
>  #ifdef CONFIG_DEBUG_LL
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--=20
Ben Hutchings
Everything should be made as simple as possible, but not simpler.
                                                           - Albert Einstei=
n

--=-FLi89OFVLG4s/Sz5KrKK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUQ5/nOe/yOyVhhEJAQoNoxAAsrM3n6f2Fe3o17Wa8tDZCu1Se3XCoqJZ
g/j32CgtDmhnncuwsICNhLrPcG6SiS+TfIAtplMYPuyZW8Vh/Cr13VwrRfVoQU9L
8NHG8bEkMUIqGn2TAJ5L1u0A88I1T6kh/OabGY6CPmXo2G2w6okPfmom5tYHmYF3
UaVodWGwnjhqxDVZJO2xV+U5Za5yCtOfSQzyLvumYAQfuoAie/D+60DL3uWJgk0H
Nw05N4f9DVmiYyTHhW/Ek6FUwvCJ/LGAwJlBlo7zHJXC1DxODDyGR5lJmpvmMcD0
EJDwv0K9EIt7FZMn7/+hXHL4o71JGcOAoDESGSSMtiR1xYElTWnxXOqI48wqiOlp
mOhxfwp5NcTwGaShVLMczKwPAXrkGSfN6QqYIWUJde2IoQen7vDzo9YavOMwV+6R
UGiu2nvNO+q8igRxmQlQQvmFajZRPtWMz/O9Ap/ovCbKyrURrhED8TjmXGFFjykP
2Ym9hhYo2+Zt5EdZFoF3P96JBtT0wU/PwepWxZ+kuRCQRtQ7/ASdCKZ/SP4Ekj5D
fdN3VYcs0OQw6iudgxyA3QNjH6lCYuFpc5TKQGaZ5eK0s/rUubyLJQb78KqS5Fw8
aXFNE+XesMuMHaUNFkhrZXqkzx9b1KYQDeNBBRiv5JJANnQ0Hvj6G3e4QVgYsgQL
wq7iEBmjdJM=
=kSVW
-----END PGP SIGNATURE-----

--=-FLi89OFVLG4s/Sz5KrKK--

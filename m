Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932139AbbAZWek (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 17:34:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35597 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756595AbbAZWei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 17:34:38 -0500
Message-ID: <54C6C0FA.10401@suse.de>
Date: Mon, 26 Jan 2015 23:34:34 +0100
From: =?windows-1252?Q?Andreas_F=E4rber?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: =?windows-1252?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>
CC: Rob Herring <robherring2@gmail.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, Sebastian Reichel <sre@debian.org>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: /proc/cpuinfo: DT: Add support for Revision
References: <1403110464-29646-1-git-send-email-pali.rohar@gmail.com> <201412041857.49341@pali> <CAL_JsqJ9i0jwaL1cyeomQG=bhhcnEgdGWYOqkcwidyk5xOUukg@mail.gmail.com> <201501262009.45854@pali>
In-Reply-To: <201501262009.45854@pali>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="b1JcUTDHH27ON450TX3GnjGjCHX8wS2i9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--b1JcUTDHH27ON450TX3GnjGjCHX8wS2i9
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Am 26.01.2015 um 20:09 schrieb Pali Roh=E1r:
> diff --git a/arch/arm/kernel/devtree.c b/arch/arm/kernel/devtree.c
> index 11c54de..9946c1b 100644
> --- a/arch/arm/kernel/devtree.c
> +++ b/arch/arm/kernel/devtree.c
[...]
> @@ -204,6 +206,8 @@ static const void * __init arch_get_next_mach(const=
 char *const **match)
>  const struct machine_desc * __init setup_machine_fdt(unsigned int dt_p=
hys)
>  {
>  	const struct machine_desc *mdesc, *mdesc_best =3D NULL;
> +	unsigned long dt_root;
> +	const u32 *prop;
> =20
>  #ifdef CONFIG_ARCH_MULTIPLATFORM
>  	DT_MACHINE_START(GENERIC_DT, "Generic DT based system")
> @@ -215,17 +219,16 @@ const struct machine_desc * __init setup_machine_=
fdt(unsigned int dt_phys)
>  	if (!dt_phys || !early_init_dt_verify(phys_to_virt(dt_phys)))
>  		return NULL;
> =20
> +	dt_root =3D of_get_flat_dt_root();
>  	mdesc =3D of_flat_dt_match_machine(mdesc_best, arch_get_next_mach);
> =20
>  	if (!mdesc) {
>  		const char *prop;

Probably the use of two differently typed variables of name "prop" in
this function is not intentional?

Regards,
Andreas

>  		int size;
> -		unsigned long dt_root;
> =20
>  		early_print("\nError: unrecognized/unsupported "
>  			    "device tree compatible list:\n[ ");
> =20
> -		dt_root =3D of_get_flat_dt_root();
>  		prop =3D of_get_flat_dt_prop(dt_root, "compatible", &size);
>  		while (size > 0) {
>  			early_print("'%s' ", prop);
> @@ -246,5 +249,10 @@ const struct machine_desc * __init setup_machine_f=
dt(unsigned int dt_phys)
>  	/* Change machine number to match the mdesc we're using */
>  	__machine_arch_type =3D mdesc->nr;
> =20
> +	/* Set system revision from DT */
> +	prop =3D of_get_flat_dt_prop(dt_root, "revision", NULL);
> +	if (prop)
> +		system_rev =3D fdt32_to_cpu(*prop);
> +
>  	return mdesc;
>  }
[snip]

--=20
SUSE Linux GmbH, Maxfeldstr. 5, 90409 N=FCrnberg, Germany
GF: Felix Imend=F6rffer, Jane Smithard, Jennifer Guild, Dilip Upmanyu,
Graham Norton; HRB 21284 (AG N=FCrnberg)


--b1JcUTDHH27ON450TX3GnjGjCHX8wS2i9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUxsD6AAoJEPou0S0+fgE/Yz0QAJHUjj0UUU2ipqJTVpJi/34I
Vt5ZdyvEZeblcM1DZgN0tPC4hEYw8aFOAhO171ZJveikaBaMj1v1v9DeIzoNE1Jr
A8xpG2qssU7az5C/jSU8xntNahbwG9P4x6bP0OpBMeradbooUhlxOS7DhvXiRhAj
2wFjt13XEWNg8IPba6NteyPukmBRmYqeGF+PRi1W4EidCoCQsjyS2UqKi8WxDoJx
panTFoB/ZhegHIZrcTPSG2cbyUS4GUfEF/Xq5Sd0arRDn+tfI7fTVT3wHWgbsKYu
b7EJK/luvvATKotoH1OtwmFAfx19DqDMjQD5aZWnH+EizFc9BOfeax9iAScdGb0t
D4ZlBGsTgIUv2z1fz6hZfvGIi8kNEcb0oS4zjcghyvA9pLACGoSAaHmfw0u7oIyU
xxPQP231k4MjuykAmFc1p4KhxSGMMmhwTsRguSI9AzhXPLyKJdFbjNXUcrPa6FSf
GVAUqnBRvYkq1Iwf4nux7Uk9mjThw8a4jJgb+R2xbtE3pAhahvSRhnwvKjPZ5Kji
lUKijDFZXyQUSYFANNMgJy8cuBOVk0/GvYk7+dHpxbffrJ3SuAjgp4lBhYt8e3zG
0zf+Okm6n+z35Kz9NoXDfAQDW8EmdyZhe+14IVL6yjsogLTYoWYHK7ME3VktMkUu
E76xZXGifwOgIVHPsJTN
=cweB
-----END PGP SIGNATURE-----

--b1JcUTDHH27ON450TX3GnjGjCHX8wS2i9--

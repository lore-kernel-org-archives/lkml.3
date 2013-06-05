Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415Ab3FEOxI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 10:53:08 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:36130 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690Ab3FEOxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 10:53:07 -0400
Message-ID: <51AF50CE.5050607@monstr.eu>
Date: Wed, 05 Jun 2013 16:53:02 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Michal Simek <michal.simek@xilinx.com>
CC: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Eric Paris <eparis@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] audit: Fix decimal constant description
References: <f0df7e546368dbf705bd302cfe7f834476d00e3e.1369288979.git.michal.simek@xilinx.com>
In-Reply-To: <f0df7e546368dbf705bd302cfe7f834476d00e3e.1369288979.git.michal.simek@xilinx.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2WBJMNHFHLQEIFIABEDQR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2WBJMNHFHLQEIFIABEDQR
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi guys,

any comment on this?

Geert: I fixes one warning reported in your regression log.

Thanks,
Michal

On 05/23/2013 08:03 AM, Michal Simek wrote:
> Use proper decimal type for comparison with u32.
>=20
> Compilation warning was introduced by:
> "audit: Make testing for a valid loginuid explicit."
> (sha1: 780a7654cee8d61819512385e778e4827db4bfbc)
>=20
> Warning:
> kernel/auditfilter.c: In function 'audit_data_to_entry':
> kernel/auditfilter.c:426:3: warning: this decimal constant
> is unsigned only in ISO C90 [enabled by default]
>    if ((f->type =3D=3D AUDIT_LOGINUID) && (f->val =3D=3D 4294967295)) {=

>=20
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> CC: Al Viro <viro@zeniv.linux.org.uk>
> CC: Eric Paris <eparis@redhat.com>
> ---
>  kernel/auditfilter.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
> index 83a2970..cfa1f73 100644
> --- a/kernel/auditfilter.c
> +++ b/kernel/auditfilter.c
> @@ -423,7 +423,7 @@ static struct audit_entry *audit_data_to_entry(stru=
ct audit_rule_data *data,
>  		f->lsm_rule =3D NULL;
>=20
>  		/* Support legacy tests for a valid loginuid */
> -		if ((f->type =3D=3D AUDIT_LOGINUID) && (f->val =3D=3D 4294967295)) {=

> +		if ((f->type =3D=3D AUDIT_LOGINUID) && (f->val =3D=3D ~0U)) {
>  			f->type =3D AUDIT_LOGINUID_SET;
>  			f->val =3D 0;
>  		}
> --
> 1.8.2.3
>=20


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



------enig2WBJMNHFHLQEIFIABEDQR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlGvUM4ACgkQykllyylKDCEqAgCeNqEStC7A+hw+nx748aOMCrKD
j7EAoINiMtZR+2EPJ/bX5MQKBiGFuUGp
=dy8k
-----END PGP SIGNATURE-----

------enig2WBJMNHFHLQEIFIABEDQR--

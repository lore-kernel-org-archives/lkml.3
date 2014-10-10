Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751310AbaJJBOs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 21:14:48 -0400
Received: from ozlabs.org ([103.22.144.67]:39260 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979AbaJJBOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 21:14:44 -0400
Date: Fri, 10 Oct 2014 12:14:35 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Zhang Rui <rui.zhang@intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the thermal tree
Message-ID: <20141010121435.1a614c2b@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/9UVXgtOhySKI8rGiGejYV9E"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/9UVXgtOhySKI8rGiGejYV9E
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Zhang,

After merging the thermal tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

In file included from /scratch/sfr/next/init/main.c:27:0:
/scratch/sfr/next/include/linux/acpi.h: In function 'acpi_create_platform_d=
evice':
/scratch/sfr/next/include/linux/acpi.h:528:12: error: parameter name omitted
     struct acpi_device *)
            ^
In file included from /scratch/sfr/next/drivers/i2c/i2c-core.c:54:0:
/scratch/sfr/next/include/linux/acpi.h: In function 'acpi_create_platform_d=
evice':
/scratch/sfr/next/include/linux/acpi.h:528:12: error: parameter name omitted
     struct acpi_device *)
            ^

And so on ...

Caused by commit 55fe2ff57c7e ("ACPI: make
acpi_create_platform_device() an external API").  This build does not
have CONFIG_ACPI set.  This has come along a bit late. :-(

I have used the thermal tree from next-20141009 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/9UVXgtOhySKI8rGiGejYV9E
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUNzMAAAoJEMDTa8Ir7ZwVuXkP/jw0w8kAhVTDsjqzT/nuAsDO
xKPyjlhLdvZlmzH8tcAxwQR+2aBEYkUtkxRhI7DtKgp06N4sHT+p4m3G9gzd2Ez1
xVM2rga22pnEFbsV/0AOjxKnzP8Q+cyT++AydPqiakF38PhbXijyFmpeL/JmtkdR
3kNGs8cwtQwacC0MLybC+FFR91BWDrU1pfOIACAO10pK5iOq4ClNosKEgY6tyC6S
Eq9NiQSktS03AYsq09tfoYQ038c4wfiRptKwyLJ59Dsv0XoY/qyzHG8W69V4zx1k
7uu93n5FhKfeTiOdfEipmmoRsObudUrn2vdT6/pjCpPj0XL6+rJRWMIql3PfYxSV
tHJIzMvETnHg0th3d2oXbtlEMAl7dEPv5GKfYXYZv2Z+X5dHC5ByNcOOrxDkISl1
mqpFWzrXjiJvY7I239jxvtLJSXZR3uWC7x+rVpvq08RM1MD2MkL36xINuUSeGPxO
P5VNGflQUHWkW0hQkx8WYYPXiKSxyi3IbWHzOIcVaxS9IKn7FNmvtuaMVupebVpg
ulu2jFvMfacOkXpBp2l88gY8MaviqB60m8jcZjkvw8AcDMmayiWHozECPNrUiogo
7BHOOst3MscKOGX6wVu/t4Z48Ejw6Arq96E5mw/JVkTye2OeBXhvAzoDmb2fHKke
gnK6gP0jWQex3nzSc192
=+S1n
-----END PGP SIGNATURE-----

--Sig_/9UVXgtOhySKI8rGiGejYV9E--

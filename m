Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218Ab3KFHqm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 02:46:42 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:51792 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab3KFHql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 02:46:41 -0500
Message-ID: <5279F3DD.9040605@monstr.eu>
Date: Wed, 06 Nov 2013 08:46:37 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
CC: Michal Simek <michal.simek@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 6/6] arm: zynq: headsmp: Move .glbl out of actual code
References: <1383235819-2552-1-git-send-email-soren.brinkmann@xilinx.com> <1383235819-2552-7-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1383235819-2552-7-git-send-email-soren.brinkmann@xilinx.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="3ioq0QLfWL13kKsQ34UTU3Oc75vaOIsl6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3ioq0QLfWL13kKsQ34UTU3Oc75vaOIsl6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 10/31/2013 05:10 PM, Soren Brinkmann wrote:
> Move the .glbl lines exporting symbols to the top of the file and out o=
f
> the actual code, in order to make the code more readable.
>=20
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
>  arch/arm/mach-zynq/headsmp.S | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/arm/mach-zynq/headsmp.S b/arch/arm/mach-zynq/headsmp.=
S
> index 57a32869f0aa..12d1b40c7d78 100644
> --- a/arch/arm/mach-zynq/headsmp.S
> +++ b/arch/arm/mach-zynq/headsmp.S
> @@ -9,14 +9,15 @@
>  #include <linux/linkage.h>
>  #include <linux/init.h>
> =20
> +.globl zynq_secondary_trampoline_jump
> +.globl zynq_secondary_trampoline_end
> +
>  ENTRY(zynq_secondary_trampoline)
>  	ldr	r0, [pc]
>  	bx	r0
> -.globl zynq_secondary_trampoline_jump
>  zynq_secondary_trampoline_jump:
>  	/* Space for jumping address */
>  	.word	/* cpu 1 */
> -.globl zynq_secondary_trampoline_end
>  zynq_secondary_trampoline_end:
>  ENDPROC(zynq_secondary_trampoline)
> =20

I don't want this one.
I have applied 1-5 to zynq/cleanup branch.

Thanks,
Michal



--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--3ioq0QLfWL13kKsQ34UTU3Oc75vaOIsl6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlJ5890ACgkQykllyylKDCERLQCZAZZ7sYawr6kdSqzK+B+uMY7f
tYUAoJgMD027ql8l14X20G/tIq9EIzU3
=ZxmU
-----END PGP SIGNATURE-----

--3ioq0QLfWL13kKsQ34UTU3Oc75vaOIsl6--

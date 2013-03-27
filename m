Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323Ab3C0Knx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 06:43:53 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:52939 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754388Ab3C0Knw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 06:43:52 -0400
Date: Wed, 27 Mar 2013 21:43:47 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Prabhakar lad <prabhakar.csengg@gmail.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Sekhar Nori <nsekhar@ti.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: davinci: use is IS_ENABLED macro
Message-Id: <20130327214347.f2a573510416b86223c58be1@canb.auug.org.au>
In-Reply-To: <1364210495-7938-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1364210495-7938-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__27_Mar_2013_21_43_47_+1100_4ZKRJpY6a8yszMEC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__27_Mar_2013_21_43_47_+1100_4ZKRJpY6a8yszMEC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, 25 Mar 2013 16:51:35 +0530 Prabhakar lad <prabhakar.csengg@gmail.co=
m> wrote:
>
> --- a/arch/arm/mach-davinci/board-da830-evm.c
> +++ b/arch/arm/mach-davinci/board-da830-evm.c
> @@ -298,7 +298,7 @@ static const short da830_evm_emif25_pins[] =3D {
>  	-1
>  };
> =20
> -#if defined(CONFIG_MMC_DAVINCI) || defined(CONFIG_MMC_DAVINCI_MODULE)
> +#if IS_ENABLED(CONFIG_MMC_DAVINCI)
>  #define HAS_MMC	1
>  #else
>  #define HAS_MMC	0

Why not

#define HAS_MMC		IS_ENABLED(CONFIG_MMC_DAVINCI)

and similarly in the rest?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__27_Mar_2013_21_43_47_+1100_4ZKRJpY6a8yszMEC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRUs1jAAoJEECxmPOUX5FEZw4P/3q6+KZ8fRKOU5FPF+1xJMJC
rvG4sZ2GxnmOevJPjokcy6UP2kmhdEy1lAy7UnsVvL3LzXOgQ/rb9v0JLqPWHSiD
ZioDQ2gUlHld8Vh092YmNjMZPnKlrM86/bO6DR2JgExiE8Iazrefgs+JzkdENvf4
C9g1Qqu4Doy3S3wxZ5fDjdP7FuFxaxIlEC2QSgXfeTmsDO30BZB+RXiMEgURt8Kh
L6FCpN7GimtdAnxy5786d6aTrYFDS0/UGt20w9iES5/7C9uujAwmnInKOYDO++aP
qvhEAB+XMhjZu4M6AYVd7f7otWw2BgMbrw6/eIUe+y2k6RHcakzCrqSaNDsXhEF5
dLK1YVtk9VautwE/NTVLeqHlWjqbXfDubWgpz7I87iRyPsWdrVAIML7UJu6vTFrj
Jdk9dkR7iptAHUoB/+UMOUKl0sp67o/lArIQXH93RvLVEGZeYzOqTS90RpPdIQ/U
NiZeqhct50Fxrs6TVtTs7deeAZXUE3hTtCxfllNKvrq1KVcilg4ahmuj8nPgmdgo
GTt913otRRNKx8gNxTCeAORnkOuQKnZsT2JqrpFih0GLGPxUweeDinQ0F/ufuEhI
cJFIMNg3NeGbSGl5+l0M2ePhOsbrzoEBOb6TH0vuKF9YKBBHdyirNAHdWWdqz/A6
XJcIdBEl04/fq7au97TU
=pJU/
-----END PGP SIGNATURE-----

--Signature=_Wed__27_Mar_2013_21_43_47_+1100_4ZKRJpY6a8yszMEC--

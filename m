Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932634AbaKRVPK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 16:15:10 -0500
Received: from ozlabs.org ([103.22.144.67]:52198 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932269AbaKRVPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 16:15:05 -0500
Date: Wed, 19 Nov 2014 08:14:38 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>, Rob Clark <robdclark@gmail.com>
Subject: Re: [PATCH] ARM: vfp: Silence mvfr0 unused variable warning
Message-ID: <20141119081438.3df66238@canb.auug.org.au>
In-Reply-To: <1416344191-20484-1-git-send-email-sboyd@codeaurora.org>
References: <1416344191-20484-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/+AhLzhf671Y_Q0gm7i1sQU1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/+AhLzhf671Y_Q0gm7i1sQU1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Stephen,

On Tue, 18 Nov 2014 12:56:31 -0800 Stephen Boyd <sboyd@codeaurora.org> wrot=
e:
>
> Stephen Rothwell reports that commit 3f4c9f8f0a20 ("ARM: 8197/1:
> vfp: Fix VFPv3 hwcap detection on CPUID based cpus") introduced an
> unused variable warning.
>=20
> arch/arm/vfp/vfpmodule.c: In function 'vfp_init':
> arch/arm/vfp/vfpmodule.c:725:6: warning: unused variable 'mvfr0'
> [-Wunused-variable]
>   u32 mvfr0;
>=20
> Silence this warning by using IS_ENABLED instead of ifdefs.
>=20
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

Looks good (though I haven't tested it).  One small nit below:

> +		if (IS_ENABLED(CONFIG_VFPv3)) {
> +			mvfr0 =3D fmrx(MVFR0);

Now that you have a block here, you could move the declaration of mvfr0
into this block, right?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/+AhLzhf671Y_Q0gm7i1sQU1
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUa7bWAAoJEMDTa8Ir7ZwVFQsP/3PxV7lH1y0JrgYbw+7ru7gN
mgsa+TQp7pWfmY/kp3WQtv19RcW5Sxe7U44gKRCwUghGie6/xS1lb2VY/6GfkIKQ
7M2E+26LQeWZc2z8LA7B/VZFgjhoF7vkxDdqS6tQEHGOjsyrfKrPppQirlq9Dt4M
ympEW/a9lC4+72G7axOHtaZQQUus0L7wgovo2MibgnD3cRAZDdku52gryJP3x5In
9g2110bdNTQShK4Dvvc0nVbGqwElZr8qX9K55F38gm3xGrQ6fVO3et81qAsb3Nso
LOy1I2sQ2+7G1YfP8laczfwjuyL4rtO9aZ3HVHOMy9HvabRowp8p74qOX5iAEvYO
4iR4A6R0WNjdtam3AjvzHNWFmn4U5RA3t6s+GK298/APCZHG/k6iN9KmWF/4cOWy
bsmEPHTeBBdQ0taclu+jKCP9jaAgi+VtWPlHySsiFE9feyqV0LaBezTKxded52Og
VPV2CZWhT81Kb/3IsOjj1hbiQJufqllidMeyN6hpRv6+3ds7uyZiPGCu5DlH+C9j
jyaQMRchkbiqAwjYXEzWwuMnQnBZDGPjOdWU8CohumpeHZDPm+e3eroQAmF8P/W1
RLlaFPawNZomwhTK5AFysNLpMItjXhuiDbE7+yXV5PFBDeDCzICF87uaiLFbq2Z+
mtbLHTnwkqLIYapFLWPZ
=WKiQ
-----END PGP SIGNATURE-----

--Sig_/+AhLzhf671Y_Q0gm7i1sQU1--

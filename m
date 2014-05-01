Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751706AbaEACJl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 22:09:41 -0400
Received: from ozlabs.org ([103.22.144.67]:40978 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225AbaEACJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 22:09:39 -0400
Date: Thu, 1 May 2014 12:09:32 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Ralf Baechle <ralf@linux-mips.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Stratos Karafotis <stratosk@semaphore.gr>
Subject: linux-next: manual merge of the pm tree with the mips tree
Message-Id: <20140501120932.ff26772f983a436b4453c915@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__1_May_2014_12_09_32_+1000_d7zY1SkU6vg6nEQn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__1_May_2014_12_09_32_+1000_d7zY1SkU6vg6nEQn
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rafael,

Today's linux-next merge of the pm tree got a conflict in
arch/mips/loongson/lemote-2f/clock.c between commit a68ce6507a45
("MIPS/loongson2_cpufreq: Fix CPU clock rate setting") from the mips tree
and commit 4966ee4037fe ("mips: lemote 2f: Use cpufreq_for_each_entry
macro for iteration") from the pm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/mips/loongson/lemote-2f/clock.c
index 67dd94ef28e6,1eed38e28b1e..000000000000
--- a/arch/mips/loongson/lemote-2f/clock.c
+++ b/arch/mips/loongson/lemote-2f/clock.c
@@@ -91,10 -91,9 +91,10 @@@ EXPORT_SYMBOL(clk_put)
 =20
  int clk_set_rate(struct clk *clk, unsigned long rate)
  {
 +	unsigned int rate_khz =3D rate / 1000;
+ 	struct cpufreq_frequency_table *pos;
  	int ret =3D 0;
  	int regval;
- 	int i;
 =20
  	if (likely(clk->ops && clk->ops->set_rate)) {
  		unsigned long flags;
@@@ -107,15 -106,10 +107,10 @@@
  	if (unlikely(clk->flags & CLK_RATE_PROPAGATES))
  		propagate_rate(clk);
 =20
- 	for (i =3D 0; loongson2_clockmod_table[i].frequency !=3D CPUFREQ_TABLE_E=
ND;
- 	     i++) {
- 		if (loongson2_clockmod_table[i].frequency =3D=3D
- 		    CPUFREQ_ENTRY_INVALID)
- 			continue;
- 		if (rate_khz =3D=3D loongson2_clockmod_table[i].frequency)
+ 	cpufreq_for_each_valid_entry(pos, loongson2_clockmod_table)
 -		if (rate =3D=3D pos->frequency)
++		if (rate_khz =3D=3D pos->frequency)
  			break;
- 	}
- 	if (rate_khz !=3D loongson2_clockmod_table[i].frequency)
 -	if (rate !=3D pos->frequency)
++	if (rate_khz !=3D pos->frequency)
  		return -ENOTSUPP;
 =20
  	clk->rate =3D rate;

--Signature=_Thu__1_May_2014_12_09_32_+1000_d7zY1SkU6vg6nEQn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTYazgAAoJEMDTa8Ir7ZwVrJwP/RFrn/rh2YO1BSHg3kHzp5Ys
+fEFSQA1lAjkbPsSDBTrTPGSF8Ap02OZa9apU+0uK5ojzkDKbNVygZgjE9xKcSb4
VHzKuhyGO5DbtqJ9sWjCjAPZR5yIsteunkAy8r6YaITY3HBTKJEFO7LxtalEVrdZ
koTVQ5JH1oZqi+8L5ZWiitNfbMhrsk3VWgz3j+OqO2rFeTr459ghF/vXBEtb7F+C
cPd9W9ueqVNJooEgBnwEXHBH40mN2CLk+pbFhAEjthlkXyH2u0S1Q+8aW0xF5kLT
tE5TnuoLGZk1h4yL4kuOMfwlotHaIcrC/ydTLa4PcmU5q8QQPgczPvXdRtKEwUxE
0JC1OnB1jgs8KybpdyqLhdBGAHm0shRjU2imn1urHQB+2oqABsng6z8V4jLVy4FX
X89+ICxnlZy5ts9jbsI4E4NE8OBGOD4DIHoaAxBC49XEw0tBZNgZPgudCEJypGrr
u4AQ3Z4INhgpEcV0F0sK3UVpW/HigdBAhuFOXTnBrNbUS1riesxCgBKEaQrXbtr0
F/nsNtwJ6CGuBL2tkB0FM8F/2TP/7k1FBqHhEV96JSI2sS/lX4UGg6UXXq2Gxxkc
uPTK3Yd+8wncyTeAPC/ZX3PK+6AcKJbcyM8og+XOjuH3w2xaWSrG5GfNgSBdvY1J
FvZQKI75k7/wDu9j70Nl
=FHF+
-----END PGP SIGNATURE-----

--Signature=_Thu__1_May_2014_12_09_32_+1000_d7zY1SkU6vg6nEQn--

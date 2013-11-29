Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894Ab3K2Vnb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 16:43:31 -0500
Received: from mail-bk0-f42.google.com ([209.85.214.42]:63684 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525Ab3K2Vn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 16:43:28 -0500
Date: Fri, 29 Nov 2013 22:43:15 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Michal Nazarewicz <mpn@google.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, Mark Brown <broonie@kernel.org>,
        linux-spi@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] spi: tegra: avoid unsigned->signed->unsigned promotion
Message-ID: <20131129214313.GA18036@mithrandir>
References: <1385745164-10534-1-git-send-email-mpn@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RnlQjJ0d97Da+TV1"
Content-Disposition: inline
In-Reply-To: <1385745164-10534-1-git-send-email-mpn@google.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 29, 2013 at 06:12:44PM +0100, Michal Nazarewicz wrote:
> From: Michal Nazarewicz <mina86@mina86.com>
>=20
> u8 type, which is unsigned, is promoted to int, which is singned, when
> doing a binary shift.  Then, on 64-bit machines, it is further promoted
> to unsigned long which may lead to more significant half of the value
> to be all ones.  To avoid this, explicitly promote to an unsigned type.

So this would only become an problem on 64-bit Tegra SoCs, right? I
suspect that there are quite a few places where something similar is
done and which suffer from the same issue.

But I don't think there's a real issue here. Even on 64-bit platforms,
writel() will only write 32-bit registers, and therefore discard the
upper 32 bits.

I think in general perhaps a more proper fix would be to use only u32
instead of unsigned long for these cases, since then the problem goes
away. u32 is also the type of the value used by writel() so it makes
perfect sense to use it.

Thierry

--RnlQjJ0d97Da+TV1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSmQpxAAoJEN0jrNd/PrOhKX8QAJVak8r+fcCS6Wd160AiUjbS
2MVrJK5qDdzfTq6yMQ/x1yrLnJbM/deaY9+0wYiyjruM7yK7+P2e6b6nTa65r1HP
wbd3nwlZM/xCw4XZvhCMspY6EtHyKOO+Fb1nd+cUWeHYFnJCYDRhaPIX0YDar5a+
sp3PhgPnl4C77mTkbzlcJlR24thedBUjMe4sQnoBemhjTHWGCSxE5xjA0CjtJ5/V
Tm7mJBQXxgzQxKC5NH2CyA4rL1PX36eYXUXn8MxSOKTkj1wWjisj71f7r4OZTdrd
qNLy93qNFUWarsjDWoEpqjvsW4EHpZlQzUHMzEZtcS62X6lVyrHfI3q1htTRNUio
i8JlL8+OrzutmL/z2zID98dPBR/JGNXvSAEnB6wXeEsUU3d+3u96dkNnMWwLKwMO
ZwbE3mh1Y93FRJQEsNQ8U+QLiEd30uuuxrTsTn6kD097BhPMIHYbDkrvJpq1HG1L
AarGdHIYFZNUT9hdw7hGYjx3HoH+CIIMF2jDxrxu7TfDCgEvDQeU44yA6dReLso+
BzMncT9dIgvnnYpMO4T8//LvlSGfiyk4oPoyId28KhAAzqGVBryu+pqvZmP9QDR2
vz6BSpqFj6tQo16eY0S7C8kV3jaI62XVLb+6O4TkE6ho6gQ5doTga5vO905kl8vT
PT40bhsowybR8Lskazgg
=6AcE
-----END PGP SIGNATURE-----

--RnlQjJ0d97Da+TV1--

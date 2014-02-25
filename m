Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898AbaBYCfq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 21:35:46 -0500
Received: from ozlabs.org ([203.10.76.45]:44778 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514AbaBYCfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 21:35:45 -0500
Date: Tue, 25 Feb 2014 13:35:37 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the wireless-next tree
Message-Id: <20140225133537.55ce6935e55faa6aeae53d89@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__25_Feb_2014_13_35_37_+1100_jqHYESQij09Rf=Hr"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__25_Feb_2014_13_35_37_+1100_jqHYESQij09Rf=Hr
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

After merging the wireless-next tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/staging/rtl8821ae/rc.c:289:2: error: unknown field 'module' specifi=
ed in initializer
  .module =3D NULL,
  ^

Caused by commit 161d78555435 ("Revert "Staging: rtl8812ae: remove
modules field of rate_control_ops"").

The commit "Staging: rtl8812ae: remove modules field of rate_control_ops"
was needed in the wireless-next tree - I said so at the time of reporting
the original breakage:=20

> Actually, your tree is based on -rc2, so you need this patch already (it
> should have bee included in the merge commit 841577c3d33b ("Merge branch
> 'for-john' of
> git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next").

And now that part of the wireless-next tree has migrated to the net-next tr=
ee.

I have no idea why you thought you should revert the fix.

I have used the wireless tree from next-20140224 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__25_Feb_2014_13_35_37_+1100_jqHYESQij09Rf=Hr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTDAF9AAoJEMDTa8Ir7ZwVu8kP+wQ+Luwu7rNKruZo9XfY06CP
OP2Z0Ss0W85PNZBHDEQJLr0y4XmVrKomgyOz0ogrKFWjGIYqMm8j9TzcUkZWg51h
57diB9mcX/Zod7G8hphaJGQescxKJLQIAMSji94REJeAsYedlctc9Uv7Y3RZo6oh
arHI7FzFymbsgndJq8fGBrqjBmvXZXdPWC20nfY7QwtFTWlI/L2BKG+L7diajB1T
gEQbwjgX2WGNYEAwcFKEpQOHlOchSJuDVEePyllyAXHnWsLE1Pq/aLmos4Jba4XA
b5EQHwYkh/mQuvx1JVNKIrTOKLXzAEyPSOo9gair2EhOaN355TJ6a+d6vJpq0bZZ
rmSP2j+MWE9YkXxZ5cV0sCbQbcjnJiXO7kcssJ/z312IW2Zpm+X31hH/IbT0Q8GP
T3V4NDkvwF49KGMcEjTza+thjN124N4dLQUBrHTWWoxxKCa796AcltUek0qHIn6Y
qb5Ym5NaQhio+uCdPjoHcj8tbQ1tXAC+/eazDSR2fMnYJX3Ri2/4zIjCXnqpnNiG
3XUMvcyuRYyWsW5LWf1l3WHXbU/iSI/oynKBuTTKFL6ISFu98poCzkphFh97oC6X
uwg4NuG8x6l0+iILsdWcMLumvRNN9TE3G/Qe7g4J/1EWlKdrN+OZq1IGdxVH3+3F
wUfLNcZ140AnMxdv+qZ5
=8fK0
-----END PGP SIGNATURE-----

--Signature=_Tue__25_Feb_2014_13_35_37_+1100_jqHYESQij09Rf=Hr--

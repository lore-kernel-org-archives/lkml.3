Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274AbaIQLNd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 07:13:33 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48153 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754289AbaIQLNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 07:13:32 -0400
Message-ID: <1410952405.3040.98.camel@decadent.org.uk>
Subject: Re: [PATCH 3.13 120/187] ext4: fix ext4_discard_allocated_blocks()
 if we can't allocate the pa struct
From: Ben Hutchings <ben@decadent.org.uk>
To: Kamal Mostafa <kamal@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, "Theodore Ts'o" <tytso@mit.edu>
Date: Wed, 17 Sep 2014 12:13:25 +0100
In-Reply-To: <1410818997-9432-121-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
	 <1410818997-9432-121-git-send-email-kamal@canonical.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-NYUQ46cMGLZXpgVbPL7m"
X-Mailer: Evolution 3.12.5-1+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:cde6:1b3a:bf85:5ca0
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-NYUQ46cMGLZXpgVbPL7m
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2014-09-15 at 15:08 -0700, Kamal Mostafa wrote:
> 3.13.11.7 -stable review patch.  If anyone has any objections, please let=
 me know.
>=20
> ------------------
>=20
> From: Theodore Ts'o <tytso@mit.edu>
>=20
> commit 86f0afd463215fc3e58020493482faa4ac3a4d69 upstream.
>=20
> If there is a failure while allocating the preallocation structure, a
> number of blocks can end up getting marked in the in-memory buddy
> bitmap, and then not getting released.  This can result in the
> following corruption getting reported by the kernel:
>=20
> EXT4-fs error (device sda3): ext4_mb_generate_buddy:758: group 1126,
> 12793 clusters in bitmap, 12729 in gd
>=20
> In that case, we need to release the blocks using mb_free_blocks().
>=20
> Tested: fs smoke test; also demonstrated that with injected errors,
> 	the file system is no longer getting corrupted
>=20
> Google-Bug-Id: 16657874
>=20
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Signed-off-by: Kamal Mostafa <kamal@canonical.com>
[...]

You need to apply commit c99d1e6e83b0 ("ext4: fix BUG_ON in
mb_free_blocks()") along with this.

Ben.

--=20
Ben Hutchings
Beware of programmers who carry screwdrivers. - Leonard Brandwein

--=-NYUQ46cMGLZXpgVbPL7m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAVBls1ee/yOyVhhEJAQrk/g/+IPSmKartsm3ARk6fCrZ4SP3tGNSISMtr
5rLNoaHrBP+he6LsgjK6PnRulzpMTbuIYqMdyZELolZ3IG0NJ1ROvJNqoqTS6wAn
5MsnHEMcImvf3+lwabDNgyWEanybpLkOViClbdAQuHrypCmvoJ9SJTf/K26AFWkg
uj8oscpZotq1ObjhDLo0QOu/x/jkg17WTEvwPU4Fpev2C3ZduTYAMxZbvbUx92XZ
vZZ4urFIbMrt7TRbuSdSe3S0JuRA9t0SDAhtT23ePjag6Qu64urXPtFzBQE+HVh+
8JnpHOZ8g5QhMdKb2NPtOgeTvNpor4LL4opTwTsUftCXXDc1QXw8qS3nfiNJ6Jk/
0ssmxzOFF0kwdXXuDk2PFiSNF+b0lUA7cFVgOz2ykDX1JDpHkfbruoRHer72H4Bo
iWgyjdFp83iWlxYl2TtZhrEB6RBt6j8gkgX30ex0cS14vcJTxMGo4GlKT3UR3wg/
MW1BkHvXdYgGVn2raoLQSFtrhhffNsaTFHwD8b3Gd9Eq9gt7NS4PHg7SrUQmf9PQ
Aup8xcrFAlNj0Px57mKL+8SJJt/EgMgtJE/SkXhpmq6of7EA8UZi289YLtuimZE5
WkCeZ1VDTYoflIDoJTeNvMHotMMyVRyJEQ+YRTrJqo3mHeVmxNLnZ4yxx0NldXk6
ARDgfIf8gIs=
=IXDs
-----END PGP SIGNATURE-----

--=-NYUQ46cMGLZXpgVbPL7m--

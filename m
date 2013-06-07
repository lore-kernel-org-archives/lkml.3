Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037Ab3FGFn7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 01:43:59 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50214 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750789Ab3FGFn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 01:43:58 -0400
Message-ID: <1370583835.4021.86.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 131/184] ext4: make orphan functions be no-op in no-journal
From: Ben Hutchings <ben@decadent.org.uk>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Anatol Pomozov <anatol.pomozov@gmail.com>,
        Theodore Tso <tytso@mit.edu>
Date: Fri, 07 Jun 2013 06:43:55 +0100
In-Reply-To: <20130604172135.737485013@1wt.eu>
References: <20130604172135.737485013@1wt.eu>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-nVHhDMebpsTbQv7kK1+h"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-nVHhDMebpsTbQv7kK1+h
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-06-04 at 19:23 +0200, Willy Tarreau wrote:
> 2.6.32-longterm review patch.  If anyone has any objections, please let m=
e know.
>=20
> ------------------
>  mode
>=20
> From: Anatol Pomozov <anatol.pomozov@gmail.com>

commit c9b92530a723ac5ef8e352885a1862b18f31b2f5 upstream.

> Instead of checking whether the handle is valid, we check if journal
> is enabled. This avoids taking the s_orphan_lock mutex in all cases
> when there is no journal in use, including the error paths where
> ext4_orphan_del() is called with a handle set to NULL.
>=20
> Signed-off-by: Anatol Pomozov <anatol.pomozov@gmail.com>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Signed-off-by: Willy Tarreau <w@1wt.eu>
> ---
>  fs/ext4/namei.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>=20
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 828c9c9..230bef5 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -2001,7 +2001,7 @@ int ext4_orphan_add(handle_t *handle, struct inode =
*inode)
>  	struct ext4_iloc iloc;
>  	int err =3D 0, rc;
> =20
> -	if (!ext4_handle_valid(handle))
> +	if (!EXT4_SB(sb)->s_journal)
>  		return 0;
> =20
>  	mutex_lock(&EXT4_SB(sb)->s_orphan_lock);
> @@ -2082,8 +2082,7 @@ int ext4_orphan_del(handle_t *handle, struct inode =
*inode)
>  	struct ext4_iloc iloc;
>  	int err =3D 0;
> =20
> -	/* ext4_handle_valid() assumes a valid handle_t pointer */
> -	if (handle && !ext4_handle_valid(handle))
> +	if (!EXT4_SB(inode->i_sb)->s_journal)
>  		return 0;
> =20
>  	mutex_lock(&EXT4_SB(inode->i_sb)->s_orphan_lock);
> @@ -2102,7 +2101,7 @@ int ext4_orphan_del(handle_t *handle, struct inode =
*inode)
>  	 * transaction handle with which to update the orphan list on
>  	 * disk, but we still need to remove the inode from the linked
>  	 * list in memory. */
> -	if (sbi->s_journal && !handle)
> +	if (!handle)
>  		goto out;
> =20
>  	err =3D ext4_reserve_inode_write(handle, inode, &iloc);

--=20
Ben Hutchings
Theory and practice are closer in theory than in practice.
                                - John Levine, moderator of comp.compilers

--=-nVHhDMebpsTbQv7kK1+h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUbFzG+e/yOyVhhEJAQq75BAAnG33q8mUE8mvJCh6xw39GuIZz8R78wJe
bQazlvvkrjQVldtG+6sjTm1wP7XJXy+CykqhdEuI9RpaAbA5/EnOVvPLDPMFZmnP
NzgM/6rzQKfKH82KMv8fioJJNRPrHbTMM87e6hmH2b6INelnedl/qaoAYZqO5Kw5
EeaAC/AuPO9xi75ucDPnedIlkVH4Su63RJMP0SPljt4JnssGuEbaykJn2mfD5n40
mwvoC5cWue0o4DloPWSyHmYlOCDw3nbwF4TeaNx444f8O9xZl393S8EviRzedzQ7
qtpb4cmFedNy7XXh1DV9zSSbnXMed2fJputK3eNo0buJco9c92QUlILyfvH2gogu
ZmyHNTojGzcTb0m2EKEwIcvVoxteTbjQyLCF4qi70ZltZEhm9VboGiuihjCkvM7p
OgA1arIHRBORn/mOqD1k4XofVQSbzqcvssK96qBoqroSjgkdjtDzpdRnegDwcX50
B+Az9wiW+1WK0bu0Dt5YJNZHl6wnBCk7xqQZWx7EH7qAdpqo2wtBUhSy2Kyolpst
iRRGsw26JINDVD5oGe1NiLnsCrWn6ehb4vca5BZ2mEyQ9n+/Kt/LrEOrruIsE/E7
+JtPO+f9XD0DHhOo4GJzL1w5Uag5G6u4eBv6rW2uloAWBKkPZDubkYKjlowxnTom
3H/CYTwowlo=
=dzUW
-----END PGP SIGNATURE-----

--=-nVHhDMebpsTbQv7kK1+h--

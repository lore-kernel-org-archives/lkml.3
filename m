Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146Ab3FGFog (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 01:44:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50219 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751315Ab3FGFof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 01:44:35 -0400
Message-ID: <1370583872.4021.87.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 132/184] ext4: avoid hang when mounting non-journal
From: Ben Hutchings <ben@decadent.org.uk>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Theodore Tso <tytso@mit.edu>
Date: Fri, 07 Jun 2013 06:44:32 +0100
In-Reply-To: <20130604172135.779070691@1wt.eu>
References: <20130604172135.779070691@1wt.eu>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-OjEVAgA+pa+ngzQrNfsG"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-OjEVAgA+pa+ngzQrNfsG
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-06-04 at 19:23 +0200, Willy Tarreau wrote:
> 2.6.32-longterm review patch.  If anyone has any objections, please let m=
e know.
>=20
> ------------------
>  filesystems with orphan list
>=20
> From: Theodore Ts'o <tytso@mit.edu>

commit 0e9a9a1ad619e7e987815d20262d36a2f95717ca upstream.

> When trying to mount a file system which does not contain a journal,
> but which does have a orphan list containing an inode which needs to
> be truncated, the mount call with hang forever in
> ext4_orphan_cleanup() because ext4_orphan_del() will return
> immediately without removing the inode from the orphan list, leading
> to an uninterruptible loop in kernel code which will busy out one of
> the CPU's on the system.
>=20
> This can be trivially reproduced by trying to mount the file system
> found in tests/f_orphan_extents_inode/image.gz from the e2fsprogs
> source tree.  If a malicious user were to put this on a USB stick, and
> mount it on a Linux desktop which has automatic mounts enabled, this
> could be considered a potential denial of service attack.  (Not a big
> deal in practice, but professional paranoids worry about such things,
> and have even been known to allocate CVE numbers for such problems.)
>=20
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Willy Tarreau <w@1wt.eu>
> ---
>  fs/ext4/namei.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 230bef5..3a1af19 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -2082,7 +2082,8 @@ int ext4_orphan_del(handle_t *handle, struct inode =
*inode)
>  	struct ext4_iloc iloc;
>  	int err =3D 0;
> =20
> -	if (!EXT4_SB(inode->i_sb)->s_journal)
> +	if ((!EXT4_SB(inode->i_sb)->s_journal) &&
> +	    !(EXT4_SB(inode->i_sb)->s_mount_state & EXT4_ORPHAN_FS))
>  		return 0;
> =20
>  	mutex_lock(&EXT4_SB(inode->i_sb)->s_orphan_lock);

--=20
Ben Hutchings
Theory and practice are closer in theory than in practice.
                                - John Levine, moderator of comp.compilers

--=-OjEVAgA+pa+ngzQrNfsG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIUAwUAUbFzQOe/yOyVhhEJAQogSQ/yAq0eaVSucPbp64RtpTLlDOiW2RElw7eQ
TykhgBnO0hqfVos2/hGkRbO16Mwi8VshkCvcevAmC+lI9HWVeUqoErKp6kEduifV
u3JTqN/fCPUDtb/w8jsOLau3pDt2XzrZ80/n1wQqP/vr52VWb+LNS1ZQMMcKh7eS
R1p976pKBiJxrbQJH9xIlJqZw85IxugN2Ycum/mHVWse6bfzfW48q7Vn29tlohvh
s/Fp98NGvKh4wLoWzJGuWfBg8VNx4QYLiYvoergQbgM2xqGIWZ7EhqJjPaYTygDs
uIBcsBhsmk4eKmmF/C9vli0l3+uvegODMRh6R5Bkkz61yzD+DJeEBQyqZYrjlCSp
ziKwGgOVONeDcX0broTQAN65GjGKNxu0cV7jkciZPCZwNLyJBJNhDU8nfHZkN58G
rU7/I75Qz0oExxHTBzWiH21EbCkf3TTTiUdrovuHl0O5HcYZ0v6X66rUPZzQ9P5R
DiNggTJu/MiQuVrRQvjXma1FlRs6sLNlb378dj6E85P2KyJ54HoOh+VjOJexgmSv
DURVd7n8fWnOpDevLDhgs5Hgj5Eh4roFiBovEhBSOkmlV9fkfRJjdNGP0k7UMj48
OyfTShn2zNyYhW0pSE0ssEF3QVa27Q49QrXLFOiGBEgWENpEMAzMu+ZYskHCJ3yA
munKLracAw==
=Uh8x
-----END PGP SIGNATURE-----

--=-OjEVAgA+pa+ngzQrNfsG--

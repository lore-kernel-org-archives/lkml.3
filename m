Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362AbaFPN4H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 09:56:07 -0400
Received: from mo4-p05-ob.smtp.rzone.de ([81.169.146.183]:8948 "EHLO
	mo4-p05-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbaFPN4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 09:56:05 -0400
X-Greylist: delayed 359 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Jun 2014 09:56:03 EDT
X-RZG-AUTH: :IWkQb0WIdvqIIwNfJfyiKBgoQwjwJ7eL6yL6M6h2IziqwDGkR4xBppx51ChxczpID85bUDEXFKm95dvMav6s1e6U
X-RZG-CLASS-ID: mo05
Message-ID: <539EF5FD.5000307@samba.org>
Date: Mon, 16 Jun 2014 15:49:49 +0200
From: "Stefan (metze) Metzmacher" <metze@samba.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: =?UTF-8?B?QmrDtnJuIEJhdW1iYWNo?= <bb@sernet.de>,
        Steve French <sfrench@samba.org>
CC: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <piastryyy@gmail.com>
Subject: Re: [PATCH] fs/cifs: fix regression in cifs_create_mf_symlink()
References: <1402394606-7910-1-git-send-email-bb@sernet.de>
In-Reply-To: <1402394606-7910-1-git-send-email-bb@sernet.de>
X-Enigmail-Version: 1.6
OpenPGP: id=0E53083F
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="QbxoLR5KvvS2XQrJOoAOfRa5p7cjHO6jH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--QbxoLR5KvvS2XQrJOoAOfRa5p7cjHO6jH
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Steve,

any comments on this? How can we get this fixed upstream?

Thanks!
metze

Am 10.06.2014 12:03, schrieb Bj=C3=B6rn Baumbach:
> commit d81b8a40e2ece0a9ab57b1fe1798e291e75bf8fc
> ("CIFS: Cleanup cifs open codepath")
> changed disposition to FILE_OPEN.
>=20
> Signed-off-by: Bj=C3=B6rn Baumbach <bb@sernet.de>
> Signed-off-by: Stefan Metzmacher <metze@samba.org>
> Reviewed-by: Stefan Metzmacher <metze@samba.org>
> Cc: <stable@vger.kernel.org> # v3.14+
> Cc: Pavel Shilovsky <piastry@etersoft.ru>
> Cc: Steve French <sfrench@samba.org>
> ---
>  fs/cifs/link.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/fs/cifs/link.c b/fs/cifs/link.c
> index 264ece7..68559fd 100644
> --- a/fs/cifs/link.c
> +++ b/fs/cifs/link.c
> @@ -374,7 +374,7 @@ cifs_create_mf_symlink(unsigned int xid, struct cif=
s_tcon *tcon,
>  	oparms.cifs_sb =3D cifs_sb;
>  	oparms.desired_access =3D GENERIC_WRITE;
>  	oparms.create_options =3D create_options;
> -	oparms.disposition =3D FILE_OPEN;
> +	oparms.disposition =3D FILE_CREATE;
>  	oparms.path =3D path;
>  	oparms.fid =3D &fid;
>  	oparms.reconnect =3D false;
>=20


--QbxoLR5KvvS2XQrJOoAOfRa5p7cjHO6jH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlOe9gYACgkQm70gjA5TCD89XQCfR05JcjbtnGAs3mpQXQXS1CGx
cLYAnjWQBwzYg7zJROjwbKmvp2gXjZcK
=686d
-----END PGP SIGNATURE-----

--QbxoLR5KvvS2XQrJOoAOfRa5p7cjHO6jH--

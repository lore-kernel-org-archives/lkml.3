Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762101Ab3JQBLK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 21:11:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36951 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760814Ab3JQBLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 21:11:08 -0400
Date: Wed, 16 Oct 2013 18:11:02 -0700
From: Tyler Hicks <tyhicks@canonical.com>
To: "Geyslan G. Bem" <geyslan@gmail.com>
Cc: ecryptfs@vger.kernel.org, linux-kernel@vger.kernel.org, joe@perches.com,
        kernel-br@googlegroups.com
Subject: Re: [PATCH] ecryptfs: Fix memory leakage in keystore.c
Message-ID: <20131017011101.GA3860@boyd>
References: <1381520956-20282-1-git-send-email-geyslan@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="k+w/mQv8wyuph6w0"
Content-Disposition: inline
In-Reply-To: <1381520956-20282-1-git-send-email-geyslan@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2013-10-11 16:49:16, Geyslan G. Bem wrote:
> In 'decrypt_pki_encrypted_session_key' function:
>=20
> Initializes 'payload' pointer and releases it on exit.
>=20
> Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
> ---

Thanks! This one was easy to verify by auditing the code, but I was also
able to verify the leak with kmemleak.

I've targeted it for stable and pushed it to the eCryptfs next branch.

Tyler

>  fs/ecryptfs/keystore.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/ecryptfs/keystore.c b/fs/ecryptfs/keystore.c
> index 7d52806..4725a07 100644
> --- a/fs/ecryptfs/keystore.c
> +++ b/fs/ecryptfs/keystore.c
> @@ -1149,7 +1149,7 @@ decrypt_pki_encrypted_session_key(struct ecryptfs_a=
uth_tok *auth_tok,
>  	struct ecryptfs_msg_ctx *msg_ctx;
>  	struct ecryptfs_message *msg =3D NULL;
>  	char *auth_tok_sig;
> -	char *payload;
> +	char *payload =3D NULL;
>  	size_t payload_len =3D 0;
>  	int rc;
> =20
> @@ -1203,6 +1203,7 @@ decrypt_pki_encrypted_session_key(struct ecryptfs_a=
uth_tok *auth_tok,
>  	}
>  out:
>  	kfree(msg);
> +	kfree(payload);
>  	return rc;
>  }
> =20
> --=20
> 1.8.4
>=20

--k+w/mQv8wyuph6w0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBCgAGBQJSXzklAAoJENaSAD2qAscK7h4QAIEIs3PKPlIg+5ms1l/FiNAi
/kB3ANAKzGO4EA2joiiLqseU+3MonLWj1rN+eOcIrVO/sbKHgCYeQqQ2Z+5B8DQN
1IAt90crb8DxOugEmLKbF4IOMqCdUzk+8gzgqGV53Eb0AKSfD9ntf7fupF01cF3m
X3iwGx4iA6ntg50Z77lHsnO6RHFWnyYgMDoVez/kei4F6Abc25DvSM1ZB26zaNuw
zbJ1tBTgUv1mT+cVjBExj2riqM9FZ8vQoSmE59lY842jEzEMObxfyC2T6SdtvX1T
+orEOa7cjsgOOAfMJ5OUFNAPXgpBOgljCWdj0JG/OcARRipVlzROzrt7BWcog0pc
bxlwr+zNDEABSpUGu4SFE+8QvdbJRbY9eGqWJ1S04pf0IHMaNp+B0Q7TRt6385nl
fX+l89EITsCze88ZJpZHELnhQeg15rOlHaWWrphyJEVg0oONG9FgC64u9xQOP6pi
aIEOrahw3j0ALGb2H+I7nEZVLO1+lsj4uPKGqScWO8pqyDfHhdoAsOPujo+whtK8
VEDdlP7ioa55DBIZ5mBBAPhLB12IJkthnrw7QvP5pc2ezxuHcq0eVhwE00k4gWhw
6qYWDgd491uA0SxCNo0fQm+s9OtvDICP2uwiq/RxPoPDC1hc8//1gzNHJspW3sCY
bi358Ra2aNlXk/hh8mjk
=78jk
-----END PGP SIGNATURE-----

--k+w/mQv8wyuph6w0--

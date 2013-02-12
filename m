Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933638Ab3BLSMm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 13:12:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:50769 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933109Ab3BLSMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 13:12:41 -0500
Date: Tue, 12 Feb 2013 10:12:35 -0800
From: Tyler Hicks <tyhicks@canonical.com>
To: Tim Gardner <tim.gardner@canonical.com>
Cc: linux-kernel@vger.kernel.org,
        Dustin Kirkland <dustin.kirkland@gazzang.com>,
        ecryptfs@vger.kernel.org
Subject: Re: [PATCH linux-next] eCryptfs:
 decrypt_pki_encrypted_session_key(): remove kfree() redundant null check
Message-ID: <20130212181235.GA7728@boyd>
References: <1360691814-60569-1-git-send-email-tim.gardner@canonical.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="LQksG6bCIzRHxTLp"
Content-Disposition: inline
In-Reply-To: <1360691814-60569-1-git-send-email-tim.gardner@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2013-02-12 10:56:54, Tim Gardner wrote:
> smatch analysis:
>=20
> fs/ecryptfs/keystore.c:1206 decrypt_pki_encrypted_session_key() info:
>  redundant null check on msg calling kfree()
>=20
> Cc: Tyler Hicks <tyhicks@canonical.com>
> Cc: Dustin Kirkland <dustin.kirkland@gazzang.com>
> Cc: ecryptfs@vger.kernel.org
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>

Thanks, Tim. Pushed to the next branch at
git://git.kernel.org/pub/scm/linux/kernel/git/tyhicks/ecryptfs.git

Tyler

> ---
>  fs/ecryptfs/keystore.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/fs/ecryptfs/keystore.c b/fs/ecryptfs/keystore.c
> index 6154cde..5aceff2 100644
> --- a/fs/ecryptfs/keystore.c
> +++ b/fs/ecryptfs/keystore.c
> @@ -1202,8 +1202,7 @@ decrypt_pki_encrypted_session_key(struct ecryptfs_a=
uth_tok *auth_tok,
>  				  crypt_stat->key_size);
>  	}
>  out:
> -	if (msg)
> -		kfree(msg);
> +	kfree(msg);
>  	return rc;
>  }
> =20
> --=20
> 1.7.9.5
>=20

--LQksG6bCIzRHxTLp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCgAGBQJRGoYTAAoJENaSAD2qAscKQ6AP/2EFwwRIw0ZvNQnqyVd9CRr6
W2LthdgJsICMR0zzIPZqAn+/VrhquNlmMg8i4cs+WsWOIE7RL8RMFfNkEhA7rQIN
7q/Lm1biB/ppRa6OECWJKPDOj7JnGUb0sp59e9G7ujV5FZ3nh5tr/VBa4LGkDrJz
8L6DT7SqSU5CBZzdzZNOydlu7jVKC/xgSJrgSFlqAKMimXU3PdBEf73RP+0JH0PX
cgNBA2KJeFK9NByfwDGNlqUHiw9+Id86kLxbcd4BLnI3T6xTMUlV0h8Na/iawr5i
uTiWY12Zu4vV7goPIlbpwbujTWmdvPandoTdVAlK9+/uNUAJ0qVasv+WOipDteSb
gIk49I8XnN6Xq3JiBSRVklrCrIFOCNeVpaSUXqWv8frerjZKtBovhj8+8mIl/Pb0
Q5wGxZh6Gqk4Z6VGGxHqK/mZmK4ak2MjithNx4m6llfQxNNQkFssGheCHpfkv3zK
LDlA5ZQcgc7biP4ywHLL8WjtpbPqQis1GcrsN0AGQM2/8kbrzCURk8fdsbXOZhjT
c84j01+jHAJk/f0ooxlF7uCMveGa3ZJ7JSy2LCDQzbt+Z1Y9XXK8hywbPHEWqZQ+
ZoCDOaSdDATpu5NvLWZ75FaEW3zkuOA8v0GlyYx0GSDexy7qVKSCIcJFTlNEc9no
/DnSmwp0BieRs1ax3tEJ
=6LZc
-----END PGP SIGNATURE-----

--LQksG6bCIzRHxTLp--

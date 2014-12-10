Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbaLJCrt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 21:47:49 -0500
Received: from ozlabs.org ([103.22.144.67]:48045 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751168AbaLJCrs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 21:47:48 -0500
Date: Wed, 10 Dec 2014 13:47:37 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Morris <jmorris@namei.org>, Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Kasatkin <d.kasatkin@samsung.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: linux-next: manual merge of the security tree with the vfs tree
Message-ID: <20141210134737.1b51fe92@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/Wl0c_.uDJNJbF0=JSHBXnHf"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Wl0c_.uDJNJbF0=JSHBXnHf
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi James,

Today's linux-next merge of the security tree got a conflict in
init/main.c between commit 87fb64a6c1f7 ("take the targets
of /proc/*/ns/* symlinks to separate fs") from the vfs tree and commit
c9cd2ce2bc63 ("integrity: provide a hook to load keys when rootfs is
ready") from the security tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc init/main.c
index 40240c8e31e8,9fc795fe4b3b..000000000000
--- a/init/main.c
+++ b/init/main.c
@@@ -78,7 -78,7 +78,8 @@@
  #include <linux/context_tracking.h>
  #include <linux/random.h>
  #include <linux/list.h>
 +#include <linux/proc_ns.h>
+ #include <linux/integrity.h>
 =20
  #include <asm/io.h>
  #include <asm/bugs.h>

--Sig_/Wl0c_.uDJNJbF0=JSHBXnHf
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIbBAEBCAAGBQJUh7RQAAoJEMDTa8Ir7ZwVTNsP+JhnE2pgSuyXZgo9277AJ1xR
O6g0ftYh05lm/CEFXjFbXRGrxWGRemi46nzHRZMbDMnFBbpsGEaSpAiFC9Tf766S
7Js7f2RcnQYQ4J4h/3tdlTzU8vcsvrG9cXNl1TcFKLH9iVhE3ybsbVJu+9RYb+2T
Z0GARy0QJ6Vrwk5l+R1mrRGD7CJTAgE1UUNGs5RPPUgeFV9lcMVtDS0GO8E41ZHE
v94/4k1vkSy+dmeJj9Ytzub0b2dTqmULsrG/84IiV6xrUuy/w5qEK1IzPRf6Eve5
ivguiv2uO7lAqJVOVEsqkBCAYDn4w14WfPuH8NQ6xdFi2iy8IadM0GSYzhvIHBjv
yXDJmMO5ZeoiH1hUf2avZy0eem/cP62UaeeMaxgw6tExFE7PEDYsOC+Guv1pMCn3
b69E4qBe3z0MnSC/Aq8aai5/8F0JwZWH/zNcTYIcMoyZ7zK0MRzTeQ7FfYkXT0nj
CbB7koDhDKGPvhaqYGCvWHa9MXS0GiJFowwosiNaGOMOUMk8zeZu/4Mkwb74Nn3W
LFzJxKFnMVfEIyXZ2pFbAmkRhB66qhP9vUdYQPvPTAmlFrWhbRk0Ts338yDuLry3
eIyyQsSW5dmOYi9iXs6zoV9ZLqcr3FXOo0bQ7BwuQq7K9TUrhqsCT1bkrQlJQ0ak
WXZSeFW6cql4vmzSeAE=
=Tajd
-----END PGP SIGNATURE-----

--Sig_/Wl0c_.uDJNJbF0=JSHBXnHf--

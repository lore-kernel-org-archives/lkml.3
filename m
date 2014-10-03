Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548AbaJCFqi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 01:46:38 -0400
Received: from ozlabs.org ([103.22.144.67]:39221 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751240AbaJCFqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 01:46:36 -0400
Date: Fri, 3 Oct 2014 15:46:29 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the target-updates tree
Message-ID: <20141003154629.3b64e021@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/KP=PvR9qpQcXOlvY8152U.Y"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/KP=PvR9qpQcXOlvY8152U.Y
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Nicholas,

After merging the target-updates tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/target/target_core_user.c: In function 'tcmu_netlink_event':
drivers/target/target_core_user.c:780:2: error: expected ';' before 'ret'
  ret =3D nla_put_u32(skb, TCMU_ATTR_MINOR, minor);
  ^

Caused by commit 7f2ea21b2c8d ("target/user: Fix up smatch warnings in
tcmu_netlink_event").

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/KP=PvR9qpQcXOlvY8152U.Y
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJULjg6AAoJEMDTa8Ir7ZwVht0QAIQQ9ZDLFGLfkZoGG2Dj6CGF
Xnw/HGK0j0up3TaUrDMGqO1wmg0Zrt2cpVM6ZE9Dty9lmVdD1MolqJPwq8Hd5ar9
NU70Sn9AGeIMgLnW6QuUv2KhaxBGtwBWh3eBSujz0ezPeM+9Bi/30w/PdHnuVgCs
QUzJrM5WnS6P8bL9lgOCjYkg2K54Rqsj38BTYnKADcc2EwFe+UOpM5vEDYwUF2tm
RzvgAOyGwBXXHemzL5WrtieGbmQIUtb+srLtQZFE3ZqfUL6hLjFPXbQKqdFqrqYw
EO2+giI+yD+rxv1oL7b/WcOivi+pJYTJNA/uERFhHSEfefSCHpkuj3F50aTD3Rxp
ML66vffJOnpDOGacM7HZ36vv7YDFjf/nzFy21DtB8uqWC/JjWMbTgsTpl9/aBDRS
JONXGTcTN7ISxo+23s5Ubc7ZnYsxFrhlmGyPYUazVfPzkZ5AVRy6MTmMEy3L6wzU
g8uuooDsdIdaQOdqLmacu//VwWFZdCVCoowG+Kk6jue75EYxXcWU4QD1gEt9X5MC
hKr+rHZGjsV4jabYetEUBc+0N/Yvm2KiMVQLUkqbVKW/VaEYNl3JeqsVNEx5hrfw
rj9kl22O98WFtKKCzaYdIvWLpiKUeox7HJi8iPEI8ZYRIxizXccNWDmwPPP97ifs
LOk9Dgvd23l3LXXV6dMy
=XZif
-----END PGP SIGNATURE-----

--Sig_/KP=PvR9qpQcXOlvY8152U.Y--

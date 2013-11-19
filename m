Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012Ab3KSABl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 19:01:41 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:60441 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321Ab3KSABk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 19:01:40 -0500
Date: Tue, 19 Nov 2013 11:01:27 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Anna Schumaker <bjschuma@netapp.com>
Subject: linux-next: build failure after merge of the nfs tree
Message-Id: <20131119110127.7cad0aa4d64f4641f76b761d@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__19_Nov_2013_11_01_27_+1100__9_axXg1MyPflY5y"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__19_Nov_2013_11_01_27_+1100__9_axXg1MyPflY5y
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Trond,

After merging the nfs tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

In file included from fs/nfs/dns_resolve.c:52:0:
fs/nfs/netns.h:28:15: error: 'NFS4_MAX_MINOR_VERSION' undeclared here (not =
in a function)
  int cb_users[NFS4_MAX_MINOR_VERSION + 1];

Presumably caused by commit 1a29448203ea ("NFS: Enabling v4.2 should not
recompile nfsd and lockd").  This commit is not doing well :-(

I have reverted that commit again for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__19_Nov_2013_11_01_27_+1100__9_axXg1MyPflY5y
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSiqpbAAoJEMDTa8Ir7ZwVxk0P/idqqU0xJiDTGAJnzab5UnQZ
xQZ+fl5s/uHd+DwfZQ02gxKmDIlIfimkyKd5gGKe+yNpkKUPbLQRvV2NfrNLT5pX
aOVb7ZReQjV7jTYa3tEbEG8igYPS5+7DOu0xKHyC+IyCLATwn9AcY2INwRp9MTg3
nJHkafq1hD/vOs3E6v3NW1Xeebh7GkUrAuFK5r98zPs0vOYm+j8uAbFeE8st8RLC
UzPyMlbuIeJskM/+WIvbKbtGBa6v+EzCC5BUrLcOKPpT0sso4HUkRZs8j+LF9n6q
D2U+xRsvDbUjWNNxjVGAsUZRMHOWtZY1s1nVt2Knz3028fUWwDmioa1yrgW7oD3K
EJVL2bDFePflJeXX5jX9RE9SgoL+TYBFIBESK7IiedaqRuHpR3QMY8J4rg46izgZ
eD135+Ncfvg2FEds/+t+HjCxnwgXSw1RdwhCl+dBhpbxQyebbRmrzcOVDYp4GBHK
Efw8goFN+kdRbt4lyaHtSocyzZGK47ofh6HL5MCQlbgMiY/6dQ58ZIoYN/7tFk6v
7JLnwgw0AMXtj56PJ1tiqlUtCrTh6L9gPk17J+QlFbk1lwt1CDyc8C2CsLuYYTIL
3N1OvgzdWEl8a9+vZbbWiAh6RWt2NXu+ZM3Yl1IREdGdKj6L4MYod7G0+pIjhauG
nbqadTTDKI1Zl5XSrTI0
=cIap
-----END PGP SIGNATURE-----

--Signature=_Tue__19_Nov_2013_11_01_27_+1100__9_axXg1MyPflY5y--

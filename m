Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751051Ab3KRCUc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 21:20:32 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:52355 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab3KRCUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 21:20:24 -0500
Date: Mon, 18 Nov 2013 13:20:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Anna Schumaker <bjschuma@netapp.com>
Subject: linux-next: build failure after merge of the final tree (nfs tree
 related)
Message-Id: <20131118132014.e574f520e4000d797bd5b3ba@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__18_Nov_2013_13_20_14_+1100_HtIdVr1VvAH8AQfE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__18_Nov_2013_13_20_14_+1100_HtIdVr1VvAH8AQfE
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
ppc44x_defconfig) failed like this:

fs/nfs/dir.c: In function 'nfs_readdir_xdr_to_array':
fs/nfs/dir.c:593:2: error: implicit declaration of function 'nfs4_label_all=
oc' [-Werror=3Dimplicit-function-declaration]
fs/nfs/dir.c:593:14: warning: assignment makes pointer from integer without=
 a cast [enabled by default]
fs/nfs/dir.c:629:2: error: implicit declaration of function 'nfs4_label_fre=
e' [-Werror=3Dimplicit-function-declaration]
fs/nfs/dir.c: In function 'nfs_lookup_revalidate':
fs/nfs/dir.c:1088:8: warning: assignment makes pointer from integer without=
 a cast [enabled by default]
fs/nfs/dir.c: In function 'nfs_lookup':
fs/nfs/dir.c:1296:8: warning: assignment makes pointer from integer without=
 a cast [enabled by default]
fs/nfs/inode.c: In function '__nfs_revalidate_inode':
fs/nfs/inode.c:890:2: error: implicit declaration of function 'nfs4_label_a=
lloc' [-Werror=3Dimplicit-function-declaration]
fs/nfs/inode.c:890:8: warning: assignment makes pointer from integer withou=
t a cast [enabled by default]
fs/nfs/inode.c:927:2: error: implicit declaration of function 'nfs4_label_f=
ree' [-Werror=3Dimplicit-function-declaration]
fs/nfs/super.c: In function 'nfs_parse_mount_options':
fs/nfs/super.c:1406:17: error: 'NFS4_MAX_MINOR_VERSION' undeclared (first u=
se in this function)
fs/nfs/super.c:1406:17: note: each undeclared identifier is reported only o=
nce for each function it appears in

Presumably caused by commit 4b45df7999f9 ("NFS: Enabling v4.2 should not
recompile nfsd and lockd").

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__18_Nov_2013_13_20_14_+1100_HtIdVr1VvAH8AQfE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSiXliAAoJEMDTa8Ir7ZwVtU0QAIn5Cft+OU72h81sQjEt6n8j
b4OgVgClNCBtq1yhLEh5Hjcc3Pe4d9ycVS2PQINtL/qxSVk4Hnzhgm7c0w3s3lZK
wFH8pEwmUO5bmGlmIeg4L+h6FTazr3aMnFTjSgQdoQqV68X2w3e+oTB2G0115r/J
YqYIXJio2q1LpDh5PTigQOjEw4oo4b3JWPC0KixPlifpNhG9LiegyxcHh+3BjdPB
H6Y3OKfhXu/fO3QQ+c7TeihVUqzN/gkGUYJBnDATvP1d+FJo+vRBQ9x8e2R7MWuo
SwKoCtpPKZP1Kt1fCQ5xfid80GaPc5jkKYF97wOwX9F+lVPcK3mmxSPLOVIJuhW8
TvmPGpWjIZhcfQls9lZy0gAJUeLKLUGo2oyn2mEGP6I7i8wfA+fjRyPZIBmMQL1V
bXmLRN5BX2hlWbO5m8VAF97Fce8rqxaaJxKVm3yXv1irzskzeTbJ2E6meZ7AkOHT
UO6NvdtTedeNK32qqLle4sTDs+WAS0YHC3CTjTsx+LKZvmv1I3hpS8bgpv35LUHc
4I6bp24PpflAxtm3KKiHifDFHpsVmbrvCBqhYZWDEPoWDtPrMDXTy1GQ0+5VHxuu
z4acUzXji91l8htaC2jzaL+ikX5pyTvY5IY6iFfMqaLTQsG+J7+TcVBd9st1IKR6
Gw0n8MIg+ZqjIW230K3R
=cZMM
-----END PGP SIGNATURE-----

--Signature=_Mon__18_Nov_2013_13_20_14_+1100_HtIdVr1VvAH8AQfE--

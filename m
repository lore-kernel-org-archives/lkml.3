Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950AbaKKG4F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 01:56:05 -0500
Received: from ozlabs.org ([103.22.144.67]:42072 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751334AbaKKG4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 01:56:01 -0500
Date: Tue, 11 Nov 2014 17:55:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joseph Qi <joseph.qi@huawei.com>
Subject: linux-next: manual merge of the akpm-current tree with the ext3
 tree
Message-ID: <20141111175553.795e7828@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/.4j4j_eXFv83MlwQv=4mALd"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/.4j4j_eXFv83MlwQv=4mALd
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm-current tree got a conflict in
fs/ocfs2/inode.h between commit 1c92ec678f32 ("ocfs2: Convert to
private i_dquot field") from the ext3 tree and commit eeb85794b87e
("ocfs2: fix leftover orphan entry caused by append O_DIRECT write
crash") from the akpm-current tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/ocfs2/inode.h
index ca3431ee7f24,1fdf4707e6d3..000000000000
--- a/fs/ocfs2/inode.h
+++ b/fs/ocfs2/inode.h
@@@ -81,7 -81,7 +81,9 @@@ struct ocfs2_inode_inf
  	tid_t i_sync_tid;
  	tid_t i_datasync_tid;
 =20
 +	struct dquot *i_dquot[MAXQUOTAS];
++
+ 	wait_queue_head_t append_dio_wq;
  };
 =20
  /*

--Sig_/.4j4j_eXFv83MlwQv=4mALd
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUYbL/AAoJEMDTa8Ir7ZwVGyIP/ieyLJ45HXp4fe7He3/PtMR6
N04GAsjvRMn9hl2LrArFcSps6ZG1THRegZ/MTmJvAUnzuZSNxOuojA2FCKqe+pGz
LNcDiCYzVlapzIg0dSjTCQ7QeVLlPnz1mhY9Sba+JedFa7+gMDyv5bdnik8VmhUn
LHDbd1EKRbOI9eWxy1+G2e3B1DbfP/WA6YxpaN52FOPe4A4K5j6jFLbLTSwwxVUW
asstvFhsKxygbyWVIngVvXvEI+3PVfTrC5/8bDwTcmXD4Q0/6ujbupdkHf+mofaS
XrHpsgBqWWKW6kwI5ENOMdtiGlyktBk+1X/oAIxGqgivEU4vxN5Duz7TzbnpE4Uk
iLZ/nvDIssbIvxYvP+Ttf+rriZGPcgziYH/Uc1UAj2dkLcNQ0MY/qqYrh/K+YbMo
ZWoNBQcLLL6b27aay+vAWiFI3FF21U/ndOgjvyVILWA22AysZ2fy8SvetnnPymoj
FtQ228uHCX/8d/3fYzz/G4k34l5F50tCb7jSuNmSoU/fgdeuiuBI2q2t7zh2necr
IvmXRK6BfxIT7yo3WHtdo+jFTJcrWtsCXELCj3jvgHOJQU+rXCmUUmN6JNbGgJTS
Tg1KICBRnEIuL1x4pPpBfGo5rqtqB/1WjhvYh7YoUjqI3pfK4ICfrrPCMptEGZDB
50ebQJaF+sNeEHFD+H4a
=Mtcy
-----END PGP SIGNATURE-----

--Sig_/.4j4j_eXFv83MlwQv=4mALd--

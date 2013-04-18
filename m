Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243Ab3DRBfB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 21:35:01 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:51188 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752459Ab3DRBfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 21:35:00 -0400
Date: Thu, 18 Apr 2013 11:34:54 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sage Weil <sage@newdream.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, Alex Elder <elder@inktank.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: linux-next: manual merge of the ceph tree with Linus' tree
Message-Id: <20130418113454.5762cc4657b0b3fc58c748cb@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__18_Apr_2013_11_34_54_+1000_=HVcl6kEPZwVx2Uv"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__18_Apr_2013_11_34_54_+1000_=HVcl6kEPZwVx2Uv
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sage,

Today's linux-next merge of the ceph tree got a conflict in
fs/ceph/addr.c between commit 496ad9aa8ef4 ("new helper: file_inode
(file)") from Linus' tree and commit 42f94fe2cf50 ("ceph: revert commit
22cddde104") from the ceph tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/ceph/addr.c
index a60ea97,068d2c8..0000000
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@@ -1066,29 -1104,10 +1104,10 @@@ static int ceph_write_begin(struct fil
  			    loff_t pos, unsigned len, unsigned flags,
  			    struct page **pagep, void **fsdata)
  {
 -	struct inode *inode =3D file->f_dentry->d_inode;
 +	struct inode *inode =3D file_inode(file);
- 	struct ceph_inode_info *ci =3D ceph_inode(inode);
- 	struct ceph_file_info *fi =3D file->private_data;
  	struct page *page;
  	pgoff_t index =3D pos >> PAGE_CACHE_SHIFT;
- 	int r, want, got =3D 0;
-=20
- 	if (fi->fmode & CEPH_FILE_MODE_LAZY)
- 		want =3D CEPH_CAP_FILE_BUFFER | CEPH_CAP_FILE_LAZYIO;
- 	else
- 		want =3D CEPH_CAP_FILE_BUFFER;
-=20
- 	dout("write_begin %p %llx.%llx %llu~%u getting caps. i_size %llu\n",
- 	     inode, ceph_vinop(inode), pos, len, inode->i_size);
- 	r =3D ceph_get_caps(ci, CEPH_CAP_FILE_WR, want, &got, pos+len);
- 	if (r < 0)
- 		return r;
- 	dout("write_begin %p %llx.%llx %llu~%u  got cap refs on %s\n",
- 	     inode, ceph_vinop(inode), pos, len, ceph_cap_string(got));
- 	if (!(got & (CEPH_CAP_FILE_BUFFER|CEPH_CAP_FILE_LAZYIO))) {
- 		ceph_put_cap_refs(ci, got);
- 		return -EAGAIN;
- 	}
+ 	int r;
 =20
  	do {
  		/* get a page */
@@@ -1124,8 -1134,7 +1134,7 @@@ static int ceph_write_end(struct file *
  			  loff_t pos, unsigned len, unsigned copied,
  			  struct page *page, void *fsdata)
  {
 -	struct inode *inode =3D file->f_dentry->d_inode;
 +	struct inode *inode =3D file_inode(file);
- 	struct ceph_inode_info *ci =3D ceph_inode(inode);
  	struct ceph_fs_client *fsc =3D ceph_inode_to_client(inode);
  	struct ceph_mds_client *mdsc =3D fsc->mdsc;
  	unsigned from =3D pos & (PAGE_CACHE_SIZE - 1);

--Signature=_Thu__18_Apr_2013_11_34_54_+1000_=HVcl6kEPZwVx2Uv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRb02+AAoJEECxmPOUX5FEe2sP/iHOUKKnnf9vQg8pw93uL45G
dDpibbG2PId47jPa2AB4XxeVUr+7aWaOwQkDwFcCj13bKseJBIlcLMI6KCFW4Vb9
LpdL+8iTL9OHwb7fKjB3w0cWJzkWJNN/OSxR244HdNzc0h82hKEV98dH/YYMXf4+
dFmI1ColeMq7F8VhR7GHCMY7BEjzIqLRkZY3iPyG3NkXqJ3K8cuZqQ1Vxsbeok4j
b84j0Xt7rfcABA+esDhLbqvGmWcc4F0X/PhuVFLAVS5xk0zE7BIsbfFcwERYB+V3
dOkcvGW1C8MDnWK53zhuYYTcznCzgRq6Lvz+ky1N2Emntc9dHdJazMPeGE4LhuDO
EBZkJmOql3qrDirrUVZP3bp2QQrOPqq6pVgWa3+UyZrAqI6CN6s+54/32Y03hYtO
IXIqrug3ksq4bA9XtzWOTWhhSx2KLmZ/uT0VKhgYLdb31k1M/j85DAfhfO+WaCky
vECT6wybtLi80Pyt6z5b9G/Qd6f6oZMidx682HxmuFTaa41ardFWSZHt72DvkJdC
AvM3p+BtXdFeIMv+qyObPj7/mHhoGIoiiE9MbkLyQ7ZAMz+eOAm2gQcoUJ8ayfi+
Y8VizqGb/0kqgX9x8RIYCdDUsZIc+Q59V/H2Fzlzfqa4NJP5t10xN0f0DuJDAGa0
N83jgakg2zmigOj7wEKm
=EEom
-----END PGP SIGNATURE-----

--Signature=_Thu__18_Apr_2013_11_34_54_+1000_=HVcl6kEPZwVx2Uv--

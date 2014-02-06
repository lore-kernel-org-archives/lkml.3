Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192AbaBFBIv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 20:08:51 -0500
Received: from ozlabs.org ([203.10.76.45]:36290 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752935AbaBFBIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 20:08:49 -0500
Date: Thu, 6 Feb 2014 12:08:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Howells <dhowells@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Huston <jhuston@redhat.com>
Subject: linux-next: build failure after merge of the fscache tree
Message-Id: <20140206120843.5a8b2d7928243f52436ac02c@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__6_Feb_2014_12_08_43_+1100_6EfkXCeCjB32NfzQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__6_Feb_2014_12_08_43_+1100_6EfkXCeCjB32NfzQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi David,

After merging the fscache tree, today's linux-next build (x86_64
allmodconfig) failed like this:

fs/cachefiles/bind.c: In function 'cachefiles_daemon_unbind':
fs/cachefiles/bind.c:361:4: error: too few arguments to function 'vfs_unlin=
k'
    ret =3D vfs_unlink(cache->root->d_inode, dentry);
    ^
In file included from fs/cachefiles/bind.c:18:0:
include/linux/fs.h:1458:12: note: declared here
 extern int vfs_unlink(struct inode *, struct dentry *, struct inode **);
            ^

Caused by commit ab3d73f3ce3d ("Cachefiles: Add features that make sanity
checking easier") from the fscache tree interacting with commit
b21996e36c8e ("locks: break delegations on unlink") from Linus' tree
(which entered Linus' tree before v3.13-rc1).  Does this build for you?

I have used the fscache tree from next-20140205 for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__6_Feb_2014_12_08_43_+1100_6EfkXCeCjB32NfzQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS8uCfAAoJEMDTa8Ir7ZwVyYkP/0Q00yJ25zL3pqJoASWy+p+8
n6SAR7GIWVlzVKdFbBbVse9qeKLeuLPC1gZYOBBYsJQLSKa0mOTW8H/lTtRjBMyL
yMVdrXLrgESHO89juPGQqWNkI++kMVMgXWDV6+XI//3haDYgqQ8BT7/GLHXiMequ
MxpPM5nwVSr2SLUfgCxRpxhtJSbhn3Wgs+iudZJV1KssSPcUwZRqJnfmXWZ1bOKY
miiWCWY1ieFMHgyVE5RLybeOLeD03NKXPqux6PQVvwp0WCv8Xz9g1lEIQLG1yUtL
KwzE56iESPL9XHxZxDqsU8njLnNspf8i2R5f7ZGaaXBwbVUUyH2pN3OePpmNiElj
6IdwvxhPh38kmEG4oFSB3Ph5s/l3KOn48PwwAoHWyAa5UVRgJedERXCu5MqYQP8V
S5g5Lfzxdcf1jVof7N/m3VjrW7TtPQSVbvJ8ghjfXAZISjG+AetSFvqEW2hyJ8bY
l199dj1MXdoI31s+2dl2c4AtJXaowMKRE3ECNimt5z+0m8YJgVI6hN8IujB4TjXk
R4W+25AcA2O6NpM43S5+Vqx5+quBeJGiyuEPaSii+Q5tZ1s0BdQECJ1WntVbSosp
n90VsMmqv2UUZdP/Es8wqiUkbAu8iaTktq2fmYGPrWtDi92hjvYFEzFKLHYz+qbN
NujgBEyKLS1QtcJ49yHQ
=sgpz
-----END PGP SIGNATURE-----

--Signature=_Thu__6_Feb_2014_12_08_43_+1100_6EfkXCeCjB32NfzQ--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751305Ab3GZEGa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 00:06:30 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:39140 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931Ab3GZEG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 00:06:29 -0400
Date: Fri, 26 Jul 2013 14:06:17 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Moore <paul@paul-moore.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@redhat.com>
Subject: linux-next: build failure after merge of the lblnet tree
Message-Id: <20130726140617.c31cc3d8e5fb88dd69707906@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__26_Jul_2013_14_06_17_+1000_AyLpqR+LBrHsfMEf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__26_Jul_2013_14_06_17_+1000_AyLpqR+LBrHsfMEf
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

After merging the lblnet tree, today's linux-next build (x86_64
allmodconfig) failed like this:

security/selinux/hooks.c: In function 'sb_finish_set_opts':
security/selinux/hooks.c:448:19: error: 'SE_SBLABELSUPP' undeclared (first =
use in this function)
   sbsec->flags |=3D SE_SBLABELSUPP;
                   ^

Caused by commit 8cf9124a324f ("SELinux: Enable setting security contexts
on rootfs inodes") interacting with commit 12f348b9dcf6 ("SELinux: rename
SE_SBLABELSUPP to SBLABEL_MNT") from the selinux tree.

This is not helped by the fact that there are a lot of commits in the
lblnet tree (including 8cf9124a324f) that have been cherry-picked
(instead of being merged) into the selinux tree.  :-(

I just reverted the lblnet commit above (since it has been applied twice).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__26_Jul_2013_14_06_17_+1000_AyLpqR+LBrHsfMEf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR8fW+AAoJEECxmPOUX5FEMoIP/jPj5oTOWURxopYHtiyt4Y29
anp3jY3gtO7hcnBWWl2pLlQe8qM6991Vt8RKxyakRGZAcEQytKk8jGFFIFKIvDyp
YA+F0pMgknXf5oUFdtFrjdCnUQvA6NRc2s/gZFJ6p9eLK0K5XiFPFjm7fOOmYCR/
W7yAdVCDUq6zZE4LioX1f8orwIGeysxpiziMCrJL7JI+3S0drCJAfXWW83Q7PRVD
MQ1PCyK3ozDJeoUF9b1QxpzrEWIOARF9I0zKCUry/KI+aW9jiLihS1+eWHtQWdWL
6s/HB+bj63LXwxSm5ZgKv2gPJXCByPlooAT+31i0RVHcSsVnwVG2T5BCgUr5UmY/
zxn+jAXFPeYM9wMagk729RCToCkOPz6kfF7MuInTAsRjlMc2kGW0duiSvYx5GRDD
JyQSgk117idNI64gjB7Qw/g6O8WNhq914TJSQhCbGAMKPF/M6ZsBruVv2HsanEwT
LcFSESIxCS6YEohEj2tkgsK/KwlrSWa32PPLmzqPS5V2UvA9SD3bv8z9py7VWwhf
w6JV2UJ7p6sdIEKE6dBWYBpP4BBWh9ieZSZl1YRIsrIoHMHM9zkphtKLKgV2B7yX
Mj78wHoNHdbBaamlgk/+lyDAKcuMV4xlicDlOsU8arx356C43mvbxYN/pfqhby9h
bXiZ1VLKIpYXp9eGRR+C
=6v6R
-----END PGP SIGNATURE-----

--Signature=_Fri__26_Jul_2013_14_06_17_+1000_AyLpqR+LBrHsfMEf--

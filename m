Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183AbaHKFID (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 01:08:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56074 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301AbaHKFIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 01:08:00 -0400
Date: Mon, 11 Aug 2014 15:07:46 +1000
From: NeilBrown <neilb@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Xiao Ni <xni@redhat.com>, jiao hui <jiaohui@bwstor.com.cn>,
        linux RAID <linux-raid@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [GIT PULL REQUEST] md updates for 3.17
Message-ID: <20140811150746.448ec9e4@notabene.brown>
X-Mailer: Claws Mail 3.10.1-123-gae895c (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/ZYXXkPaiRBPN+S4QDJQj+Od"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/ZYXXkPaiRBPN+S4QDJQj+Od
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

The following changes since commit 64aa90f26c06e1cb2aacfb98a7d0eccfbd6c1a91:

  Linux 3.16-rc7 (2014-07-27 12:41:55 -0700)

are available in the git repository at:

  git://neil.brown.name/md/ tags/md/3.17

for you to fetch changes up to d66b1b395a59027a1c054e1fc57d582cb4194491:

  md: don't allow bitmap file to be added to raid0/linear. (2014-08-08 15:4=
3:20 +1000)


I've nearly isolated another bug - raid6 can sometime get corrupt during
recovery.  Once that is properly understood and tested I'll send it separat=
ely.

Thanks,
NeilBrown

----------------------------------------------------------------
md updates for 3.17

Most interesting is that md devices (major =3D=3D 9) with
minor numbers of 512 or more will no longer be created
simply by opening a block device file.  They can only
be created by writing to
   /sys/module/md_mod/parameters/new_array
The 'auto-create-on-open' semantic is cumbersome and we
need to start moving away from it.

----------------------------------------------------------------
NeilBrown (4):
      md/raid1,raid10: always abort recover on write error.
      md: disable probing for md devices 512 and over.
      md/raid0: check for bitmap compatability when changing raid levels.
      md: don't allow bitmap file to be added to raid0/linear.

Xiao Ni (1):
      md: Recovery speed is wrong

 drivers/md/md.c     | 13 +++++++------
 drivers/md/raid0.c  |  6 ++++++
 drivers/md/raid1.c  |  8 ++++----
 drivers/md/raid10.c | 11 +++++------
 4 files changed, 22 insertions(+), 16 deletions(-)

--Sig_/ZYXXkPaiRBPN+S4QDJQj+Od
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU+hPoznsnt1WYoG5AQLzPA/+KLecqI3qi+ulcNyS6g4mfczuIbrR8HWZ
bJfrW8qcO4GHG4Ai4YPzbFWnQPH0jlpYd+L5TfLAHYc0r/weurMUzybSyef/0jVc
7X+dwBSh7hLpx4NZZsgMIruz7em/nmnRq56xnrs1WrBYpAem8UyCxv9sJTuYzp4b
J2DbgMCicg03FAcPTfNxLvBYwRvc6nnRlrr4gzm4V2E/TP4s9DxcAkV6jymx0fFP
S8Tj85P+MRBA34dwt1CvApbTfxF64VFRGtErrJsAcn1vDjD1EP6gGFD+E5dBQ/7l
jlOG2cWi2SaqchQW3zr0vjHoRLYwpsTEGVa8RaxjgS3PMgpvtF0lJxyJR4XlJBb9
KAKNYkOSvUO1F4BVf2jZ3RCapN+3sBya8QkkNWzmRQv4cCQx8W+8xK4DfQfekFHc
7zDe2b5zVsBdh7kalqcY/+jyqT/grsKINVtbH6BI581rFA6SVJxt+wsBM64Pf9+a
TOxOatA23oOpbj+XX+yTuE8a5EfnLNTvAbQjxmvgFShsTdWee1CGFVGPmt37aNu9
ax4U8TKxRoToi6JSz8XnPf0EHVfOqA2XGf60mFiHkMys2LCCPBBrV2pvfBFnpziL
Snj1zuafwOJc0PsFtXrj05TTu2/i93l3YZjSFUN1Rry2hoSYnZ2md5NLV/iBWewg
dkR5ATJC5uE=
=5RiD
-----END PGP SIGNATURE-----

--Sig_/ZYXXkPaiRBPN+S4QDJQj+Od--

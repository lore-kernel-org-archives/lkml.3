Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208AbaGOD37 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 23:29:59 -0400
Received: from ozlabs.org ([103.22.144.67]:54056 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753577AbaGOD3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 23:29:55 -0400
Date: Tue, 15 Jul 2014 13:29:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: linux-next: build failure after merge of the v4l-dvb tree
Message-ID: <20140715132946.771def89@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/8Q1kcl0LNxR.xSlV2DIf1yo"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/8Q1kcl0LNxR.xSlV2DIf1yo
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

After merging the v4l-dvb tree, today's linux-next build (powerpc ppc64_def=
config)
failed like this:

arch/powerpc/kernel/smp.c:764:2: error: initialization from incompatible po=
inter type [-Werror]
  { cpu_smt_mask, powerpc_smt_flags, SD_INIT_NAME(SMT) },
  ^
arch/powerpc/kernel/smp.c:764:2: error: (near initialization for 'powerpc_t=
opology[0].sd_flags') [-Werror]

Caused by commit 6a0b50087a89 ("Merge branch 'patchwork' into
to_next").  The change to include/linux/sched.h in this merge commit
does not seem to appear in either of the parents of the merge.

Its also a change that (when suggested) was shown to cause more
problems than it was worth and dropped.  I can't imagine how it ended
up in the merge commit.

I have used the v4l-dvb tree from next-20140714 for today.  Please fix
this up.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/8Q1kcl0LNxR.xSlV2DIf1yo
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTxKAvAAoJEMDTa8Ir7ZwV1N8P/RnNmtZevn6z2GOPUhT+FsdW
y9qOGEc0Q5rYRt2in5f5zH5v0B2ipz6Sx1vAMqKh6r8VkTcIbOpv1M2iJ3HfmhUF
MEy+3x/XPYdwZY5rIBXwcnA47tjtLGLhXyNMS+6kur5c88W5bcN9/S0Gf7bbM2Lt
o8C2XbB8lmO6+9LYBJ59q7BUMH5Vc8mik3dWmkeoimFgSLPicDR9jPXGFx+fMLBk
mFEcd+z94nzFqzN1pw7F5ykthuw7S9fsFhasuYNvDM5I3iRzTVpmceYjA7olkw8m
EXZrWtzILgxpe3kZbUEaBc+ro8HgteAge5oj3LQ8T/lN6iZ5rIg1wvxgu9jpu1zC
VA4Lc5DOfCTMjAMEG/5sPlx6scVBh6zETo+Eru3Ck1CB1iSPZVqodisIsRjKjwp4
mQpQb6/aT6/Mb5AMbnbJk+uxJeuF63aBss+nz7j28BwrgbMayY8Az45fykAviP9k
QP82+xswq8mjuTRoWytzReKkAf0IS3PbId5xc/lVzC6z6cWuBBUvBIpEJBVSZeat
nODfLEwYmuicz5NWWfh5fAb15M90N5l5HhaLG2hvGJwIYyI0JU93D2+djBZ6dvfk
VXK0iz8TingSOr85zruPqN5XK3YOiBohl+jyhKAtotmkZpA1SQtmZMw6c1E/QU8W
T715NS9/U8MiCWlNGlXq
=GX+2
-----END PGP SIGNATURE-----

--Sig_/8Q1kcl0LNxR.xSlV2DIf1yo--

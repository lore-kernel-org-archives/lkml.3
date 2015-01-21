Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747AbbAUVJp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 16:09:45 -0500
Received: from ozlabs.org ([103.22.144.67]:50671 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975AbbAUVJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 16:09:36 -0500
Date: Thu, 22 Jan 2015 08:09:27 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: <linux-next@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: tidy up of trees
Message-ID: <20150122080927.0c32ecd7@canb.auug.org.au>
In-Reply-To: <20150121083739.1b29cfca@gandalf.local.home>
References: <20150121151009.0cb88a21@canb.auug.org.au>
	<20150121083739.1b29cfca@gandalf.local.home>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/RM5EXGs6qUnWXtHSHcwJvpX"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/RM5EXGs6qUnWXtHSHcwJvpX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Steven,

On Wed, 21 Jan 2015 08:37:39 -0500 Steven Rostedt <rostedt@goodmis.org> wro=
te:
>
> On Wed, 21 Jan 2015 15:10:09 +1100
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>=20
> > Hi all,
> >=20
> > [affected tree contacts are bcc'd on this email]
> >=20
>=20
> > kconfig
> > Git URL: git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-kc=
onfig.git#for-next
> >=20
>=20
> This is my localmodconfig repo. I only use it when someone points out
> something broke or I find a better way of doing something.
>=20
> It doesn't get updated much because so far, I hear localmodconfig and
> localyesconfig are doing everything that people like. It may not ever
> get updated again if everyone (including myself) stays happy with it :-)
>=20
> But in case that changes, and I need to restructure it, this will be
> needed again. Should I just let this go out of next, but I'll probably
> forget that it does, and still think my for-next branch is active.
>=20
> If it is any extra burden on you to keep it, then I'm fine with it
> falling off the radar. But if it's just "I have X repos in next, and
> I'm trying to make it Y", I'd rather keep it in.

No worries, I have put it back.

I guess what I am trying to do is get the attention of people who have
trees that they are finished with, or have very stale commits in them.
After a while it can take git a significant amount of work to merge a
tree that is forked from a very old version of Linus' tree (I guess
finding the merge base gets hard).

So one thing that helps is that if even "empty" trees keep their head
"near" the head of Linus' tree i.e. within a couple of releases (and a
year is 4 releases).  That means that "git merge" is really fast (and
does nothing) and I don't care.  If a merge takes 30 seconds (even to
do nothing), and I have to do 230 merges a day, then it impacts on what
I can get through.

And worse, what looks like abandoned work in some trees could impact on
ongoing work in other trees.

OK, I just did a test:

$ git describe kconfig/for-next=20
v3.13-rc4-1-g95edca5c523c
$ time git merge kconfig/for-next=20
Already up-to-date.

real	0m1.443s
user	0m1.408s
sys	0m0.036s

So, not a real problem.  But this:

$ git describe logfs/master=20
v3.6-rc4-55-g339466142b3f
$ time git merge logfs/master=20
Performing inexact rename detection:  32% (126388520/126388520), done.
Auto-merging fs/logfs/super.c
Merge made by the 'recursive' strategy.
 fs/logfs/dev_mtd.c | 2 +-
 fs/logfs/super.c   | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

real	1m12.023s
user	1m7.920s
sys	0m0.792s
$ git reset --hard HEAD^
HEAD is now at e1e12812e428 Add linux-next specific files for 20150121
$ time git merge logfs/master=20
Performing inexact rename detection:  32% (126388520/126388520), done.
Auto-merging fs/logfs/super.c
Merge made by the 'recursive' strategy.
 fs/logfs/dev_mtd.c | 2 +-
 fs/logfs/super.c   | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

real	1m7.794s
user	1m7.216s
sys	0m0.616s

(I did it twice so that the second time it was all hot)  And then I
have to do the build (which admittedly doesn't take too long in this
case) but if a header file gets touched it is a real problem.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/RM5EXGs6qUnWXtHSHcwJvpX
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUwBWMAAoJEMDTa8Ir7ZwVUuQP/RDlCY0G2tbRwCJV+SUWeKT+
jGd7HtiEUF/OeI0iTwcyv0CHIwsI16VZ5Ogq7UWl0n5ZZo//e8kPuXNDTVTYE6j0
fvfP0WxU79BgI7jPtV9cctcMsAbcGf8rZDLjdnTr8Nki+gTtryLuTRbI/8B4m+Zx
sTjJy7Het676+p0nc2k94wQczvgbBaNjn+ASl20dAK6RQ3uKxaOriWrrqBWREXB0
UFzmf1C5Hn9RTz//mCaitkRgkeDLU+X/jnx6FKVPne18fySMR251VckHHD5EPI1k
dKwLcVNRyuZsujVglo/lZ3ETd4qG1jYGf0ryJ6+2d5pEubf3Pdp/X4c81mB3G0Bf
wTYVfUZkPQjvQGE9mF4qPU310PjhzsY54DFDzCULP6XBueBg2t8cXIasLGP2VYmf
rFUUzRT3t6ND1vH4vbZcOAZ/aHxVAvs+E8xrpLEVQlkPlUhAvSUSNS29Rjx4M/p4
3vEZuT2y/n6MeABdxmHN4iSJbqH/gGxGMauaZetMMBloFFGHF5nWMSCElABZkDfg
mMqig+V8wtW0ydwtRQOTxm+BIb77NphHrQS8maRl05YKoGO/xpN1mTkkzbumcuoe
xzDMAEhD8i93l5ONin3G5auGrWQUsLGQYnCmmUNJkGTHyTrQdsmfC6FVc83Yj9LV
SkfHAx9QjI6zbrzwgP22
=kFOS
-----END PGP SIGNATURE-----

--Sig_/RM5EXGs6qUnWXtHSHcwJvpX--

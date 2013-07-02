Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910Ab3GBXlk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 19:41:40 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40076 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639Ab3GBXlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 19:41:39 -0400
Date: Wed, 3 Jul 2013 09:41:35 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jan Kara <jack@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] ext4 updates for 3.11
Message-Id: <20130703094135.985a3130812988831f3f524a@canb.auug.org.au>
In-Reply-To: <20130702180447.GB16282@quack.suse.cz>
References: <nsxbo6mxu38.fsf@lambda.thunk.org>
	<CA+55aFyRLc81s03ULLZ26N0qwRqxS-9+6XpyhxVH62qx2b5o2A@mail.gmail.com>
	<20130702180447.GB16282@quack.suse.cz>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.19; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__3_Jul_2013_09_41_35_+1000_aR+LAyiG/=hg=6gL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__3_Jul_2013_09_41_35_+1000_aR+LAyiG/=hg=6gL
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 2 Jul 2013 20:04:47 +0200 Jan Kara <jack@suse.cz> wrote:
>
> On Tue 02-07-13 10:18:32, Linus Torvalds wrote:
> > Hmm I'm getting this compiler warning:
> >=20
> >   fs/ext4/inode.c: In function =E2=80=98ext4_writepages=E2=80=99:
> >   fs/ext4/inode.c:2219:6: warning: =E2=80=98err=E2=80=99 may be used un=
initialized in
> > this function [-Wmaybe-uninitialized]
> >=20
> > and I think the compiler is right to warn. The 'err' variable is set
> > inside a whilte() and an if() statement, and it is not at all obvious
> > that those codepaths are always taken.
> >=20
> > Maybe that "map->m_len" is always guaranteed to be nonzero, and the
> > "while()" statement could be a "do { } while()" one. But if so, make
> > it so, don't write code as if it might never be executed, when the
> > return value seems to *depend* on it being executed.
>   That's caused by my patches (only for certain gcc versions). map->m_len
> is guaranteed to be > 0 in the first iteration (the function is called fr=
om
> under if (map->m_len > 0)). I though Ted silenced that warning but
> apparently he did not. The cleanest fix is likely to make a do-while loop
> from that one. I'll send Ted a patch for that.

I did report that warning about 4 weeks ago ... and provided a fix that
was way over the top (but pointed out another problem that was fixed).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__3_Jul_2013_09_41_35_+1000_aR+LAyiG/=hg=6gL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR02UvAAoJEECxmPOUX5FEcLcP/j/TifxfijY91RLQtu2cTgP2
jXdbvg/3yGj8e81lK6J5OY3WOAVQ5/ZypXYYMcexWU5GxN03brsKRhKVBfJu2buJ
3ydJRS5xDi2ebiQdAJxxERVFeVqHQNB876xOEJTnRItKIO24FfKVzxMvS6siZnqa
dZU+zgMsZF8ksgiuA4yLoT7X0wI41Uazq6LeQ+FpXRBqNYB40vQX2QldsQMtxrzn
dtRlhqpeIgrL0bZPLi+e8kE3c6z7fOUUaEaonbb+HF4gNgYwfrSMl5M/aTETD9f2
IAXhe7oWrmRZrm73a2RRvdf1Kz8VleKcE5wLS7X95ghkoRGiIQfGG+gZ6woEHQv0
MM1vyA2rApD7FZd1Gy0dmZAtjrg9FQw5eZ0K94zYa/jq7MZEv3JR6gwHQXO/XR5M
UiJqEz2OVlulB5kZ/4hrt1lWPbZSpw6vD8gfcRsH2pP6nHPQ4kpzo+AT7UH1H1TL
sdDwzp3HZjUNWYyHmd33ft1qXNjbONL9+22eYFGDo58C0SCSQbHFqIOKjxgdGVPL
0AQvHMIK4Yb4ZJ4FA0OpybwSkiviLo6bHUyFImUSPtfTdXp+Iw0DA51ZumGf//Dd
vh2MuP8XU2bbj5SOXKZi7Ymuhu/nOycAAl1SbXl6B3gPHKjZoKXri4uafHb7QmdZ
dyxrDe3Ga8mzV2us7qlh
=Qh3u
-----END PGP SIGNATURE-----

--Signature=_Wed__3_Jul_2013_09_41_35_+1000_aR+LAyiG/=hg=6gL--

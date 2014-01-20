Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797AbaATNK7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 08:10:59 -0500
Received: from ozlabs.org ([203.10.76.45]:58235 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752134AbaATNK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 08:10:56 -0500
Date: Tue, 21 Jan 2014 00:10:48 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: sedat.dilek@gmail.com
Cc: Mike Galbraith <bitbucket@online.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Len Brown <lenb@kernel.org>, linux-next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the tip tree
Message-Id: <20140121001048.778ba63226f9f87c7bb920ee@canb.auug.org.au>
In-Reply-To: <CA+icZUWqLg+8i6RAEZbPBdoe_cbXvyjzSHSOugFeNhDw5FfJ1Q@mail.gmail.com>
References: <20140116145829.5e4fcab103b1c5c77501ee77@canb.auug.org.au>
	<20140116121955.GQ31570@twins.programming.kicks-ass.net>
	<20140117074628.88698f59939c9002b7c12968@canb.auug.org.au>
	<20140116222536.GX30183@twins.programming.kicks-ass.net>
	<20140117093426.ee8e3d1bb2e95c9f67ec625b@canb.auug.org.au>
	<52D8625C.1000902@zytor.com>
	<20140117144518.231fa4bccb16a8d7edd36662@canb.auug.org.au>
	<1390038366.5676.10.camel@marge.simpson.net>
	<20140120145122.a95b3e3a17d20117214098ca@canb.auug.org.au>
	<CA+icZUVNdEkE0uR2gn0iY790sKKFzG7Py2mPqqJN+pUNiuYXDw@mail.gmail.com>
	<CA+icZUWqLg+8i6RAEZbPBdoe_cbXvyjzSHSOugFeNhDw5FfJ1Q@mail.gmail.com>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__21_Jan_2014_00_10_48_+1100_zS7QC7eB1rFXAzUk"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__21_Jan_2014_00_10_48_+1100_zS7QC7eB1rFXAzUk
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sedat,

On Mon, 20 Jan 2014 09:46:55 +0100 Sedat Dilek <sedat.dilek@gmail.com> wrot=
e:
>
> On Mon, Jan 20, 2014 at 9:42 AM, Sedat Dilek <sedat.dilek@gmail.com> wrot=
e:
> > On Mon, Jan 20, 2014 at 4:51 AM, Stephen Rothwell <sfr@canb.auug.org.au=
> wrote:
> >> On Sat, 18 Jan 2014 10:46:06 +0100 Mike Galbraith <bitbucket@online.de=
> wrote:
> >>>
> >>> I hope it doesn't look quite like that, next-20140117 is -ENOBOOT on
> >>> Q6600 box.  See below for an alternative.
> >>>
> >>> idle: kill unnecessary mwait_idle() resched IPIs
> >>
> >> OK, so despite even further discussion, I have applied this as a merge
> >> fix patch for today.  Let me know when it is all sorted out.
> >>
> >
> > Where is this fix?
> > ( Browsing Linux-next remote GIT repository online. )
> > 2x NOPE for me.
> >
> > - Sedat -
> >
> > [1] http://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/log=
/?id=3Dnext-20140120&qt=3Dgrep&q=3Dmwait_idle
> > [2] http://git.kernel.org/cgit/linux/kernel/git/sfr/next-fixes.git
> >
>=20
> Hmmm... Found this in Next/merge.log
>=20
> +$ git am -3 ../patches/0001-x86-idle-mwait_idle-merge-update.patch
> +Applying: idle: kill unnecessary mwait_idle() resched IPIs
> +$ git reset HEAD^
> +Unstaged changes after reset:
> +M arch/x86/include/asm/processor.h
> +M arch/x86/kernel/process.c

You missed the next three lines:

$ git add -A .
$ git commit -v -a --amend
[master 65d9a14a9a41] Merge remote-tracking branch 'tip/auto-latest'

> Is this a local patch not shipped in the Linux-next (remote) GIT repo?
> Why is this not in your next-fixes GIT repo?

Its part of the conflict resolution for the merge of the tip tree.  It
cannot go into my fixes tree - that is for fixes to bugs in Linus' tree
until they are integrated there.  The tip and pm trees are both fine on
their own, but combined they don't.  So this fix has to go into the actual
merge commit for the merge of the later tree.   When Linus' merges the
later of these trees he will also need this fix - or a better one - which
is what is still under discussion.

> A bit confused about your -next policies,

Any better?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__21_Jan_2014_00_10_48_+1100_zS7QC7eB1rFXAzUk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS3SBeAAoJEMDTa8Ir7ZwVEg4P/RFts5W/C7cAvaDLikF5B2xe
iu4KFEvPAUuIVFz+KfYqLbKAfOYj5ArfRTHYq7S2fNq8KJ49wV47j4DFp0PMbyvn
Qj6C2S0TgCkxuyY5hxsa9pueqvYecg+b4a/HdKRCUFzNiUaTkcZjNKocnhwRJqpA
MMGVOxTMihMfDZgGev9wrKlb8ThwLm1swhbbJau6a8RQJa0ac0GKYzqmtE4XeQ21
119CCR+OW9VwEfpPLq7S7+mP4Yd3oamWAH9LhCMijneT68RHoCWzZtof1/87X595
Mi1yJr1Xq+UC7+SLX45FCBDt+TefkqFbf8sEfQMOFqH7SvFrjieX8qK69LYmU6rB
ThclI0BcXifGbzlmZcetCEKBXGDRA+E7n7E1xwQp48K5DSttgjKZHyBgxcwZQ/eM
rI+H4SkE/xMUvCHFbEY8cnxgfsF1C56gt8dK3BGH8WIsJa84R/jaMJzxJyJxEjA0
m7xtne0V/IBFn7AXmzxKQF01u+wLQjRH5la8WwSWeqPqP2I3aZdXdKN+GEzf/AMp
eHCNd10iFtsPpG0jfrSu6hpSMgoblR0PwiEv87lAJmHtcGIHnVXlQYp6IHsyqqyf
VaruBJwFTgpBRzjLAvZOyaHHL4aZ/k5u6D+AAJ1zKT/cGoRyALS30HDS44yrjEL5
/g8EPh0IGhXNAE99ESQh
=1tI6
-----END PGP SIGNATURE-----

--Signature=_Tue__21_Jan_2014_00_10_48_+1100_zS7QC7eB1rFXAzUk--

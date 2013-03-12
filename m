Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623Ab3CLFSd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 01:18:33 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:54221 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015Ab3CLFSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 01:18:31 -0400
Date: Tue, 12 Mar 2013 16:18:23 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: James Morris <jmorris@namei.org>, Linus <torvalds@linux-foundation.org>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: unneeded merge in the security tree
Message-Id: <20130312161823.86ea101fc4e45285b205817f@canb.auug.org.au>
In-Reply-To: <20130312041641.GE18595@thunk.org>
References: <20130312100950.e45ef0e721492ff0d5fd7c8d@canb.auug.org.au>
	<alpine.LRH.2.02.1303121510270.25612@tundra.namei.org>
	<20130312041641.GE18595@thunk.org>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__12_Mar_2013_16_18_23_+1100_0StuvUJ+KDk9c6XO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__12_Mar_2013_16_18_23_+1100_0StuvUJ+KDk9c6XO
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 12 Mar 2013 00:16:41 -0400 Theodore Ts'o <tytso@mit.edu> wrote:
>
> On Tue, Mar 12, 2013 at 03:10:53PM +1100, James Morris wrote:
> > On Tue, 12 Mar 2013, Stephen Rothwell wrote:
> > > The top commit in the security tree today is a merge of v3.9-rc2.  Th=
is
> > > is a completely unnecessary merge as the tree before the merge was a
> > > subset of v3.9-rc1 and so if the merge had been done using anything b=
ut
> > > the tag, it would have just been a fast forward.  I know that this is=
 now
> > > deliberate behaviour on git's behalf, but isn't there some way we can
> > > make this easier on maintainers who are just really just trying to pi=
ck a
> > > new starting point for their trees after a release?  (at least I assu=
me
> > > that is what James was trying to do)
> >=20
> > Yes, and I was merging to a tag as required by Linus.
>=20
> Why not just force the head of the security tree to be v3.9-rc2?  Then
> you don't end up creating a completely unnecessary merge commit, and
> users who were at the previous head of the security tree will
> experience a fast forward when they pull your new head.

Well, you used to be able to merge a tag and it would just fast forward
if possible.  That was changed (for good reason), but now gives us this
outcome.   Also, "git merge --ff" does not override that behaviour, but
"git merge --ff-only" does.  Also, of course, if (say) origin/master had
been v3.9-rc2, then "git merge origin/master" would have also just done a
fast forward.

I wonder if "git merge v3.9-rc2^{}" should work (git says "fatal: v3.9-rc2{}
 - not something we can merge").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__12_Mar_2013_16_18_23_+1100_0StuvUJ+KDk9c6XO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRPrqfAAoJEECxmPOUX5FEyrQP/1K+K0QUrnUGV+NI8OwAbsE4
OIZlvQ3jCB0dSjeLLFiji+96dVOFye2ycfC79TqosFCii8X01W7Obglr6D2wFKvf
oZotOehgU3ufQRLssLzmiVJ+cBNUOdeXjnlQUXJtq4OFvWQTp+VuXqLoTkz2rGO+
JroatEOPRbKmZbiuFrSxMN6Yvs1tovtFGSwEwj3y/3g1EmqgikSSP8Qs26Y4oG77
/n1u+EWCzKJSIoxZHwuyvoRZevtB9L6yhrnu8GOof4KACtTDjAziSOwq6J0PkDfr
mk6RhD9JZpiOvkKxPzNehXWiMpB3dgIMwt//H8hCMVAms/z2/n5dIwUK2bd5N6B8
LwGvZV2nuM28N7NlP2ecNCzBf4KDXSZDxSYMxdQrmjmLpowpet++n7MUCjfatANf
3ef5FvPyPbrQUeLjmor2BH4B13KmhfLe+lDWAahijwJs2zrWluCxxRgTfuDzzDHf
NWQZEkPvFf6KiWTtOHtc3klKl27+vWOZ+rUdFFBYjd00dtb3i+Qs3rSsPcwK9gqP
hm6GbHu31phn7ZOYW15SG1G0aetJmzE+iQq5YFS6Fn6yOrJrm5Kd0DUjlm4jORAt
wFLTspREHqfpkG2ZJpVXRvy/zmJ4bfDp3p5fp9qTGx8/qggaKeLJBwT4ECWI4BT5
3OYaRgC5puuUJrsAIjbk
=1TCO
-----END PGP SIGNATURE-----

--Signature=_Tue__12_Mar_2013_16_18_23_+1100_0StuvUJ+KDk9c6XO--

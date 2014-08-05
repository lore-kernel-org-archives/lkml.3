Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099AbaHENQF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 09:16:05 -0400
Received: from domine.madduck.net ([77.109.139.90]:49273 "EHLO
	domine.madduck.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359AbaHENQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 09:16:03 -0400
Date: Tue, 5 Aug 2014 15:15:55 +0200
From: martin f krafft <madduck@madduck.net>
To: "Theodore Ts'o" <tytso@mit.edu>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: EXT4-fs error, kernel BUG
Message-ID: <20140805131555.GB18164@fishbowl.rw.madduck.net>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	linux kernel mailing list <linux-kernel@vger.kernel.org>
References: <20140805103436.GA7531@fishbowl.rw.madduck.net>
 <20140805125114.GG5263@thunk.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="dTy3Mrz/UPE2dbVg"
Content-Disposition: inline
In-Reply-To: <20140805125114.GG5263@thunk.org>
X-Motto: Keep the good times rollin'
X-OS: Debian GNU/Linux jessie/sid kernel 3.14-1-amd64 x86_64
X-Spamtrap: madduck.bogus@madduck.net
X-Subliminal-Message: debian/rules!
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dTy3Mrz/UPE2dbVg
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

also sprach Theodore Ts'o <tytso@mit.edu> [2014-08-05 14:51 +0200]:
> One likely cause of this issue is that the hardware hiccuped on
> a read, and returned garbage, which is what triggered the "EXT4-fs
> error" message (which is really a report of a detect file system
> inconsistency).  A common cause of this is the block address
> getting corrupted, so that the hard drive read the correct data
> from the wrong location.

This sounds like it would happen every time and fsck would catch it.

> The other likely cause is that you are using something like RAID1,
> and the one of copies of the disk block really is corrupted, and
> the kernel read the bad version of the block, but fsck managed to
> read the good version of the block.

it's a RAID10 (using md), so this is a good shot, actually. Which is
bad news for me, because RAID corruption is not nice =E2=80=94 when you have
two clocks, you won't know what time it is anymore=E2=80=A6

Fortunately, I now managed to tar the filesystem content to
elsewhere without error, so in theory all I have to do now is
recreate it. And I'll recreate the filesystem while we're at it.
That should teach RAID10 again=E2=80=A6

I'd still like to drill down to the memory problem=E2=80=A6

> It's possible that this was caused by a memory corruption, but it
> wouldn't have been high on my suspect list.  Still, if this is
> a new machine, it might not be a bad idea to run memtest86+ for
> 24-48 hours.

=E2=80=A6 and will do that. I did it before, but I also just upgraded the
RAM and didn't do it again.

Thank you, tytso. Hope to see you at DC14=E2=80=A6

--=20
@martinkrafft | http://madduck.net/ | http://two.sentenc.es/
=20
"not the truth in whose possession any man is, or thinks he is, but
 the honest effort he has made to find out the truth, is what
 constitutes the worth of man."
                                                   -- gotthold lessing
=20
spamtraps: madduck.bogus@madduck.net

--dTy3Mrz/UPE2dbVg
Content-Type: application/pgp-signature; name="digital_signature_gpg.asc"
Content-Description: Digital signature (see http://martin-krafft.net/gpg/sig-policy/999bbcc4/current)

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQLvBAEBCgDZBQJT4NkKwBEaaHR0cDovL21hcnRpbi1rcmFmZnQubmV0L2dwZy9z
aWctcG9saWN5LzU1Yzk4ODJkOTk5YmJjYzQvMjAxMTAxMjQxMTI1P3NoYTUxMnN1
bT0xY2FkOTZmZDI3ZDMyMzNmNTNlMjI4NDk1MzM2NDgxMDdlNWVlOGQ1YmU2NTUy
NTFkNzRjOGYxYzVjM2JjNDJmMjMwNGZhNTE1MTUwZjdiZDRkZDA1ZTk4MTk5MjRm
MDQ5NTEzZWU5OTYyY2E3MTcwOWY4MWQ5NDUxNTg1MmJkOAAKCRBVyYgtmZu8xFFP
D/4j+Ynv8AaZFw2d5mX+MLVi/0wdZMGJ9vUjADg8wCGDM8hDJ+KOUi8Mx9MgRasl
mnra4oc9RZg10vkUBUCy5eNoGiwp27iq2ONfaQ+3lQhNnNKEBAduQQpyQF3TdxWy
nqXzbMY+BGOayKrwH6aIRCLId2ExxLbMC+FH1xmr6lpimHWPfNpjWjLG0Mr4YrFe
8pnctG/x1Xvc8iPG+XzQ4nJWBjfRveMOH8Z6UyiXknNefTrWP6BxamttB6SGOc8+
juN/3bF8mKFc4FteZWf0dXirmuGFr2Qajf6Fu7tpxa+J3UcqI6jhVkk5IQ0DkVyp
kjvnM6aHrEdHPfG6jB9cexo4Fgr0pw5yWWEMbguaf8/1BemgmwHSZSyg4ilElSvy
tgPIuNw1a630gdohrXUKyi8H0jRybetzLhy/Cs0ysM6/e6GT30mkT/IZNgxp9Is7
/ChC4SMViaNlKoUsZ4cjtfBIWcWxxtcf7cR/yG8pS2+ES5WOhGIvPvtCST72Q5UN
hYQX3ZwyFWwOFakkMuYWsFkekW7bkoXOaSGBGP4LYNTpwU/avNsdlaww71M3irK0
jlIoZqKpLZmoKRf48LiVb7nxLAhfxVQ6GM1bH5e8itQAQ6YwU9slAtOULtz4LHnN
4GZoWmmsTCOYcxTAfrdfH+SiXVtox+mfLiPM5YjMNB1qAg==
=CAFZ
-----END PGP SIGNATURE-----

--dTy3Mrz/UPE2dbVg--


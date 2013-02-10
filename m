Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760869Ab3BJPLs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 10:11:48 -0500
Received: from mail-vc0-f178.google.com ([209.85.220.178]:52901 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758772Ab3BJPLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 10:11:45 -0500
Date: Sun, 10 Feb 2013 10:11:40 -0500
From: tmhikaru@gmail.com
To: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: Linux 3.2.38
Message-ID: <20130210151140.GA2307@roll>
References: <1360160863.32217.30.camel@deadeye.wl.decadent.org.uk>
 <20130207173630.GA8355@roll>
 <20130208190819.GA16894@roll>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9amGYk9869ThD9tj"
Content-Disposition: inline
In-Reply-To: <20130208190819.GA16894@roll>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

	This is becoming irritating. Clearly bisect isn't capable of
figuring out the bad commit for me, so I'm going to have to walk the commits
myself. *sigh* (The commit it thinks is the one that's causing the problem
for me yet again is very obviously barking up the wrong tree)

git bisect start
# good: [2d18772602ba45629dfd4ffe1878ecb26fb3d3ed] Linux 3.2.37
git bisect good 2d18772602ba45629dfd4ffe1878ecb26fb3d3ed
# bad: [8eedd52017a07a5bae2aded2b5023bfba5971af9] Linux 3.2.38
git bisect bad 8eedd52017a07a5bae2aded2b5023bfba5971af9
# good: [157bb66c87286abc3dad2ed19a8cfb130ef24573] USB: option: add TP-LINK=
 HSUPA Modem MA180
git bisect good 157bb66c87286abc3dad2ed19a8cfb130ef24573
# good: [6fad7bfb8aef9a8688d3d3b3ea917b3c7d1fc8b7] can: ti_hecc: fix invali=
d error codes
git bisect good 6fad7bfb8aef9a8688d3d3b3ea917b3c7d1fc8b7
# good: [8bdb5d1a2d352d58ac99be529bb8c006dfb9be83] sd: Reshuffle init_sd to=
 avoid crash
git bisect good 8bdb5d1a2d352d58ac99be529bb8c006dfb9be83
# bad: [8a6d0db2f6a06c5fdfb7a208002d0f9961d1ad41] intel-iommu: Prevent devi=
ces with RMRRs from being placed into SI Domain
git bisect bad 8a6d0db2f6a06c5fdfb7a208002d0f9961d1ad41
# good: [756a6d71c4f566f840cf4e04fe2540e6927d2613] x86: Use enum instead of=
 literals for trap values
git bisect good 756a6d71c4f566f840cf4e04fe2540e6927d2613
# bad: [c2db6e1fa351227e9849b2504075db6f9f748874] Revert "drm/i915: no lvds=
 quirk for Zotac ZDBOX SD ID12/ID13"
git bisect bad c2db6e1fa351227e9849b2504075db6f9f748874
# bad: [d36179913a4c811f1e1b508011f1f6b9f48c3729] staging: comedi: Kconfig:=
 COMEDI_NI_AT_A2150 should select COMEDI_FC
git bisect bad d36179913a4c811f1e1b508011f1f6b9f48c3729

	I tested and then retested my rebuild of 3.2.37 and had no problems.
My stock distro kernel of 3.2.29 also has no problems.  As you can see from
this bisect log and the other one I performed previously, a good portion of
the commits in 3.2.38 tend to have no problems, but some of them do for me.=
=20
Irregularly.

	I've noted that the behavior has thankfully been showing up in
console as well as Xorg since before I stopped testing the *last* set of
bisects, so to speed up testing a tad I'm going to stop testing if the cpu
is pegged in Xorg now, and only check console.

Hmm. I suppose on a lark I could try combining the results of the two
bisects for the 'bad' entries and leave out the 'good' ones and see if that
gets me somewhere different. I mean, at this point I know which commits
*don't* work right... The trick is figuring out which ones *do*

Tim McGrath

--9amGYk9869ThD9tj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEVAwUBURe4rJEncCrqzVruAQK8MQgAlTJr0Mm4u7LkPq1wiVbD2jEEc0eaRzXb
JfdLdclKRoprNqFF3vYnzr/cq1eXhwzvTbnSf51c3hnddEDqXmfBdKVC0CubMEm6
K5U1EGgVohQ+1qiO8uRQQcYU6ld4nWCgPTr7R028nC7nzXUTzM6liAq/iiOafw+V
ZLP2E9qVtbCZW+Y5OeT5lQVXiavSlGY8frLevPPiSZWVY0+G1gVJjP8ByrC1rrCY
zfOv4DgcUd1c0R+c56cmQbythx3UGd0WEwtWxynhIKcxRnJzxhxZUmE3uobXtmmt
2awjTdAJL177bLbQm0JhsttHD/15KYPK0J4+PYfEHwZgH2mtqr5jDQ==
=BuSW
-----END PGP SIGNATURE-----

--9amGYk9869ThD9tj--

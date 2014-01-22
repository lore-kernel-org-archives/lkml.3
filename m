Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbaAVAw0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 19:52:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55303 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754462AbaAVAwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 19:52:20 -0500
Date: Wed, 22 Jan 2014 11:52:08 +1100
From: NeilBrown <neilb@suse.de>
To: Ian Kumlien <ian.kumlien@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: Re: [BUG] at drivers/md/raid5.c:291! kernel 3.13-rc8
Message-ID: <20140122115208.6a2b3909@notabene.brown>
In-Reply-To: <1390242438.587.16.camel@localhost>
References: <1390168823.587.1.camel@localhost>
	<20140120113851.3b476ed8@notabene.brown>
	<1390178957.587.9.camel@localhost>
	<20140120143748.33bb52d2@notabene.brown>
	<1390242438.587.16.camel@localhost>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/rygyYLVlWbaiFbWzQcpSoBR"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/rygyYLVlWbaiFbWzQcpSoBR
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 20 Jan 2014 19:27:18 +0100 Ian Kumlien <ian.kumlien@gmail.com> wrot=
e:

> On m=C3=A5n, 2014-01-20 at 14:37 +1100, NeilBrown wrote:
> >=20
> > Thanks - that extra info is quite useful.  Knowing that nothing else un=
usual
> > is happening can be quite valuable (and I don't like to assume).
> >=20
> > I haven't found anything that would clearly cause your crash, but I have
> > found something that looks wrong and conceivably could.
> >=20
> > Could you please try this patch on top of what you are currently using?=
  By
> > the look of it you get a crash at least every day, often more often.  S=
o if
> > this produces a day with no crashes, that would be promising.
> >=20
> > The important aspect of the patch is that it moves the "atomic_inc" of
> > "sh->count" back under the protection of ->device_lock in the case when=
 some
> > other thread might be using the same 'sh'.
>=20
> I have been unable to trip this up, so this was it!
>=20
> Tested-by: Ian Kumlien <ian.kumlien@gmail.com>
>=20
> I hope this hits stable ASAP ;)

I've push it out into my for-next branch.
I'll probably send a pull request to Linus tomorrow.
It has some chance of getting into a -stable branch next week (though I'm n=
ot
really sure of the schedule).

Thanks again for testing and reporting!

NeilBrown

--Sig_/rygyYLVlWbaiFbWzQcpSoBR
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUt8WODnsnt1WYoG5AQK1KQ/+INf6X77HU8nzHCxCL+RWsjq0dp0fsNW9
oiuRc+z8kxzbwkaTUMVqKP5jKvel+sBEgBaWGFSsyelZnk2FvTQLSjhESh1Z7Qso
wq3e0Z60uZIog7I/SquJgP3YqGhfC3oxKQr39+pWxXcqoG1U3ASKGy4DvlbAdzG/
C8rUerI6Wyhcs21ZnBUhy3KRKuCfB/u2HLQFPl8gZAR3OYh/oPhMrR2+cCJKZSTl
7CCECVqbhhwGnHme4R7OJuk4Sr0+Lbg4qmVUQtrnMIwa2gq2y8idU/NUoYKPMXP2
uvwQorjwwQ9gJJTqKGaJx10XHSfffgGXhSLogVWfi++GiKU4Jcsx8oK4KY6iumfN
Ra4gAt0AJxE/TN789ciOiXnoNdbp/WmF05cRO0yLGtO00T/5OWj8uqDjzBNMdq+V
1xx1hgY2rmMvagX0wM6ZjunISMiDiEdFp0ND3t9COZwKV62U+WGMn0zgoqhrI0Yb
PrXleFdCz+qbcjl8vp/EQpoVgzNG0xGIiyvNB7p5MBsS3Wl6T8FWIAOp5zN0pGTq
piWuT84El2LpkCsY202/C1U0xtKBH2lLUljEYJjG5zHFXRtdtaILNLbnnGmviVfU
moEhCmTLRe7IvL4gJ8efjN2YrKMWXL9iVC+rEGwaC8zsITfpkWhc01HORx51erlk
KTNcGb1sPVg=
=4diZ
-----END PGP SIGNATURE-----

--Sig_/rygyYLVlWbaiFbWzQcpSoBR--

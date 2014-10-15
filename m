Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096AbaJOLQu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 07:16:50 -0400
Received: from roy.gaast.net ([80.101.33.21]:33246 "EHLO mail.gaast.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751080AbaJOLQt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 07:16:49 -0400
Date: Wed, 15 Oct 2014 12:16:41 +0100
From: Wilmer van der Gaast <wilmer@gaast.net>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Pavel Machek <pavel@ucw.cz>, bhelgaas@google.com,
        rafael.j.wysocki@intel.com, linux-kernel@vger.kernel.org
Subject: Re: Machine crashes right *after* ~successful resume
Message-ID: <20141015111641.GC7792@gaast.net>
References: <54347520.3050109@gaast.net>
 <543AA2FE.20105@gaast.net>
 <20141012204032.GA11171@amd>
 <9751497.0fL0kvsyX7@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qDbXVdCdHGoSgWSk"
Content-Disposition: inline
In-Reply-To: <9751497.0fL0kvsyX7@vostro.rjw.lan>
X-Operating-System: Linux 3.2.0-4-686-pae on a i686
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Rafael,

Rafael J. Wysocki (rjw@rjwysocki.net) wrote:
> > Would it be feasible to revert 2e8b... to see if it fixes it on 3.17?
> That's a merge, isn't it?
>=20
Correct, it was, and I did try to figure out which of its parents was
the guilty one, but then I found out the real problem is
928bea964827d7824b548c1f8e06eccbbc4d0d7d.

Not sure why 2e8b... was initially found guilty by git bisect, I fear
that my testing was not thorough enough. I've verified a couple of times
now that 928bea96... does cause crashes and the previous revision does not.

928bea... seems to reshuffle PCI initialisation a little bit and has
caused more troubles, judging from a Google query for it. Some changes
were made already as a result, and this unfortunately makes a revert on
a later kernel tree (to see if that fixes the problem for me) much less
straight-forward. :-(

I can look at the code and see how to revert this now, but I'm
definitely not very proficient outside userland.


Wilmer v/d Gaast.

--=20
+-------- .''`.     - -- ---+  +        - -- --- ---- ----- ------+
| wilmer : :'  :  gaast.net |  | OSS Programmer   www.bitlbee.org |
| lintux `. `~'  debian.org |  | Full-time geek  wilmer.gaast.net |
+--- -- -  ` ---------------+  +------ ----- ---- --- -- -        +

--qDbXVdCdHGoSgWSk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iD8DBQFUPleZeYWXmuMwQFERAgNJAKCMk5WtAl6p3DmOfP4f5JMuHukuWgCfZmSD
xeawce6QZwmnWP9ku+5w8m0=
=PHmY
-----END PGP SIGNATURE-----

--qDbXVdCdHGoSgWSk--

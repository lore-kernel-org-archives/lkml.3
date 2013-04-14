Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750794Ab3DNEBt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 00:01:49 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39937 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750695Ab3DNEBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 00:01:47 -0400
Message-ID: <1365912098.2783.42.camel@deadeye.wl.decadent.org.uk>
Subject: Re: helping with tracking commits across repos
From: Ben Hutchings <ben@decadent.org.uk>
To: dmg@uvic.ca
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 14 Apr 2013 05:01:38 +0100
In-Reply-To: <87r4ifxzwu.fsf@mn.cs.uvic.ca>
References: <87r4ifxzwu.fsf@mn.cs.uvic.ca>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-DxbFV5kwaYTdOmhpStjo"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a8e5:9d84:f4af:2b5f
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-DxbFV5kwaYTdOmhpStjo
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I notice that where a commit is cherry-picked cleanly on a stable
branch, like 6b90466cfec2a2fe027187d675d8d14217c12d82, your script finds
the corresponding commit on the stable branch.  This is useful.

But where some backporting changes are needed, such as for
f01fc1a82c2ee68726b400fadb156bd623b5f2f1, which became
8ebfe28181b02766ac41d9d841801c146e6161c1 on the 3.2.y branch, the
corresponding commit isn't found.

It should be possible to find such backported commits based on a simple
regex search over the commit message:

	for (<$body>) {
	    if (/^commit (.*) upstream\.\n/) {
		$upstream =3D $1;
	    } elsif (/^\[ Upstream commit (.*) \]\n/) {
		$upstream =3D $1;
	    } elsif (/^\(cherry picked from commit (.*)\)\n/) {
		$upstream =3D $1;
	    }
	}

This covers all formats in current use to show a direct correspondence
between a single mainline and stable branch commit.  (Really we should
settle on just one format...)

Ben.

--=20
Ben Hutchings
It is impossible to make anything foolproof because fools are so ingenious.

--=-DxbFV5kwaYTdOmhpStjo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUWoqIue/yOyVhhEJAQo9kA//cciWCl3Ugy2CjtPE3JU1YCiqxvKQXWZb
rSLI0+VIjQzdwJDaZ8RD2pGDk38LmmUCAsfd0Dw91JVr07DQkaMAc4eGFKML69Y7
ZW006eT7T37715Jp71agpIb5A9/ZoRWZM8MN07hyk+/LiwirFUcdLPc37UPMQVHS
tRD3S6NDA+efKoEK3E6ayJCJ2mQjdaEuDmQvVlaCjpQXm4pzY3vxIKPbtYxL6gfw
br7FSvt5jen2EPfJU3bt7B3qUwdlkp8u9miNCuHuL/fQAggsLhQOLsmOax04287B
XjUxZZTamD/MTtLOOIG9ZJuDJSih9bbmQDDBVSIhDebx1hiMmRlVxvknG0+JgVMC
kRjxIBmJv36r08XfHlCdYDzLsX15YSgN6Iw5l5sZN6ZfT1p9KpgNV5aBQnkhEiJ5
rnuXNxoN1EL0YX2VGpMl+CuHM8SKtzmbBHf2rODpBslicaP6MFmqT7eDG4hlLlgE
6IZAMXWa+QegkdLS8wexd3Mgc7VF8KjjhE8eFLhnHzQEsjKPmklgKtoIqBpmnntK
ysL96CqlNhWjuYCe9tqQ06aEqgsPdCqVeOVtiNX+ztQz4IKPRSQNUiR98YIvtI+Z
C7Oiwlv5fz/aMhFy74OiqEQSGG6Eu1HgcN+pjhgvktvFEWy5r/anRrkXGDZpHEb/
n2zhSGG9EWs=
=gzEd
-----END PGP SIGNATURE-----

--=-DxbFV5kwaYTdOmhpStjo--

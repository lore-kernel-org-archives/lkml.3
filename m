Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751140AbaIFJPw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 05:15:52 -0400
Received: from mga01.intel.com ([192.55.52.88]:31625 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817AbaIFJPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 05:15:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="asc'?scan'208";a="382285042"
Message-ID: <1409994948.2460.48.camel@jtkirshe-mobl>
Subject: Re: [PATCH] efi: Resolve some shadow warnings
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: matt.fleming@intel.com, Mark Rustad <mark.d.rustad@intel.com>,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 06 Sep 2014 02:15:48 -0700
In-Reply-To: <20140906090331.GQ3001@console-pimps.org>
References: <1409967292-31441-1-git-send-email-jeffrey.t.kirsher@intel.com>
	 <20140906090331.GQ3001@console-pimps.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-VOWvnzG+Qwg5ec+4dQY3"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-VOWvnzG+Qwg5ec+4dQY3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2014-09-06 at 10:03 +0100, Matt Fleming wrote:
> On Fri, 05 Sep, at 06:34:52PM, Jeff Kirsher wrote:
> > From: Mark Rustad <mark.d.rustad@intel.com>
> >=20
> > It is a really bad idea to declare variables or parameters that
> > have the same name as common types. It is valid C, but it gets
> > surprising if a macro expansion attempts to declare an inner
> > local with that type. Change the local names to eliminate the
> > hazard.
> =20
> Oops, good catch. Could you include a copy of the compiler shadow
> warnings in the commit log? I'm guessing this bug is highlighted with
> -Wshadow? How did you discover this problem?

Mark was using W=3D2 to see the warning, so I will see if I can wade
through the numerous warnings that get generated with W=3D2 for the
specific warning.

>=20
> > Change s16 =3D> ps16, s8 =3D> ps8.
> =20
> Hmm... Instead, could you change it to str16 and str8? s8/s16 were
> clearly misguided names in the first place, and it's not immediatealy
> obvious to me that a 'ps16' would represent "pointer to 16-bit string".
>=20

Ok, I can re-spin the patch for Mark, that is if I can capture the
original warning to add to his commit message.  Otherwise, I will wait
till Monday to have Mark re-spin the patch.

--=-VOWvnzG+Qwg5ec+4dQY3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJUCtDEAAoJEOVv75VaS+3OIQIP+wV5dXiuBGv7zkTJEy541X8n
R9ikVWg0ANQ4VskDDAPJhIMgj0/XEa8gAvx6gYH/Q+kcLBqjUa33fI9rwgm1hz+r
wf6ie3ZQ6sJvoBt8i838rz7BUGjkftsh9RH3I7mjehGgob3d4BREYs84JM25301G
khmF28q0JjEGVoDL1HBkgZus543nF6r92yGdJzeG4gHEpJyMckZpCLi6cX/Brv7t
YGglGeiuQ7gCPxvfkKfnm8or179SAjyZ2AQyoBfEw7fXU7WzgdOmG8t/3oDZWYC8
VgcFMwsV5dinIk3zYM4GySDjFAbhSLHyYUYibJF9mu7xrVj3fIs3UHaNnxHC9kv9
8ZimOZKKJkr15rLs5mY5aFzgUgLUtuQ6qt3J9W9Jca8g8PLs4MC66ds7RQjAaaYH
jNxaVBeQjZE/HUk+vJ7YA8zyjsV0cJait0Jcw9uMdTogHxVYFR1B9yyxH8+uhuLq
AmzCVkC20nzesh994UF9ZKlyNntBH8NYg0nwMAt1thEPmC7jp2evcWmm/2euGRBz
RZc/oTayDD9kiY92fATrVY1wF+8KiD42TLQw1NvkC2KaiALr26DIsIhtb5CDskc2
7avd+/wzY6d0s2Brf8WlTFzDe+Xdnm2FdyK763YzjdE6oNY18BYkLb4C/NxsTqYH
SzqldEGAleKxBgqy/yMX
=NGip
-----END PGP SIGNATURE-----

--=-VOWvnzG+Qwg5ec+4dQY3--


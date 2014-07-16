Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965396AbaGPP1r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 11:27:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:35562 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933938AbaGPP1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 11:27:46 -0400
Date: Wed, 16 Jul 2014 17:27:36 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Greg Donald <gdonald@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>
Subject: Re: find_busiest_group divide error
Message-ID: <20140716152736.GD19379@twins.programming.kicks-ass.net>
References: <20140714165659.GA9289@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="B2GzrzFQbYDXIsTK"
Content-Disposition: inline
In-Reply-To: <20140714165659.GA9289@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--B2GzrzFQbYDXIsTK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 14, 2014 at 11:56:59AM -0500, Greg Donald wrote:
>=20
> [1.] One line summary of the problem:
>=20
> find_busiest_group divide error
>=20
> [2.] Full description of the problem/report:
>=20
> Around June 7th I found I could no longer boot a mainline kernel.  I
> posted about it here on June 9th:
>=20
> http://lists.kernelnewbies.org/pipermail/kernelnewbies/2014-June/010914.h=
tml
>=20
> I bisected two complete times but never got to a commit that made any
> sense:
>=20
> https://bugzilla.kernel.org/show_bug.cgi?id=3D77711
>=20
> I see a lot of kernel/sched/fair.c patching appeared in mainline on June
> 5th:
>=20
> https://github.com/torvalds/linux/commits/master/kernel/sched/fair.c
>=20
> So I tried checking out specific revisions and found
> 09dc4ab03936df5c5aa711d27c81283c6d09f495 is the latest good revision I
> can boot.  The first bad revision I hit is
> 51f2176d74ace4c3f58579a605ef5a9720befb00.
>=20
> I have no idea how to fix it.  I'm just a web developer/kernel tester :(
>=20

Could you confirm if reverting caffcdd8d27ba78730d5540396ce72ad022aff2c
cures things for you?

Otherwise there's two very similar issues, see also:

   lkml.kernel.org/r/20140716145546.GA6922@wolff.to

--B2GzrzFQbYDXIsTK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTxpnjAAoJEHZH4aRLwOS6wbsP/jshM/iKjvB08N/ccPgBZpto
WTCF9ATAPw3/juX/zqrOVuWPtMM05xBBjxJOIN4s02+AFXupXw3S7Fyy6RtgfIh0
gRIl6tDi2OO7fapF2W27pCKE7gVxrp1Hlkf1rdkSxTdp2P0xejwIw8h68bOz5zgH
leOQdZjDGaPzhhvkB9zbFyml90/0PipBZS574FulTbO7s/manG0dZKBvqSQ8Bk8i
8HQS8Or6114HqGCrO079FqtGoaDjZC0ns0TjvNaqVJKEg/fIedq1mBgZyHcgZ5Di
c6XulTA6sTMQTzTcS8WeVSXDjlKPVtjNETf28AJdlxuANqmM8wLf/RQsq93jLRn6
3i68Xe6z90uFea/zoYipX6VpQ6urLtFjtH6APU6XKW7JEgZZ4J2veEybmwBH/ULZ
+kVDc8/A8+3Gsduh5em6uLFx2s1XhU9yXAd6dtIpqmafhidWqQLzNZUkKaS+Ry4x
LftqJVYNMGBPTFhSjNExaBXn7O3N8YgqWWp1z7XzV60IahDF4K/7ouifObzgqnrk
3hiInZ5oQgeFAfFy7YzBWQGux2d6waQcQigdYWQ+ZvNksV97yY2o8EK8X6oB/T3K
7jTXD7NiTA+c9EazHXGIwvGhahRtqrDs375+XCKAH6d+dJL5rBZlGd2SQUjzwm3b
TKVJkidTPsZv7qb7Bbsx
=45SO
-----END PGP SIGNATURE-----

--B2GzrzFQbYDXIsTK--

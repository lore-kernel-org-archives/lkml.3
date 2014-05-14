Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224AbaENQwP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 12:52:15 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:33380 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755276AbaENQwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 12:52:13 -0400
Date: Wed, 14 May 2014 18:52:05 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Ingo Molnar <mingo@kernel.org>, acme@ghostprotocols.net,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Dave Jones <davej@redhat.com>
Subject: Re: perf: use after free in perf_remove_from_context
Message-ID: <20140514165205.GU30445@twins.programming.kicks-ass.net>
References: <5370EBE9.6@oracle.com>
 <20140514162943.GR30445@twins.programming.kicks-ass.net>
 <53739A9A.5010703@oracle.com>
 <20140514163535.GS30445@twins.programming.kicks-ass.net>
 <53739BF2.1030100@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="q3YFxXYBXviVjKLs"
Content-Disposition: inline
In-Reply-To: <53739BF2.1030100@oracle.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--q3YFxXYBXviVjKLs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 14, 2014 at 12:38:10PM -0400, Sasha Levin wrote:
> ./trinity -xinit_module -xreboot -xshutdown -xunshare -xnfsservctl -xcloc=
k_nanosleep -xuselib -xumount -xmount -m --quiet --dangerous -C 400 -l off
>=20
> Note that I run it as root in a disposable VM. Running that as root on yo=
ur
> machine will likely kill it.

Right, so i'll start with !root running. That said, I seem to get an
endless stream of double free or corrupt msgs:

trinity$ ./trinity -xinit_module -xreboot -xshutdown -xunshare -xnfsservctl=
 -xclock_nanosleep -xuselib -xumount -xmount -m --quiet  -C 400 -l off

=2E..

*** Error in `./trinity': double free or corruption (top): 0x000000000135af=
60 ***
[main] Random reseed: 3671679404
[main] Random reseed: 67838733
*** Error in `./trinity': double free or corruption (top): 0x000000000135ef=
60 ***
[main] Random reseed: 943044433
*** Error in `./trinity': double free or corruption (top): 0x00000000012bb2=
10 ***
[main] Random reseed: 3627649145
*** Error in `./trinity': double free or corruption (top): 0x000000000139db=
e0 ***
[main] Random reseed: 935036390
[main] Random reseed: 3922349807
[main] Random reseed: 835563887
*** Error in `./trinity': double free or corruption (top): 0x00000000013238=
90 ***
[main] Random reseed: 974945617
*** Error in `./trinity': double free or corruption (top): 0x00000000013081=
90 ***
[main] Random reseed: 2912296953
[main] Random reseed: 681900861


Is this 'expected' behaviour?

trinity$ git describe
1.1-1418-g8bf4840


--q3YFxXYBXviVjKLs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTc581AAoJEHZH4aRLwOS6Oh0P/1YKKFVTLaJ2SBWJC8io8ZMR
brhbkWz6hv4tfwFr74yp76iX7eOyV1BMpYpTn+1aiGJKDx2Q901bcH/c6BK6ujqj
jmK/GdVH90zF1Ea1/kt4j017L+UUXRTU95O2utvNj6Cv+KkLTx+axvzY2mWqNZTi
s8FgCV/Yt9siBPZ+1prnoTnkIiMbxQdhFwVp1aoQeQ9KUUBYV+wB99rBu5xwlmqe
/Jlxt3a2SQ7RQilJBz2w7Se6LCrQO1m5t7zjsMZ7gmznyJhj855wMhwRf4wIUTYr
9F+ow+aC+gCm7Qfbew20C3mOglckBZTN1pX3b4BW//gMKn44ZzcudI3ngGzVu/G/
YLex6Z/IIeUz+x1l+O9yA/5+8hiwskRYAadSxgBjyfiVZMonTXWHDKSBDhjjxwfu
kghbXuTKXpQ7r41m+i2xMouauvo73BmMYO6P0eqoFCbJyfaSO2zlWc/bFHb1hbqR
wgF/sK1OQ0dYKN/W6Wuxnkiz2IOXkDO9fLTGeVDZFbcE43bxtGIIScs6vxsXsKur
zIU5ZLOcL7+GKscmShJu8BEnV03SB/IGJ0KIueSw2YPkNehys28FfVE9ZzlwAoNb
OLsgnsdzGwil9uTx3ItR2n+P3K2BwkJ4M1Cqlt1hBNGjCfl/5gLCe/LiGJf1u5rs
moqvh/JXbyMPhj2MJdqZ
=deD+
-----END PGP SIGNATURE-----

--q3YFxXYBXviVjKLs--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030238AbaEQRA5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 13:00:57 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:51607 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964813AbaEQRA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 13:00:56 -0400
Date: Sat, 17 May 2014 19:00:37 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Dave Jones <davej@redhat.com>,
        price@mit.edu
Subject: Re: BUG_ON drivers/char/random.c:986 (Was: perf: use after free in
 perf_remove_from_context)
Message-ID: <20140517170037.GA11096@twins.programming.kicks-ass.net>
References: <5370EBE9.6@oracle.com>
 <20140516153455.GV11096@twins.programming.kicks-ass.net>
 <53763775.3040602@linux.intel.com>
 <20140516162117.GY11096@twins.programming.kicks-ass.net>
 <1400287582.11005.118359877.7B81534B@webmail.messagingengine.com>
 <20140517021840.GA5513@thunk.org>
 <53778D40.5020203@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="U4Pv8ouM+6WX/UB7"
Content-Disposition: inline
In-Reply-To: <53778D40.5020203@oracle.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--U4Pv8ouM+6WX/UB7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, May 17, 2014 at 12:24:32PM -0400, Sasha Levin wrote:
> On 05/16/2014 10:18 PM, Theodore Ts'o wrote:
> > On Fri, May 16, 2014 at 05:46:22PM -0700, Hannes Frederic Sowa wrote:
> >> > This should do the trick:
> >> > dd if=3D/dev/urandom of=3D/dev/zero bs=3D67108707
> >> >=20
> >> > I suspect ee1de406ba6eb1 ("random: simplify accounting logic") as the
> >> > culprit.
> > Yep, that it's it.  Thanks for noticing this so quickly!  I'll push
> > the following patch to Linus.
>=20
> Peter, could you describe the infrastructure you're running on? I don't
> think Dave or myself have ever hit this issue, and I wonder what made you
> stumble on it.

I'm running it on a WSP-EP, 2 nodes, 6 cores per node, 2 threads per
core for a total of 24 cpus.

I'm running trinity as user, and using:

  MALLOC_CHECK_=3D0 ./trinity -xinit_module -xreboot -xshutdown -xunshare -=
xnfsservctl -xclock_nanosleep -xuselib -xumount -xmount -m --quiet -C 400 -=
l off -xmremap

to run it.

I'm currently also running with syscall and a few other trace bits
enabled, but I suppose that shouldn't affect things too much.

The machine is running Debian wheezy with a few choice testing bits.

--U4Pv8ouM+6WX/UB7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTd5WvAAoJEHZH4aRLwOS6URYP/AwvNa5Sc1ILfUk1ka/B32Sa
r9kZU45V761Q9BHJhCcbgnfAYHokLT1bIqfv09c4Q7XKgnCNK05f9oWRHxpfkMON
9aOMSnzzfq+oQlLgj4vgdhG0jHlR4CV/jVwgYasTPIBf1F0erV0tY9Cicd0VsvhL
akm445dO2R5tFZ19V+/yc1uS6eky3T0jFkOsvGflj6yGokx69h3QceNUfmw7Eg1o
HLFiF2Bx7zBS8K/BjLfewLwMH2gKMMtbnmlpc/IyM4+whdfUw5VQkit0M70sWaCu
oC18P5U8gOcoOKJcTf+h91PC6MTXQIEe90KMaWn5MGHsVTV7CbbC2Sd4lzEMR7Dg
kKxK9BSmuqAwSpuQJD1qn2mxRTgP+bjAfdNHazuSj6afotpqZtzL/gOny31o7/13
H41R9gzYYRgAZqBl9YNVa9PuEQY2TsGKNf2BxmDZfIRmRWPwOG9QnVqXQMJX2j75
D6s83zbCb+T8kHk7Z30oetNHN69+j09/MIZX73WAelK7CG/BwLQAHyUoO4DyuI6D
ElhsbAcHJoDwvdppQPPuD/u8+rlP3BP8+1XoCwEs+xA8bXSdir2/Imc0xFqZswyt
YfGjPGfgGVuZHB4OKC1oE0gBpcGZy4hTObhNgSC9ewLS+/Cy/+qSViSyeDf+qF1d
iOt7vS/spC+s4CMkTH4h
=c3Vc
-----END PGP SIGNATURE-----

--U4Pv8ouM+6WX/UB7--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985AbaENQfn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 12:35:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:50722 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbaENQfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 12:35:42 -0400
Date: Wed, 14 May 2014 18:35:35 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Ingo Molnar <mingo@kernel.org>, acme@ghostprotocols.net,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Dave Jones <davej@redhat.com>
Subject: Re: perf: use after free in perf_remove_from_context
Message-ID: <20140514163535.GS30445@twins.programming.kicks-ass.net>
References: <5370EBE9.6@oracle.com>
 <20140514162943.GR30445@twins.programming.kicks-ass.net>
 <53739A9A.5010703@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CmWxRWyFvh6D3sQF"
Content-Disposition: inline
In-Reply-To: <53739A9A.5010703@oracle.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CmWxRWyFvh6D3sQF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 14, 2014 at 12:32:26PM -0400, Sasha Levin wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>=20
> On 05/14/2014 12:29 PM, Peter Zijlstra wrote:
> > On Mon, May 12, 2014 at 11:42:33AM -0400, Sasha Levin wrote:
> >> Hi all,
> >>=20
> >> While fuzzing with trinity inside a KVM tools guest running the latest=
 -next kernel I've stumbled on the following spew. Maybe related to the ver=
y recent change in freeing on task exit?
> >>=20
> >> [ 2509.827261] general protection fault: 0000 [#1] PREEMPT SMP DEBUG_P=
AGEALLOC [ 2509.830379] Dumping ftrace buffer: [ 2509.830379]    (ftrace bu=
ffer empty) [ 2509.830379] Modules linked in: [ 2509.830379] CPU: 47 PID: 4=
3306 Comm: trinity-c126 Tainted: G        W     3.15.0-rc5-next-20140512-sa=
sha-00019-ga20bc00-dirty #456
> >=20
> > Any particular trinity setup? And would you happen to have the seed of =
that run?
>=20
> Nothing special about trinity options. 400 threads and blacklisting some =
of the
> destructive syscalls (umount, reboot, etc).
>=20
> I don't have the seed, but that problem did reproduce again tonight so I =
can test
> out debug code if you have something in mind.

Nah, I drew a pretty big blank, which is why I wanted to see if I could
reproduce. If you could share your trinity cmdline I'd be much obliged.
While I did manage to clone (the repo moved since last time) and build
it, I'm not really that handy with it and want to avoid destroying my
machine if possible ;-)

--CmWxRWyFvh6D3sQF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTc5tXAAoJEHZH4aRLwOS68PkP/0hZZVAdBAkJwXZPsFM4aUY4
dRlOYmATpK3UaZFZePwvuHpoAHNjC3JWLq1TjZcz+cpmZCq7bfh7gFDnslXZniRw
d89f8CxwmN9+ZhS2hHJmtE8hzGAY3ZEv8/ZlZGxj3yaEIeNXfKSAb/bI9kG0ISCn
GDpuopvgcM3kh8ZkzPYv+PJBDQDbhoohj2/DjFy0hsB8+j78nY+oCrjNdI4bzM2G
TuATYDetssarCUAosHoQv7gIP4cXAgYyjY+CGov9F20etNltSO59v9rhKYhFjpq2
MaAykJlBTAcjZp8dsVjLekqcD5rFGdyhCeORD1s3etdTKKv0qf2b1BHwdj/raPQe
CM92oDWVb5U3Rk5Su7d0r2iD1RwhFb482ccMgxSRYvqaU/5xFzdIOFtskZTCLTPi
1CjLk8mTwCY9ggl+eri/4anvHQCUBJIUucdlrkWeKze2PoxIvyzF/vktdIjPSrR8
RB6u439aErTxzVS24eWsqsOpeLKizskPQ3RX7wiNoqp6wV33qr85/SIer5qz7Fsv
aBCXbIqmEFHsWK/lyONAWcS/QpeX9St1lQCbU71YcfhVbqlc/+HDienp1W8YMicG
CXzIyK48yauk1rVJcIobF8zB8hcCpCVLkaKURCCbPbEbJr1QrIy82mse82C3vfqa
tvjioAVnoe5hlvSxX/m8
=gOAR
-----END PGP SIGNATURE-----

--CmWxRWyFvh6D3sQF--

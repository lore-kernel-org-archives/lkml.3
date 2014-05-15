Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751658AbaEOIhi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 04:37:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:56707 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbaEOIhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 04:37:36 -0400
Date: Thu, 15 May 2014 10:37:30 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [perf] yet another 32/64-bit range check failure
Message-ID: <20140515083730.GF30445@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1404222329590.28273@vincent-weaver-1.um.maine.edu>
 <20140423102254.GL11096@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1404241712310.9220@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.10.1405150106410.30079@vincent-weaver-1.umelst.maine.edu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cCEKa9UdY3MtHM1R"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1405150106410.30079@vincent-weaver-1.umelst.maine.edu>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cCEKa9UdY3MtHM1R
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 15, 2014 at 01:07:34AM -0400, Vince Weaver wrote:
> On Thu, 24 Apr 2014, Vince Weaver wrote:
>=20
> > On Wed, 23 Apr 2014, Peter Zijlstra wrote:
> > >=20
> > > Something like so should do I suppose.
> > >=20
> > > ---
> > > Subject: perf: Fix perf_event_open(.flags) test
> > >=20
> > > Vince noticed that we test the (unsigned long) flags field against an
> > > (unsigned int) constant. This would allow setting the high bits on 64=
bit
> > > platforms and not get an error.
> > >=20
> > > There is nothing that uses the high bits, so it should be entirely
> > > harmless, but we don't want userspace to accidentally set them anyway,
> > > so fix the constants.
> > >=20
> > > Reported-by: Vince Weaver <vincent.weaver@maine.edu>
> > > Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> >=20
> > Tested-by: Vince Weaver <vincent.weaver@maine.edu>
> >=20
> > Your patch fixes the problem, or at least the test I wrote to check the=
=20
> > issue now fails properly.
>=20
> Even though this isn't as pressing an issue as the other perf_event=20
> problems, I wanted to make sure this patch didn't get forgotten...

Thanks for reminding me, got it queued now.

--cCEKa9UdY3MtHM1R
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTdHzKAAoJEHZH4aRLwOS6yPsP/3K1QkRzkqTlfzwslpH0ERPj
XtmB/oUcbZeqQKh3In0a6PVq7Z4EPj0NDZ2Bzo1ShV/VbJgpGZQ4lSAoNEnE1QNg
bs8SR8qiUZb6Xhc9seTyD+u9w6Q1ziPElMrgXxsenq6TtA9iEoYSTWe/HgTTNZAx
dBOEWNTtkyXsaelcl5N3P3mop7VGxzQESZjMD2AEcGIuirOZPbB+ZWiDbIAJ/lYz
MDBNnBCp3NbKyKE6EvJMQKqoxjwMuGmLiz354SAoeobm4Z/6U1NkyYu+c9a5yyD+
qDcakteV+u5xYWi7awwBrOj3SQHQ8n6Z9yuXTEFCpb2PkJvOCc30iA8f+yw+sjbv
1uHggGczV6bnMZ0G4ivlCd9R7ZhfsyIHXXFsJeBjuU8T1ZvNFmCCafJ1MSMbZ7wb
BNp/d+KCfsPkzJoSq+zWTLn1ZKXaU19nRn8GBKrqcCoKEMb0Hiyha/mGn/M/HZNc
zHozGf+cc/S7HLB4OwoX/Em0Xg5Xbgt5eO98C98m2gX4nhg3sPAajaLcOKKsjYAm
w4JI52aAfuZuYbnaLESR2gJflC8uUedMOPENYe0VLCtZsYZKU8QY2dC+OlpGavJm
zMIYT4vdWvqm2fbIozhyTVhLTn/jrgRpxcFKV0gyrlfiFe6dVjCPPLdoAnYA/Krw
s+gpM+PwDpLElAGVanId
=bSl9
-----END PGP SIGNATURE-----

--cCEKa9UdY3MtHM1R--

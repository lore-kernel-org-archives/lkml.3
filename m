Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482AbaGIQl5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 12:41:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:60356 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755641AbaGIQlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 12:41:55 -0400
Date: Wed, 9 Jul 2014 18:41:46 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Liang, Kan" <kan.liang@intel.com>
Cc: "andi@firstfloor.org" <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH V4 1/2] perf ignore LBR and extra_regs.
Message-ID: <20140709164146.GH9918@twins.programming.kicks-ass.net>
References: <1404838181-3911-1-git-send-email-kan.liang@intel.com>
 <20140709141631.GE9918@twins.programming.kicks-ass.net>
 <37D7C6CF3E00A74B8858931C1DB2F077014D2005@SHSMSX103.ccr.corp.intel.com>
 <20140709145809.GG9918@twins.programming.kicks-ass.net>
 <37D7C6CF3E00A74B8858931C1DB2F077014D2729@SHSMSX103.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uJrvpPjGB3z5kYrA"
Content-Disposition: inline
In-Reply-To: <37D7C6CF3E00A74B8858931C1DB2F077014D2729@SHSMSX103.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uJrvpPjGB3z5kYrA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 09, 2014 at 03:43:45PM +0000, Liang, Kan wrote:
>=20
>=20
> > -----Original Message-----
> > From: Peter Zijlstra [mailto:peterz@infradead.org]
> > Sent: Wednesday, July 09, 2014 10:58 AM
> > To: Liang, Kan
> > Cc: andi@firstfloor.org; linux-kernel@vger.kernel.org; kvm@vger.kernel.=
org
> > Subject: Re: [PATCH V4 1/2] perf ignore LBR and extra_regs.
> >=20
> > On Wed, Jul 09, 2014 at 02:32:28PM +0000, Liang, Kan wrote:
> > >
> > >
> > > > On Tue, Jul 08, 2014 at 09:49:40AM -0700, kan.liang@intel.com wrote:
> > > > > +/*
> > > > > + * Under certain circumstances, access certain MSR may cause #GP.
> > > > > + * The function tests if the input MSR can be safely accessed.
> > > > > + */
> > > > > +static inline bool check_msr(unsigned long msr) {
> > > > > +	u64 value;
> > > > > +
> > > > > +	if (rdmsrl_safe(msr, &value) < 0)
> > > > > +		return false;
> > > > > +	if (wrmsrl_safe(msr, value) < 0)
> > > > > +		return false;
> > > > > +	return true;
> > > > > +}
> > > >
> > > > What does this thing return after patch 2? does the write still
> > > > fault or will KVM silently take writes too?
> > >
> > > If applying patch 2, the function will return true. The KVM just simp=
ly ignore
> > the reads/writes.
> >=20
> > OK, then that's broken too. We want a function to return false for any
> > malfunctioning MSR, ignoring writes and returning 0s is not proper
> > functioning.
>=20
> The patch 2 is to handle the case that the administrator can only
> patch the host. Don't need to force user to upgrade their guest to fix
> the crash.  And ignore the annoying "unhandled...." KVM messages

Sure; but what I meant was, check_msr() is broken when ran on such a
kernel. You need to fix check_msr() to return failure on these 'ignored'
MSRs, after all they don't function as expected, they're effectively
broken.

--uJrvpPjGB3z5kYrA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTvXDKAAoJEHZH4aRLwOS6xOQP/RZfbK8wM1exlNOqfR9B6C6I
GBGnEiPKdRo3b/v9J3QvYaEXucJ0WYHgCh0jyaDOzyte9VNVqFnVEBNjDy48Rzlx
UuOs1sQhojqjaWIbiU9PJDFlKxI3mW4gGitIha78225w9/UY/1c8Z1BO0trg/uTA
Phn3icoLuNUxuvMcgMrJxRUqLY5Bs7266BJeasZv4rllsOtfid+b3pSHn8gs3FSO
gYkIHZTKG6aLdWAQZNZ0DInXyBgd3RvdyLWTPVrjHI29chY2/uapfT+MImgmzWA6
EwfFou9y0m+p2ZcEIV6Q6w07agbkcSJk3+V6+K+Bmqbiwji68jrHdyAulBpysVEh
Z4VjtJ0TMOokCrytxkfldp+geDWRfwaeZSDKeyd167+X4LcUsC4VIZ3YYFmx0vnw
PozdJEcJ2gjDg/vWiyOOpzD1E/o6w7wiNQ21+Biu5aI8dozWrLvzSmb635WtRpvk
05Y89PDDTX/uj+oMEb8FQ4ta5mIfEGTFfMxZaSchwtMzDTTNDhoRZKnd7uEvqi5n
0RIWFIRDVzlPJ5Hb4orE1/98zGkv7J9wLjunSpSiXSgmLDAZ5RiMUdOm0X5HkcM1
Cw6SGCGpSyNyBjvtXVdzQfs9u3F4mmVMbQaXAsgOYo5fSx2h7aEf97RIIFI5MZ1k
p9yJEwiyT8tQpG08vkb+
=t01j
-----END PGP SIGNATURE-----

--uJrvpPjGB3z5kYrA--

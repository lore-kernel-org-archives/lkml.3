Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369AbaGNQ2x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 12:28:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:53067 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756189AbaGNQ2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 12:28:44 -0400
Date: Mon, 14 Jul 2014 18:28:33 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Liang, Kan" <kan.liang@intel.com>
Cc: "andi@firstfloor.org" <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH V5 1/2] perf ignore LBR and extra_regs
Message-ID: <20140714162833.GF9918@twins.programming.kicks-ass.net>
References: <1404989984-3068-1-git-send-email-kan.liang@intel.com>
 <20140714105341.GT9918@twins.programming.kicks-ass.net>
 <37D7C6CF3E00A74B8858931C1DB2F077014E1D5E@SHSMSX103.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="acY8GN8fvSPNWryy"
Content-Disposition: inline
In-Reply-To: <37D7C6CF3E00A74B8858931C1DB2F077014E1D5E@SHSMSX103.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--acY8GN8fvSPNWryy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


so once more; and then I'm going to route your emails to /dev/null, wrap
text at 78 chars.

On Mon, Jul 14, 2014 at 02:28:36PM +0000, Liang, Kan wrote:
> > > +++ b/arch/x86/kernel/cpu/perf_event.h
> > > @@ -464,6 +464,12 @@ struct x86_pmu {
> > >  	 */
> > >  	struct extra_reg *extra_regs;
> > >  	unsigned int er_flags;
> > > +	/*
> > > +	 * EXTRA REG MSR can be accessed
> > > +	 * The extra registers are completely unrelated to each other.
> > > +	 * So it needs a flag for each extra register.
> > > +	 */
> > > +	bool		extra_msr_access[EXTRA_REG_MAX];
> >=20
> > So why not in struct extra_reg again? You didn't give a straight answer=
 there.
>=20
> I think I did in the email.
> You mentioned that there's still (only) 4 empty bytes at the tail of
> extra_reg itself.  However, the extra_reg_type may be extended in the
> near future.  So that may not be a reason to move to extra_reg.

Well, you can always grow. Also be explicit, 'may be' is an empty
statement.

> Furthermore, if we move extra_msr_access to extra_reg, I guess we have
> to modify all the related micros (i.e EVENT_EXTRA_REG) to initialize
> the new items.  That could be a big change.

Nah, trivial stuff :-)

> On the other side, in x86_pmu structure, there are extra_regs related
> items defined under the comments "Extra registers for events".  And
> the bit holes are enough for current usage and future extension.
>=20
> So I guess  x86_pmu should be a good place to store the availability
> of the reg.

It just doesn't make sense to me to have multiple arrays of the same
thing.


--acY8GN8fvSPNWryy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTxAUxAAoJEHZH4aRLwOS64akP/1Z+weMABiuD4v7yor3JN+l/
BJATl4v0vtS14Vi9sDdx0ds1qxupN0a+sc5ssPAFpQkMG1tgHuqgxsx1o6KeIp1t
t1CJDzBFGBA05O3wYwUUlsKwYaaKn1cGwQWp/gtT9I5e8D9QSIGqXpv4wSQtYExc
3VzXLCZNtLgD+Sn8TVoQrIv9XH5revUoAKWfS+rJj8IuhswKjpkNKKY60qDCIRY9
S4QD+KNjOgFhPcu3qTLkwe75c5nLqCecypeUDPsSKjX+FG+qsVPa+QIiGFz7lqHb
SDMUfcBjtPdlJq18G2nmBsRBltY5ie+XRAZObEchtzPzRd9lnuAwekRUJHdgFV2Z
wjV9TLBTogIyK/sCH4ddfF8Rqh9F93keyyCFJMBiH4iun8Q/gN8cBZ/iILGzQUZU
cJl704clOof9qx9e8Pq7xo1ypTY3Otoc4jAYfpxnCSlp7tzxlKzafnQgJt+vn8l0
0F5sczpz1JMBoclkmBGdftFS8MBD7WvbxU3Hmxfgf+uiCvlnoVy4pmOls8SAACgi
VleIf0NqCL24vzTdBKJdH8tUgxb0ZHNrAtrCKFqdHd2owLnDSd3LgO9whVqVZo+F
3VW0T1u+uQXG4aJb/KtGqbjxx1zeaN2J7mLq+sOuY6UEOgehopT7f0TLW2xmMQQj
dG8Ps/i200FmyWI0Zf4J
=yedh
-----END PGP SIGNATURE-----

--acY8GN8fvSPNWryy--

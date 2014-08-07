Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757463AbaHGMLx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 08:11:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:46908 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757414AbaHGMLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 08:11:52 -0400
Date: Thu, 7 Aug 2014 14:11:37 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Fengguang Wu <fengguang.wu@intel.com>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: Re: [microcode/load_module] WARNING: CPU: 0 PID: 1444 at
 kernel/sched/core.c:7094 __might_sleep+0x51/0x16f()
Message-ID: <20140807121137.GT9918@twins.programming.kicks-ass.net>
References: <20140805211224.GA13480@localhost>
 <20140807104140.GN19379@twins.programming.kicks-ass.net>
 <87r40scy3k.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uezWbACgApK292Ml"
Content-Disposition: inline
In-Reply-To: <87r40scy3k.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uezWbACgApK292Ml
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 07, 2014 at 09:26:15PM +0930, Rusty Russell wrote:
> Peter Zijlstra <peterz@infradead.org> writes:
> > On Wed, Aug 06, 2014 at 05:12:24AM +0800, Fengguang Wu wrote:
> >> Greetings,
> >>=20
> >> Here is a microcode/load_module error triggered by debug check commit
> >> 64c2181bc433b17f04da8fe8592aa83cceac9606 ("sched: Debug nested
> >> sleeps"):
>=20
> Hmm, google lead me to that.  Yuck, that's subtle.

It is, hence it would be _good_ to have debug infrastructure to help
out.

> > +++ b/kernel/module.c
> > @@ -3094,6 +3094,28 @@ static int may_init_module(void)
> >  	return 0;
> >  }
> > =20
> > +int wait_finished_loading(struct module *mod)
> > +{
>=20
> Is this something we can generalize?  At least needs a comment on
> why we don't just use the normal wait_event_interruptible...

I've so far not generalized this because I feel (but maybe other people
feel differently) that we should not do these things if at all possible,
and thus we should not make it too easy.

But sure I can add a comment..

--uezWbACgApK292Ml
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT42z5AAoJEHZH4aRLwOS6JScQAJQ2cIAx98YsEnZZvZnzljHX
GMtcgwGPhoZRWx/SJIvV2wY+nomEcewypSn9sOjsS/0/xPza9KkaK+ubz2kbTijm
a3WZEvs/pbeYaH7mZq/PU3j5EgO7wAgwB0eA7ilnB9+OmGNag2e1ZUjwhS5lZhAN
2mi2Ij6pXNwcZOMGZ/BgbNvuMq0rkcrCZjQN89rBRpEeatJFuN2SoJ6o/0/hMylz
3x/Oin2SFPvDG05md3pDWHSXhD+c82MIbk9tmiH2r5TGOnrPsM9uDEycfZ86XA6N
8I04m98PEJL4xCUIQ/hMe/VHmKe/cryv5PcTKV1ZiYPT3e4X1giTACHwAxB6PLqZ
qXWm7X3878VblyNe8NMOI5hY/x1zYrJ9tcE8LP2klmwBS4QWdHogFgUP+qJI+3Ew
tqADZ07/b6ilRontPy3chf3d6nCeWhMZM6/v9UN2Mka7M/i7Ca6uj9zF0gxovASB
XdTo4JTS/fnxPJijXrP7LZ4ja8pzKnyu0xLITq72+IrhU3+tpoNwV/Deci6kf1Bx
NCFgT/BiBX8r8d3tPIp1xQWdBMmPvJVhTWophSFrKDPXaoyOpblxiWhZN9T3K8MR
SeAFfXfZ+9eXNCoFJRxHPGkInnEoN+uuSHBnGDapyJpc0hril3Nd/NUeD0MSP2mj
EaschQo4E8pQ3KUHtmY9
=vxw8
-----END PGP SIGNATURE-----

--uezWbACgApK292Ml--

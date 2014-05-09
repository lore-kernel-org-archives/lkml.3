Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932280AbaEIRCq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 13:02:46 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:42013 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757096AbaEIRCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 13:02:44 -0400
Date: Fri, 9 May 2014 19:02:34 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: James Hogan <james.hogan@imgtec.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "luto@amacapital.net" <luto@amacapital.net>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "umgwanakikbuti@gmail.com" <umgwanakikbuti@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Will Deacon <Will.Deacon@arm.com>,
        ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC][PATCH 6/8] sched,idle: Avoid spurious wakeup IPIs
Message-ID: <20140509170234.GZ30445@twins.programming.kicks-ass.net>
References: <20140411134243.160989490@infradead.org>
 <20140411135218.478299389@infradead.org>
 <CAAG0J9_q1KsUx10-XAb7AJnxv2ehctg6q1KME7ahsk1OZV8vZQ@mail.gmail.com>
 <20140509141520.GV2844@laptop.programming.kicks-ass.net>
 <20140509144034.GF7950@arm.com>
 <20140509145002.GW2844@laptop.programming.kicks-ass.net>
 <20140509145745.GI7950@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x+IuRATsqV0DV21e"
Content-Disposition: inline
In-Reply-To: <20140509145745.GI7950@arm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--x+IuRATsqV0DV21e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 09, 2014 at 03:57:45PM +0100, Catalin Marinas wrote:
> On Fri, May 09, 2014 at 03:50:02PM +0100, Peter Zijlstra wrote:
> > On Fri, May 09, 2014 at 03:40:34PM +0100, Catalin Marinas wrote:
> >=20
> > > I wonder why we still need TIF_POLLING_NRFLAG for arm64. It was on arm
> > > until commit 16a8016372c42c7628eb (sanitize tsk_is_polling()). On arm=
64
> > > we use wfi for idle or a firmware call but in both cases the assumpti=
on
> > > is that we need an interrupt for waking up.
> > >=20
> > > So I think we should remove this macro for arm64.
> >=20
> > Does ARM64 support idle=3Dpoll? If so, you could keep it for that,
> > otherwise it does indeed appear to be pointless.
>=20
> We don't support idle=3Dpoll either.
>=20
> > As to 32bit ARM, are there SMP chips which do not have WFI?
>=20
> No. WFI is even used for the secondary booting protocol (we need to send
> an IPI to get them going).

OK, so I'll queue a patch removing TIF_POLLING_NRFLAG for arm64.

Thanks!

--x+IuRATsqV0DV21e
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTbQoqAAoJEHZH4aRLwOS6NwUQAJHLxoKK86uQfqE8pLwdT7b9
HLu9bzMWYqSMYp2fCPDl1X0m/eKDWY2LdLZN7LauRPc+n4ZFq73bHpMT5Dcyulks
7dsHws/VBKfnc90emGp7mldtEr13u7fIspiTG0cPeQh1aAvcELZ+ucH/OkjQ1UA9
Yy8lba/VLv6Ck993CrDyLDJqLJyF5jmAJii6dGf/day4zZUrA95R43M+eDLv+fV2
1n9DFdzC2HT6/z23Hc6mij1RnuYLw+AbFV3+4W19lMXGijVpJgwrq2APsauZ/1+F
yxFgSGRDaJAfkz5qtrMOSL5NXvShco2H0Sj+b83wGhB+YuoIWdSWBIYbXoMkkeL1
uZ8xQyBwTO3Xa6H/g6lssurBSRXP/noZfP22kuY/1bWAWiSlG73MU9rDhCpfkcwY
gO9vpTv8XpbZIVxWVd9Ho0zv6w+gGsTlRk2FC/qSa7Qu34suVkOf0C4qiScDTUmw
Emf5YgWcpqTUf0cc864tgRX5yARefZlYqg3HP+fdHmvSUUsVkJ13Do4/rkiLQr40
RLcQUsXA7kE8KeeTjNqfiOPdok0wXW2ZMrh2wzYxIk7eguftQ5OoY6XkERrbmn+3
s1kwFRNrKvflL4VnDucXtcYJwnWO5YjMYT83J6kHKunm7gWKbgInSaK4R8c3d31i
TgC0gtdTLUC5jf6xVzIO
=nOE1
-----END PGP SIGNATURE-----

--x+IuRATsqV0DV21e--

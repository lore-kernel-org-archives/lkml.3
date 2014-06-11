Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257AbaFKLyW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 07:54:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:54217 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730AbaFKLyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 07:54:21 -0400
Date: Wed, 11 Jun 2014 13:54:13 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: acme@kernel.org, mingo@redhat.com, paulus@samba.org, hpa@zytor.com,
        tglx@linutronix.de, x86@kernel.org, linux-kernel@vger.kernel.org,
        matt@console-pimps.org
Subject: Re: [PATCH] perf/x86/intel: ignore CondChgd bit to avoid false NMI
 handling
Message-ID: <20140611115413.GE3588@twins.programming.kicks-ass.net>
References: <20140611073028.9847.65622.stgit@localhost6.localdomain6>
 <20140611085448.GI3213@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xJK8B5Wah2CMJs8h"
Content-Disposition: inline
In-Reply-To: <20140611085448.GI3213@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xJK8B5Wah2CMJs8h
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 11, 2014 at 10:54:48AM +0200, Peter Zijlstra wrote:
> > I'm not sure about exact behavior of CondChgd bit, in particular when
> > this bit is set. Although I read Intel System Programmer's Manual to
> > figure out but I have yet completed that. At least, I think ignoring
> > CondChgd bit should be enough for NMI watchdog perspective.
>=20
> So yes, the SDM lists the bit as existing but never once mentions it
> outside of that, and its been doing that at least back to 2008.
>=20
> Ooh, I found it:
>=20
>   "The IA32_PERF_GLOBAL_STATUS MSR also provides a =E2=80=98sticky bit=E2=
=80=99 to
> indicate changes to the state of performance monitoring hardware (see
> Figure 18-29)."
>=20
> Which is of course completely useless, not to mention inconsistent with
> the later CondChgd name.
>=20
> HPA, can you explain wtf that bit does and why hatayama-san's ivb feels
> like having that set on boot?=20

Matt found in the MSR listing for GLOBAL_STATUS:

63 CondChg: status bits of this register has changed.  If CPUID.0AH: EAX[7:=
0] > 0

Which brings us to a grand total of 3 different names for this bit.

If it indeed does what it says on the tin, set every time the status
changes its like the most useless bit ever and I wonder why people
bothered to spend silicon on it.

In any case, the proposed patch seems fine, just needs a better
changelog.


--xJK8B5Wah2CMJs8h
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTmENlAAoJEHZH4aRLwOS6PtsP/iArjTACyo6vXjSyn4/EX71Y
WO9IGp1ILvIFTurtrAjJ04P4Hqis0jEZSGh6JVq6BLeiRbdnbmxfdo+uTu1Scqsn
Ov7XrOCi17TYhTLyP6dFT1j9J6cpOqD6XVTmniP0cpHjCwVSNiqM3OHhPMnzLa5I
EeCzPDwfbnKGCBqxVREgupmbhHwDZnm66WY5/QLPOum/dPRUGalVL5+VjAcO3WL5
cbqna3PrIb5vP1W62DGtH25X2fksaBDLdgywErMG87xzlWXWmzSyHvNVt7eTA8FC
8pDEyiYgXYCDD/f10+FNdEu1xPAXthr77bQk0SoA0K+bQ1Qn+bf2U7gfHddQgVFq
rOk8im50P6lhUF73CJ4oWy4lOix90yuOf4BXVUeJccUTrihwbPUYb28gwEu0XunJ
9iynTSTiDt7j2Gr5dyoS/eMaWEKwudH34YqUV7gABWQetdh+GjNaV9mr+pvvEnrc
ib6PfSm8bNNimaiGEJViqVVS+t7BirA9sCwTm88wxYo55x9jokcek8H24GBGvbBI
e67/hV4PxRZSt376lff3RydT1BruS7Oi+XL7AukZ7WyXTAo5tElHQjh9vOPW9TLV
OYC8a20OBn76dQdGiZ5rVA6vfuvK+YOrw3i9qHMT5WZegJgbDZk9l3MeGIWfxjEn
KPtAskMHMCx3nVkKEMIT
=MGcM
-----END PGP SIGNATURE-----

--xJK8B5Wah2CMJs8h--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933574AbaEGNid (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 09:38:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:38089 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933123AbaEGNia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 09:38:30 -0400
Date: Wed, 7 May 2014 15:38:23 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched/clock: cleanup, remove wrap_{max|min}().
Message-ID: <20140507133823.GN30445@twins.programming.kicks-ass.net>
References: <1399463338-15507-1-git-send-email-yangds.fnst@cn.fujitsu.com>
 <20140507125548.GL30445@twins.programming.kicks-ass.net>
 <536A2143.5090106@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gdTfX7fkYsEEjebm"
Content-Disposition: inline
In-Reply-To: <536A2143.5090106@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gdTfX7fkYsEEjebm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 07, 2014 at 09:04:19PM +0900, Dongsheng Yang wrote:
> On 05/07/2014 09:55 PM, Peter Zijlstra wrote:
> >On Wed, May 07, 2014 at 08:48:58PM +0900, Dongsheng Yang wrote:
> >>I am not sure why we need the wrap_{max|min}() in kernel/sched/clock.c.
> >>But I checked the implementation of max() and min() in linux/kernel.h, =
I think
> >>we can reuse them here rather than introduce a new function named
> >>wrap_{max|min}().
> >wrap is a good hint there.. they're supposed to deal with the clock
> >wrapping. Of course 2^64 ns is a rather long time (~584 years in fact),
> >but that doesn't mean we shouldn't care.
> >
> >And no, min/max don't do the right thing.
>=20
> IMMO,  max() in kernel.h is checking and returning the u64 with typeof() =
if
> we are passing a u64 parameter to max(). And I checked current callers of
> wrap_max(),
> they are all passing parameters of u64 type. So I think max/min works well
> at
> the place of wrap_max/min().
>=20
> Maybe I am missing something here, please correct me if I understand it
> incorrectly.

Trivial test prog; you really should do these things yourself.

$ ./wrap
wrap_min: 18446744073709551615 wrap_max: 0
min:      0 max:      18446744073709551615


---
#include <stdint.h>
#include <stdio.h>

typedef uint64_t u64;
typedef int64_t  s64;

static inline u64 wrap_min(u64 x, u64 y)
{
        return (s64)(x - y) < 0 ? x : y;
}

static inline u64 wrap_max(u64 x, u64 y)
{
        return (s64)(x - y) > 0 ? x : y;
}

#define min(x, y) ({                            \
        typeof(x) _min1 =3D (x);                  \
        typeof(y) _min2 =3D (y);                  \
        (void) (&_min1 =3D=3D &_min2);              \
        _min1 < _min2 ? _min1 : _min2; })

#define max(x, y) ({                            \
        typeof(x) _max1 =3D (x);                  \
        typeof(y) _max2 =3D (y);                  \
        (void) (&_max1 =3D=3D &_max2);              \
        _max1 > _max2 ? _max1 : _max2; })

void main (void)
{
        u64 a =3D UINT64_MAX, b =3D a + 1;

        printf("wrap_min: %lu wrap_max: %lu\n", wrap_min(a, b), wrap_max(a,=
b));
        printf("min:      %lu max:      %lu\n", min(a, b), max(a,b));
}

--gdTfX7fkYsEEjebm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTajdPAAoJEHZH4aRLwOS6VPYP/332bY53AUii89uemAwUghQW
9agTsE4o84wtVm8v7M5Qj62bAboCI8kO2hz73t8oPQ1q5JsDIsqEri3fZeBKabtq
WyyEZ3ZYnfTr92CYt//9bRRfszE0Tm+ccMUGzCNmHGtrTAFslgbSu950LlqHJyGT
YinpGW9GaPx6PSzLDBg7N3jvI4aFtEb5FZFZdJAs1jaGezygAnijQXqSi2SjVBmH
a6ryavlDrpkzVaEOHHO52D/rWvSDlJwzWXUGpK7TDuoo6ylycsx2hFjetajPyFue
O08vqyCW1TOSA26BdeqfZoAkhg6/WAEFu+SFPPNEuvV+/unsjNHp38uqJ3CQOQSt
MdFNMnJ/911FjtzP6qcj2QFc/16YJ/vJt6Ip2e7DF21me7zIynskEqTw9wMlbZnQ
1J+R9rFsdU1WP8LTuMFtjBSnb82zuT5fv76Mnv5zjjgMAapkyrQTsY6CmODwb7JL
inEIo73xnEx+xTa914vop681S7OFCYYXZC2rXc0woVgssrkuxacHSpRAu9txZn0K
J17Qm52fMavS87Jf12UyS+DCLOaYY9/vfRIBQ/294cH1WkH6HP4O1wQiJLKhKIIP
XD2d6dCpaQXs0vRThJTqGSyen9gBxXKDfGh6WJLSqEzZ1jiDEVvC91B+6rY5+iCK
i5hEQ6yoP15mnSdQEkJ2
=FRtb
-----END PGP SIGNATURE-----

--gdTfX7fkYsEEjebm--

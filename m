Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab3BDCDj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 21:03:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47404 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753785Ab3BDCDh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 21:03:37 -0500
Date: Sun, 3 Feb 2013 20:03:16 -0600
From: Clark Williams <williams@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 2/2] sched/rt:  add a tuning knob to allow changing
 SCHED_RR timeslice
Message-ID: <20130203200316.63c15a79@riff.lan>
In-Reply-To: <20130203185709.GA22826@gmail.com>
References: <20130131135242.1b77b841@redhat.com>
	<20130203111025.GC11739@gmail.com>
	<20130203185709.GA22826@gmail.com>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/81kLhp_./PcudaTMfQ8OiIY"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/81kLhp_./PcudaTMfQ8OiIY
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sun, 3 Feb 2013 19:57:09 +0100
Ingo Molnar <mingo@kernel.org> wrote:

>=20
> * Ingo Molnar <mingo@kernel.org> wrote:
>=20
> > The first patch looks good, I've applied it.
>=20
> I've skipped this one after all, as it sometimes generates:
>=20
> include/linux/sched/sysctl.h:108:41: warning: =E2=80=98struct signal_stru=
ct=E2=80=99 declared inside parameter list [enabled by default]
>=20
> Sometimes doesn't built kernel/sched/auto_group.c. So those bits=20
> probably want to move into a separate sched/auto_group.h header=20
> or so.
>=20
> But, more fundamentally, I think sched.h should not include the=20
> new sched/sysctl.h file. The whole point is to move out bits=20
> from sched.h and decouple them from sched.h - to shrink sched.h=20
> in the long run.
>=20
> Thanks,
>=20
> 	Ingo

Ahh, you wanted to not only reduce the size of sched.h you want to
reduce the amount of code it brings in.=20

I'll go back to the drawing board. I'll pull the relevant code from
sysctl.h into auto_group.h, then I'll remove the include in sched.h.
Then I'll track down all the build failures from the above :).

Clark

--Sig_/81kLhp_./PcudaTMfQ8OiIY
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlEPFuQACgkQHyuj/+TTEp1gZwCffswao7YqefZKMJx3R8tIWd0j
FGEAoKvvcLzckYpxwXY8UhMzirqB5uM5
=0wOp
-----END PGP SIGNATURE-----

--Sig_/81kLhp_./PcudaTMfQ8OiIY--

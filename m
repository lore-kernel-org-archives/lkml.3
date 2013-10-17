Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762074Ab3JQB3S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 21:29:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34308 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760694Ab3JQB3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 21:29:17 -0400
Date: Thu, 17 Oct 2013 12:28:59 +1100
From: NeilBrown <neilb@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thierry Reding <thierry.reding@gmail.com>, Shaohua Li <shli@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the tip tree
Message-ID: <20131017122859.67432627@notabene.brown>
In-Reply-To: <20131016205207.GE10651@twins.programming.kicks-ass.net>
References: <1381949500-501-1-git-send-email-treding@nvidia.com>
	<1381949500-501-2-git-send-email-treding@nvidia.com>
	<20131016200645.GD10651@twins.programming.kicks-ass.net>
	<20131016201410.GA26785@twins.programming.kicks-ass.net>
	<20131017073100.2cab1ffa@notabene.brown>
	<20131016205207.GE10651@twins.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/G5SQwBbjfSLsitL8_axxwBS"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/G5SQwBbjfSLsitL8_axxwBS
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 16 Oct 2013 22:52:07 +0200 Peter Zijlstra <peterz@infradead.org>
wrote:

> Hey Neil;
>=20
> it looks like its one of your patches isn't it?
>=20
> http://www.spinics.net/lists/raid/msg44100.html
> http://www.spinics.net/lists/raid/msg44101.html
>=20
> Given that I can't find them in a lkml archive means nobody's ever seen
> those patches.
>=20
> Anyway; has that 3/3 patch ever been ran with lockdep enabled?=20

I always run with lockdep enabled, and I have done at least basic testing
(I've been on leave for a few weeks and don't remember exactly where I got
to).
And I haven't seen any lockdep reports.

>=20
> Stuff like:
>=20
> +	for (i =3D 0; i < NR_STRIPE_HASH_LOCKS; i++)
> +		spin_lock_init(conf->hash_locks + i);
>=20
> And:
>=20
> +static void __lock_all_hash_locks(struct r5conf *conf)
> +{
> +	int i;
> +	for (i =3D 0; i < NR_STRIPE_HASH_LOCKS; i++)
> +		spin_lock(conf->hash_locks + i);
> +}
>=20
> Tends to complain real loud.

Why is that?
Because "conf->hash_locks + i" gets used as the "name" of the lockdep map f=
or
each one, and when they are all locked it looks like nested locking??

the lock_all_hash_locks doesn't get called very often and my testing mustn't
have got that far.  I just tried something that would trigger the=20
"lock_all_device_hash_locks_irq" (as it is in the current version) and it
went "splat" just as you said it would.
Thanks.

Do you have a suggestion for how to make this work?
Would
    spin_lock_nested(conf->hash_locks + i, i)
do the trick?

Thanks,
NeilBrown

>=20
> This leaves one to wonder...=20
>   'fancy' locking scheme:1, validation effort:0
>=20


--Sig_/G5SQwBbjfSLsitL8_axxwBS
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUl89Wznsnt1WYoG5AQIJORAAr6WZOMbyEKHI5OHehZzlz/86aIi4cUAc
MuSk9cp3D0IqrxYsEtrDN5zn6bLFuFTeKez55rwLHmKRV3DQly/NjELek/sAe3Zz
c2VFpIb/VmtBb5TRqgLq6RiYDM3sZP/1lFDeLxf5Kdo1h3oPQqeEbXKv+YS1G9Bt
pUGu0u5g/2ouzQn+ckeOw7UnrV8e/MPcFRswuJu1UHOxRF92QvGaRaTFtklcGsTV
2OTnhdFQNrnKYXCs05qcDUsQv8m6wdCsWwmePGRGoLsxSIRtNJw3MccDrJcKSzFp
zcSlJ0qrQPj/52qhsWDSlN9E12xW87+/QOcQPmN2GaomPd2DeAkq/FXlE1aZVoEw
C1T7fWOEkdJruVxHSfRVUcHi9diWELnCR74+/AObhC0nePAKkdScW/fTPwZiMoED
E23OYsrVnKFn+hPVAhTBazFgoZNq319gawWBLRHTNNbZuJGGAZ69CEqKiD+/Ey2u
rBPx3KuDvT8WGDXPcQob0UhVT3Dk0I4PsT1LMw3FqVxUfNt5V/pwKYFiaz+/96Rh
XTAZW70nEPvGthbLxAam623WqQSLg6lJ4kqLvOEhWN5WaproRNYhV+UN/upHusQM
kxY0f+FT1k8uEvKHMap5HZqGrZfCJcktl05TERyqtYgZRm55L4sUfKXcIGvAd9mB
g4R0dT/AigQ=
=a57d
-----END PGP SIGNATURE-----

--Sig_/G5SQwBbjfSLsitL8_axxwBS--

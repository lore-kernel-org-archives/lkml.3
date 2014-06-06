Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674AbaFFHfU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 03:35:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:56134 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbaFFHfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 03:35:16 -0400
Date: Fri, 6 Jun 2014 09:35:12 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Pranith Kumar <pranith@gatech.edu>
Cc: linux-kernel@vger.kernel.org, tim.c.chen@linux.intel.com, davidlohr@hp.com,
        mingo@redhat.com
Subject: Re: [RFC PATCH 1/1] cleanup: use bool as return type for
 rwsem_is_locked
Message-ID: <20140606073512.GQ6758@twins.programming.kicks-ass.net>
References: <5390D7E1.7060606@gatech.edu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qd/SZIFVu+MYwfCR"
Content-Disposition: inline
In-Reply-To: <5390D7E1.7060606@gatech.edu>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qd/SZIFVu+MYwfCR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 05, 2014 at 04:49:37PM -0400, Pranith Kumar wrote:
> I see that there are functions like this which basically say:
>=20
> return 1 if true else return 0. Is it worth cleaning them up? Or is
> there any reason why this convention is followed?

Hysterical raisins, a lot of people learnt C before it grew bool,
including me.

> use bool as the return type. No reason for return type to be int.
>=20
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> ---

> diff --git a/kernel/locking/rwsem-spinlock.c b/kernel/locking/rwsem-spinl=
ock.c
> index 9be8a91..7374139 100644
> --- a/kernel/locking/rwsem-spinlock.c
> +++ b/kernel/locking/rwsem-spinlock.c
> @@ -20,7 +20,7 @@ struct rwsem_waiter {
>  	enum rwsem_waiter_type type;
>  };
> =20
> -int rwsem_is_locked(struct rw_semaphore *sem)
> +bool rwsem_is_locked(struct rw_semaphore *sem)
>  {
>  	int ret =3D 1;
>  	unsigned long flags;

Now, see that's a half arsed change, if you change the function return
value, you should also change the value we actually return, @ret above
to bool, and you should then also change the values used to 'true' and
'false'.

Now in general, I don't particularly like such superfluous changes, so
unless you can show that GCC actually generates better code, I'd prefer
to keep things as they are.

--qd/SZIFVu+MYwfCR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTkW8wAAoJEHZH4aRLwOS6to0P/1Ea+n2PK4j3rgowYyM6N6fD
NGDAwAc0h4CKGNnx/2ZT+EXW5Xp6+bdNYLNMbRM75Yb95qgSDngU9P7PJkvq2t9N
4MK5MQZRj6RaJfz+lzROadx7dioChgJ6jqb1Mte8VRWAAPZ14jZeQ0eQr21XwGEs
DKNY6KRRoeZpjQXBCXtF6h6n/JhtBVMlGiPS4okbEKMwtUKgT0ekGqnyD07UfrXB
/MsAlnTLPyElqAJAP1STish8RtPJTlQQZlKvxRR0PfZqhnHeViUuU7lPRHJDQB+P
cv0lCawQuV74vtJjQDTe/woDpEaVx8mKIl+CaOChsVVW0uuDff/iByyBGWTW9kTi
EG8hCVgRad9tN0x/Pu8YbinVV28jppFkNzEU0xj4ZM3WptKPdBOIrHGZy0Jo5nJ+
boD1CxhGxQcZgoW/17yY633R2PGzU/hUHUcq0ByCG3SsNV4GiIuiiVGBSh4SWA5X
C/5Zu3w7bCNgqoiq0DEzYrAoaOoEh+9ZdnkCnZKbqO3dD53Luthj2Stg9mRIPoPO
vRO62TtXXLee2pn6kN3YErB+tDyqPNZ/azzivA+3i5Xk6n/8J+UYO09df82sDoDE
kAiO43sp/WjkeyD0+6PIY7q4A/38YhO9BWF2alEg0UKNv55yvoUI61ACXJ1g8F2m
p91q29rq4e2yVDfqz8/V
=aA+M
-----END PGP SIGNATURE-----

--qd/SZIFVu+MYwfCR--

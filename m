Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751653AbaGALlw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 07:41:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:55175 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbaGALlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 07:41:51 -0400
Date: Tue, 1 Jul 2014 13:41:38 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/2] rcu: uninline rcu_lock_acquire() and
 rcu_lock_release()
Message-ID: <20140701114138.GQ6758@twins.programming.kicks-ass.net>
References: <20140630161837.GA15873@redhat.com>
 <20140630161849.GA15887@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3fquP/57BBR2yLsK"
Content-Disposition: inline
In-Reply-To: <20140630161849.GA15887@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3fquP/57BBR2yLsK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 30, 2014 at 06:18:49PM +0200, Oleg Nesterov wrote:
> +static inline void __rcu_lock_acquire(struct lockdep_map *map, unsigned =
long ip)
>  {
> +	lock_acquire(map, 0, 0, 2, 0, NULL, ip);
>  }

> +extern void rcu_lock_acquire(void);
> +extern void rcu_lock_release(void);
> +extern void rcu_lock_acquire_bh(void);
> +extern void rcu_lock_release_bh(void);
> +extern void rcu_lock_acquire_sched(void);
> +extern void rcu_lock_release_sched(void);

> diff --git a/include/linux/srcu.h b/include/linux/srcu.h
> index a2783cb..5c06289 100644
> --- a/include/linux/srcu.h
> +++ b/include/linux/srcu.h
> @@ -219,7 +219,7 @@ static inline int srcu_read_lock(struct srcu_struct *=
sp) __acquires(sp)
>  {
>  	int retval =3D __srcu_read_lock(sp);
> =20
> -	rcu_lock_acquire(&(sp)->dep_map);
> +	__rcu_lock_acquire(&(sp)->dep_map, _THIS_IP_);
>  	return retval;
>  }

Would an srcu_lock_acquire() not make sense here?

In any case, not wrong per se, just a consistency thing that stood out.

--3fquP/57BBR2yLsK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTsp5yAAoJEHZH4aRLwOS6QlkP/2lrqQN0UOU59x3jD7eZFfWb
ei1a3xbLhOA203WYAStrrHvM2X6rRNCTSHh1oipm+ZK/AOHkdwt8KMA7Ar8pnNR/
dWWS6+uVDetLS7MyhGR7nQz/lkyZMplAn04eQXK8iD+mR5yQtJN1NypaH1YyMbKX
8eGi9xovXr56Mq3qOawpqxdrLeDS+CPnRePFGvQEWqFmRDkewvqMTuC12OrqFipA
S8zm6OpgL55fyhLUZsrZatiN5ynIRdU/qFLv8y07oTFULcHA7QR2/inh/YW+7XQX
SgiGJkSOGU7bZ8EE3m8WEW0eUgiiRbopdD6FIhHU680/pDL5uDQ96OisKo5dDAF0
XqxmYVhLJOBNIE2Z7j1Xaq39OwDNCwQKY5ezyhupi9vfCkOfjNHbx8Jmucn5vJdQ
tPDGmtHNnqz6mRaslc+pAqVhx2nSLfmxwIaCITiC1/L7RByWhZE9scqazbeBqRR3
hzT/3r4+x1pDWHW0yVgMYfKKaNw7xbHjt/7qyi7wjTcL6DOhbR+CTFP2No7hVt8x
ZBt01p8cwYap7xlkf8BBgczY7YIVcSuaWufF8SdT7hDCtxcbThqCFfOxwcgRCDeo
w9mo3a+V1wU9kRkK+olnRXqpqHBkdlpdylCIr1GitAVToIOJCdSkB3B5a8dvL3l/
/lUErvVp55dtgE5G2Y26
=dVnW
-----END PGP SIGNATURE-----

--3fquP/57BBR2yLsK--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817AbaFKLiv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 07:38:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:54166 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718AbaFKLit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 07:38:49 -0400
Date: Wed, 11 Jun 2014 13:38:41 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Paolo Bonzini <paolo.bonzini@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Oleg Nesterov <oleg@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>
Subject: Re: [PATCH v11 09/16] qspinlock, x86: Allow unfair spinlock in a
 virtual guest
Message-ID: <20140611113841.GD3588@twins.programming.kicks-ass.net>
References: <1401464642-33890-1-git-send-email-Waiman.Long@hp.com>
 <1401464642-33890-10-git-send-email-Waiman.Long@hp.com>
 <20140611105402.GL3213@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C+ts3FVlLX8+P6JN"
Content-Disposition: inline
In-Reply-To: <20140611105402.GL3213@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--C+ts3FVlLX8+P6JN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 11, 2014 at 12:54:02PM +0200, Peter Zijlstra wrote:
> > @@ -252,6 +260,18 @@ void queue_spin_lock_slowpath(struct qspinlock *lo=
ck, u32 val)
> > =20
> >  	BUILD_BUG_ON(CONFIG_NR_CPUS >=3D (1U << _Q_TAIL_CPU_BITS));
> > =20
> > +#ifdef CONFIG_VIRT_UNFAIR_LOCKS
> > +	/*
> > +	 * A simple test and set unfair lock
> > +	 */
> > +	if (static_key_false(&virt_unfairlocks_enabled)) {
> > +		cpu_relax();	/* Relax after a failed lock attempt */
>=20
> Meh, I don't think anybody can tell the difference if you put that in or
> not, therefore don't.
>=20
> > +		while (!queue_spin_trylock(lock))
> > +			cpu_relax();
> > +		return;
> > +	}
> > +#endif /* CONFIG_VIRT_UNFAIR_LOCKS */
>=20
> If you're really worried about those upper 24bits, you can always clear
> them when you get here.

I don't think its a problem at all; flipping the static_key requires
stop_machine, which guarantees us that there are no spinlocks held. So I
think you can actually BUG_ON() the upper 24bits.

--C+ts3FVlLX8+P6JN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTmD/BAAoJEHZH4aRLwOS6CcQQALBCdTzxj+zytpwsKX0IPCTW
Ng1BKqkzdBryfbh/vpcKmcyO8q2L6tSEls6ZPYutjVRi4foN1eef9dVWc0KUQZ9g
yA/UOPi4nGXkHREUQIXfFluWyff/tpJ0MyGLM3ZzXrxdnYb1ULo+tg7YwuDna4uv
sD6/Wf1aJetEHckWChxZY2C9Eg0JUbnvsSSj9OOP8J9UMqwjXHWAmy2UTppzKZS1
ySNOyN86ekeYvWWGazpQB4CDhaeCBf3DlaFoe/PEsV+Q5BrvhHOuIrmmF77RfAC2
O/h85QwEPceLVEPG4N+DOLKjj83S29ye2XMlb2h/+t2bjUei9ZABOSp32tDTKx4y
x8D4idRs8nedqcbHw+FF4XgxommrnX7UQh0a7eJ+hT19jybkk9m2DfMk4hTPlIk/
y4wbQ7NQNOVDPbC40E+Lax4xQBeQLtoFLnJiXnvI2g8XhJJVtvusV1xw6YnlBmXd
8RmWzUI7M/hyqkCLGtIlYSBL6YEtxHYHaINpAVA3rPMDDDPGkWKtFyx8iD1mmJA8
xMvU87CSJIV7EVFC+PXVgNj6xGdtgjWEa9ZY/LqWFzF7vYNFwptXXwmPZTaNNR/w
B0SCWI4rUOQ3SxhuZIDfj/1IK18W1xRPob01nb20PNn7R4oPEHYoQbZ+MnEkAYmh
s1/ZFeFTGneNQ6sEu0oO
=Zf+L
-----END PGP SIGNATURE-----

--C+ts3FVlLX8+P6JN--

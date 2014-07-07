Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529AbaGGPVN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 11:21:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:50365 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbaGGPVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 11:21:10 -0400
Date: Mon, 7 Jul 2014 17:20:58 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Waiman Long <waiman.long@hp.com>, tglx@linutronix.de, mingo@kernel.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        paolo.bonzini@gmail.com, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, paulmck@linux.vnet.ibm.com,
        riel@redhat.com, torvalds@linux-foundation.org,
        raghavendra.kt@linux.vnet.ibm.com, david.vrabel@citrix.com,
        oleg@redhat.com, gleb@redhat.com, scott.norton@hp.com,
        chegu_vinod@hp.com
Subject: Re: [PATCH 10/11] qspinlock: Paravirt support
Message-ID: <20140707152058.GV6758@twins.programming.kicks-ass.net>
References: <20140615124657.264658593@chello.nl>
 <20140615130154.213923590@chello.nl>
 <539F6AD5.4070301@hp.com>
 <53A18000.8080909@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CD1rT0yj7A8qvce7"
Content-Disposition: inline
In-Reply-To: <53A18000.8080909@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CD1rT0yj7A8qvce7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 18, 2014 at 02:03:12PM +0200, Paolo Bonzini wrote:
> Il 17/06/2014 00:08, Waiman Long ha scritto:
> >>+void __pv_queue_unlock(struct qspinlock *lock)
> >>+{
> >>+	int val =3D atomic_read(&lock->val);
> >>+
> >>+	native_queue_unlock(lock);
> >>+
> >>+	if (val & _Q_LOCKED_SLOW)
> >>+		___pv_kick_head(lock);
> >>+}
> >>+
> >
> >Again a race can happen here between the reading and writing of the lock
> >value. I can't think of a good way to do that without using cmpxchg.
>=20
> Could you just use xchg on the locked byte?

I'll have to, indeed. This is racy.

--CD1rT0yj7A8qvce7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTurraAAoJEHZH4aRLwOS6woQQALa23vPO8qjDhhPYoIwHEwVa
TzdXCRTjA7apxOj3scM4040xy1HFRoRFNnLrl7EOcnawLX/lFaQn8Wj1ArbFoCh0
64HTmvRj3tRQBnfxlyd66crvh8qdL9qCvVe5V4dav1ZNJdaWfanU2tPxNoVe6x8E
CsgLd2XDcHcOkhv5Q/6rwUYdbZOqb2hUqtYfyv4OS7g4R+PmZ7BqP9GvAd0jacoc
j6/sL6MjOLUfwnrixV7oLsntbXGbGC5UsC8BXs4cUJQmGuc1+75xGjhsW3cEJiau
RxuM0NxD7z+veNHibgbM8k3orVFa5XjY5XJF1UH+PLt6+LKHDtOWBLQlil5xG/R3
SQLlc7xOT2rLaKUWGHywEinKTCS8H10BKQG4a/ArhIZuupCTuAkblX3CvjzEGDvk
wK0+XYqYTL3S5+MmzzgpnkXsJ8s4yftYSTa9JlMkIrFs8f2q+HpTyscKp3LFsOyD
afpouZ3FhHUfDxbiyTipUlS1MxnLe7xx4x4BF3FNay5FvVvtkj00Fqiz4m5DPMA4
Pwna6s/UxU2VHUORDvAVBGBPU8dEhPxE+PcX6XJqONdUtHHngb+o0aJeBVmyrXbP
ufBmxyfALJc97TarUcgOgDzko2ukJ3JCfrjGIU5aF2P2M3+Ya0jJsGxR2wuku4V2
TpP71x+Ql19Zx9ZmGJbU
=LQMv
-----END PGP SIGNATURE-----

--CD1rT0yj7A8qvce7--

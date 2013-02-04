Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237Ab3BDPyv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 10:54:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57177 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754435Ab3BDPyt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 10:54:49 -0500
Date: Mon, 4 Feb 2013 09:54:38 -0600
From: Clark Williams <williams@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.6.11-rt26
Message-ID: <20130204095438.41376edb@riff.lan>
In-Reply-To: <alpine.LFD.2.02.1302041537230.11905@ionos>
References: <alpine.LFD.2.02.1302041537230.11905@ionos>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/TlsHmUhMCMHG4=vpMA2pW4g"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/TlsHmUhMCMHG4=vpMA2pW4g
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 4 Feb 2013 15:58:26 +0100 (CET)
Thomas Gleixner <tglx@linutronix.de> wrote:

> Dear RT Folks,
>=20
> I'm pleased to announce the 3.6.11-rt26 release.
>=20
> Changes since 3.6.11-rt25:
>=20
>    1) Fix the RT highmem implementation on x86
>=20
>    2) Support highmem + RT on ARM
>=20
>    3) Fix an one off error in the generic highmem code (upstream fix
>       did not make it into 3.6.stable)
>=20
>    4) Upstream SLUB fixes (Christoph Lameter)
>=20
>    5) Fix a few RT issues in mmc and amba drivers
>=20
>    6) Initialize local locks in mm/swap.c early
>=20
>    7) Use simple wait queues for completions. This is a performance
>       improvement.
>=20
>       Completions do not have complex callbacks and the wakeup path is
>       disabling interrupts anyway. So using simple wait locks with the
>       raw spinlock is not a latency problem, but the "sleeping lock"
>       in the normal waitqueue is a source for lock bouncing:
>=20
>       T1  	 	   T2
>       lock(WQ)
>       wakeup(T2)
>       ---> preemption
> 			   lock(WQ)
> 			   pi_boost(T1)
> 			   wait_for_lock(WQ)
>       unlock(WQ)
>       deboost(T1)
>       ---> preemption
> 			   ....
>=20
>       The simple waitqueue reduces this to:
> 		  =20
>       T1  	 	   T2
>       raw_lock(WQ)
>       wakeup(T2)
>       raw_unlock(WQ)
>       ---> preemption
> 			   raw_lock(WQ)=09
> 			   ....
>=20
> @Steven: Sorry, I forgot the stable tags on:
> 	 drivers-tty-pl011-irq-disable-madness.patch
> 	 mmci-remove-bogus-irq-save.patch
> 	 idle-state.patch
> 	 might-sleep-check-for-idle.patch
> 	 mm-swap-fix-initialization.patch
>=20
> I'm still digging through my mail backlog, so I have not yet decided
> whether this is the last RT release for 3.6.
>=20
>=20
> The delta patch against 3.6.11-rt25 is appended below and can be found
> here:
>=20
>   http://www.kernel.org/pub/linux/kernel/projects/rt/3.6/incr/patch-3.6.1=
1-rt25-rt26.patch.xz
>=20
> The RT patch against 3.6.11 can be found here:
>=20
>   http://www.kernel.org/pub/linux/kernel/projects/rt/3.6/patch-3.6.11-rt2=
6.patch.xz
>=20
> The split quilt queue is available at:
>=20
>   http://www.kernel.org/pub/linux/kernel/projects/rt/3.6/patches-3.6.11-r=
t26.tar.xz
>=20
> Enjoy,
>=20
> 	tglx
>=20


Thomas,

I needed this change to build:

diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index efe4b33..3d5231f 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -26,6 +26,7 @@
=20
 #include <linux/errno.h>
 #include <linux/rbtree.h>
+#include <linux/wait.h>
=20
 struct vm_area_struct;
 struct mm_struct;


Clark

--Sig_/TlsHmUhMCMHG4=vpMA2pW4g
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlEP2b4ACgkQHyuj/+TTEp3f1ACfXFb5W0JcqOZSB8XPC9MGsX2h
TGsAnRxAQQB6yrvNDcKA+RD3AJ7cEqGg
=g+uT
-----END PGP SIGNATURE-----

--Sig_/TlsHmUhMCMHG4=vpMA2pW4g--

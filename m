Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751367AbaC1JzT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 05:55:19 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:58605 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbaC1JzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 05:55:17 -0400
Date: Fri, 28 Mar 2014 17:54:57 +0800
From: Kevin Hao <haokexin@gmail.com>
To: "Dongsheng.Wang@freescale.com" <Dongsheng.Wang@freescale.com>
Cc: "fweisbec@gmail.com" <fweisbec@gmail.com>,
        James Hogan <james.hogan@imgtec.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Peter Zijlstra <peterz@infradead.org>, Helge Deller <deller@gmx.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@au1.ibm.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Jason.Jin@freescale.com" <Jason.Jin@freescale.com>,
        Scott Wood <scottwood@freescale.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Ingo Molnar <mingo@kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH] powerpc/irq: Remove HAVE_IRQ_EXIT_ON_IRQ_STACK feature
 at powerpc platform
Message-ID: <20140328095457.GC2176@pek-khao-d1.corp.ad.wrs.com>
References: <1395992312-23035-1-git-send-email-dongsheng.wang@freescale.com>
 <20140328081827.GB2176@pek-khao-d1.corp.ad.wrs.com>
 <98283b6c8da549479d924d99d2b6d300@BN1PR03MB188.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jy6Sn24JjFx/iggw"
Content-Disposition: inline
In-Reply-To: <98283b6c8da549479d924d99d2b6d300@BN1PR03MB188.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jy6Sn24JjFx/iggw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 28, 2014 at 09:00:13AM +0000, Dongsheng.Wang@freescale.com wrot=
e:
> Thanks Kevin. Your patch works normal. :)
>=20
> I still have some confused. I think when __do_softirq always get a interr=
upt, the hard stack will be run out, isn't it?

No, it won't. Please see the explanation in the following commit log.

commit cc1f027454929924471bea2f362431072e3c71be
Author: Frederic Weisbecker <fweisbec@gmail.com>
Date:   Tue Sep 24 17:17:47 2013 +0200

    irq: Optimize softirq stack selection in irq exit
   =20
    If irq_exit() is called on the arch's specified irq stack,
    it should be safe to run softirqs inline under that same
    irq stack as it is near empty by the time we call irq_exit().
   =20
    For example if we use the same stack for both hard and soft irqs here,
    the worst case scenario is:
    hardirq -> softirq -> hardirq. But then the softirq supersedes the
    first hardirq as the stack user since irq_exit() is called in
    a mostly empty stack. So the stack merge in this case looks acceptable.
   =20
    Stack overrun still have a chance to happen if hardirqs have more
    opportunities to nest, but then it's another problem to solve.
   =20
    So lets adapt the irq exit's softirq stack on top of a new Kconfig symb=
ol
    that can be defined when irq_exit() runs on the irq stack. That way
    we can spare some stack switch on irq processing and all the cache
    issues that come along.
   =20
Thanks,
Kevin

--jy6Sn24JjFx/iggw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQEcBAEBAgAGBQJTNUbxAAoJEJNY7TDerrFxcQ8IAIhRsb+6usiUbeZBnn3wwWDB
/ki+dXC8WPsWiJ6U3sjGUtX61FEziOTKfCfQRDDvnxkJc1L/DjLkw9dMSrm8dRtP
gT1lC+0X5Srt+9tlgP7/nkay73zaTmNiTlkDT8jVFUBe1mxX4qfN4acJMs0eqPEq
tf3otxx0/uPsfFjanqYC6MIsVLCqHYOMakbcVBuG8neTL89Hyf7hh6o4JqM2V3dd
AoX/WI+0/N4KnFqHLXB1ubfuUBlsMW99vnuu7xXOS0a7S05f+q97bvbtrEf8vGlt
jRIozup1lrchQnGLkKR7khEuMNYetDcSBnpNwwzie0pT9CS6iWYT0KknmUpIaH0=
=r0/f
-----END PGP SIGNATURE-----

--jy6Sn24JjFx/iggw--

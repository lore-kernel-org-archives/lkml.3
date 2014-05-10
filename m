Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316AbaEJOOq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 10:14:46 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:41462 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754595AbaEJOOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 10:14:44 -0400
Date: Sat, 10 May 2014 16:14:17 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Waiman Long <waiman.long@hp.com>
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
Subject: Re: [PATCH v10 08/19] qspinlock: Make a new qnode structure to
 support virtualization
Message-ID: <20140510141417.GF30445@twins.programming.kicks-ass.net>
References: <1399474907-22206-1-git-send-email-Waiman.Long@hp.com>
 <1399474907-22206-9-git-send-email-Waiman.Long@hp.com>
 <20140508190459.GQ2844@laptop.programming.kicks-ass.net>
 <536D7C28.8010609@hp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wAzLpv+i5/B57lit"
Content-Disposition: inline
In-Reply-To: <536D7C28.8010609@hp.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wAzLpv+i5/B57lit
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 09, 2014 at 09:08:56PM -0400, Waiman Long wrote:
> On 05/08/2014 03:04 PM, Peter Zijlstra wrote:
> >On Wed, May 07, 2014 at 11:01:36AM -0400, Waiman Long wrote:
> >>  /*
> >>+ * To have additional features for better virtualization support, it is
> >>+ * necessary to store additional data in the queue node structure. So
> >>+ * a new queue node structure will have to be defined and used here.
> >>+ */
> >>+struct qnode {
> >>+	struct mcs_spinlock mcs;
> >>+};
> >You can ditch this entire patch; its pointless, just add a new
> >DEFINE_PER_CPU for the para-virt muck.
>=20
> Yes, I can certainly merge it to the next one in the series. I break it o=
ut
> to make each individual patch smaller, more single-purpose and easier to
> review.

No, don't merge it, _drop_ it. Wrapping things in a struct generates a
ton of pointless change.

Put the new data in a new DEFINE_PER_CPU and leave the existing code as
is.

--wAzLpv+i5/B57lit
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTbjQ5AAoJEHZH4aRLwOS64wQP/0002SaN/jwx76ECS+ue690X
C0xZkGN7vUQF4Ix5fwRw+JYn5LEYc2IEuel8DFuLqbHtd8MNfw5oq8jpgLHitAv6
LUFCJZkzJvm5vcYQCaRfSGLpytv2SQVuWKh/FMmdfeszVajr6Djkku8t3kAzaW6y
c/1auuyMfkuful5C0M4jhexkWwzLwNFTHAfPw6r1RtIgLzSaXDkOWBwzAvhd3Afc
5kNKAsmTh0qt+9A/CiM8ePSmEe8ia2kdJAdmhTxceZb1kHyhGxzq/VBBQbOnc43C
KxcuTzZ5V97oEIRGv5qCUjQIPgY13zS07ZOygDckmJs8ghq/7n6GB0T9vGSQKYBW
M7K1BLohbXvCRUv3NFdQRUlxW3VIdxSOHQCrxwMJqCHy4E5AWCkzGoXvUVyH6JtI
bNXUNowoaTeVergoIVuCwPBc2yDZF3s9nsztsELCku83gYzqAmspQHKrWk8GLj3U
7dD2WWRvRUVC9BjmBPEC8aw53v4RgfbWVFKCPP+Q6ASnDl2al6dcWPhGNvorOJ8h
C17JTjpbps5L9Cu4dDNXA3RyPc/BLFdYxgDY6KpoZ6QJ5Cgj2CAUeA6HXHRXMJwh
Yd5anmPSp1s9W6ZQER7vW9e3sIN7pSo1TkGE6G9DSvhIZ9GKbM57iIHY/5UMTDRy
dynOQf2yrpcbePFsO4qp
=X1fx
-----END PGP SIGNATURE-----

--wAzLpv+i5/B57lit--

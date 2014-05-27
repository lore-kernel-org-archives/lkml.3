Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752301AbaE0K3V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 06:29:21 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:50823 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbaE0K3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 06:29:20 -0400
Date: Tue, 27 May 2014 12:29:09 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Mel Gorman <mgorman@suse.de>,
        Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Mike Marciniszyn <infinipath@intel.com>
Subject: Re: [RFC][PATCH 0/5] VM_PINNED
Message-ID: <20140527102909.GO30445@twins.programming.kicks-ass.net>
References: <20140526145605.016140154@infradead.org>
 <CALYGNiMG1NVBUS4TJrYJMr92yWGZHSdGUdCGtBJDHoUMMhE+Wg@mail.gmail.com>
 <20140526203232.GC5444@laptop.programming.kicks-ass.net>
 <CALYGNiO8FNKjtETQMRSqgiArjfQ9nRAALUg9GGdNYbpKru=Sjw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="826Xtdr1Gsw3jzUq"
Content-Disposition: inline
In-Reply-To: <CALYGNiO8FNKjtETQMRSqgiArjfQ9nRAALUg9GGdNYbpKru=Sjw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--826Xtdr1Gsw3jzUq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 27, 2014 at 12:49:08AM +0400, Konstantin Khlebnikov wrote:
> On Tue, May 27, 2014 at 12:32 AM, Peter Zijlstra <peterz@infradead.org> w=
rote:
> > Pretty much, that's adequate for all users I'm aware of and mirrors the
> > mlock semantics.
>=20
> Ok, fine. Because get_user_pages is used sometimes for pinning pages
> from different mm.

Yeah, but that's fairly uncommon, and not something we do for very long
times afaik.

In fact I could only find:

  drivers/iommu/amd_iommu_v2.c

  fs/exec.c -- temporary use
  kernel/events/uprobes.c -- temporary use
  mm/ksm.c -- temporary use
  mm/process_vm_access.c -- temporary use

With exception of the iommu one (it wasn't immediately obvious and I
didn't want to stare at the iommu muck too long), they're all temporary,
we drop the page almost immediately again after doing some short work.

The things I care about for VM_PINNED are long term pins, like the IB
stuff, which sets up its RDMA buffers at the start of a program and
basically leaves them in place for the entire duration of said program.

Such pins will disrupt CMA, compaction and pretty much anything that
relies on the page blocks stuff.

> Another suggestion. VM_RESERVED is stronger than VM_LOCKED and extends
> its functionality.
> Maybe it's easier to add VM_DONTMIGRATE and use it together with VM_LOCKE=
D.
> This will make accounting easier. No?

I prefer the PINNED name because the not being able to migrate is only
one of the desired effects of it, not the primary effect. We're really
looking to keep physical pages in place and preserve mappings.

The -rt people for example really want to avoid faults (even minor
faults), and DONTMIGRATE would still allow unmapping.

Maybe always setting VM_PINNED and VM_LOCKED together is easier, I
hadn't considered that. The first thing that came to mind is that that
might make the fork() semantics difficult, but maybe it works out.

And while we're on the subject, my patch preserves PINNED over fork()
but maybe we don't actually need that either.

--826Xtdr1Gsw3jzUq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJThGj1AAoJEHZH4aRLwOS6qeYQAJ3hOt1U/4mdeHHc5s7OO1ZD
8oKxe2N4xrTIXOvgaNh92BuOHmvMiyubfFazcodMKmK3k/VCBL2LIHrmc5i51qv2
YOFac2y9gxLWepuirYReOv+WDqQ0cfbgY0kCyu716nCzSf2FjrQpiU/yOY6but+2
hqnVIvQzWivqZQ+nGT9mcspRRI0vLzM3vdfpLVbJiG7QwfBMK6br2ZLTEhcuYrS5
Np02JoOuLqyQHWIDXcXRqVjTsgSXufKg4LNqgc5jSURml7QBY+Ny8FxSovk7pCrL
ofS99l35nj2RYOLCfWn6hrmQDcuosOlG0bYGcWACSNcPULwYHuorUUOYSHXwAWm1
fwdxX2i1ekq9jiyHFamHsBidpjKLXcPd1RYOx+lF0XhAdrnY6/2n4TTZW5ckbON2
8QUQ9ISXc6bNMJBPC296wyF5tc16R+hnQBzdTUNVhsVgcBuiS3Z8XbXtym2cVto0
LDBVXqj15b2Gy0o9fFRWeXdRM5/vM4LclNimL0iVOahc3Q2Dqw7hDAboJAA7cYDY
ljSQ6zRiS6uAN4GdWozhpUIHE+6HcUsjR7WJlDCltlSOirMkFC1T12TspLQ0HnfS
x9ypJk0DUdxtrBtBvGyBgGsji1frOsYJqrPl4A9VFIKs+fPQHjPJBz2v0juiiuQG
Px3YPxUAad2jTRA3Ht4N
=GnLf
-----END PGP SIGNATURE-----

--826Xtdr1Gsw3jzUq--

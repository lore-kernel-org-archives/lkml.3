Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672AbaFFH3a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 03:29:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:56103 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655AbaFFH32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 03:29:28 -0400
Date: Fri, 6 Jun 2014 09:29:24 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Pranith Kumar <pranith@gatech.edu>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: regarding use of various cmpxchg* API
Message-ID: <20140606072924.GP6758@twins.programming.kicks-ass.net>
References: <5390F2D5.909@gatech.edu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vzUQzca511KWT6Hk"
Content-Disposition: inline
In-Reply-To: <5390F2D5.909@gatech.edu>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vzUQzca511KWT6Hk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 05, 2014 at 06:44:37PM -0400, Pranith Kumar wrote:
> Hi Peter, Ingo,
>=20
> I see that in the drivers there are the following types of cmpxchg API:
>=20
> __cmpxchg64()

That shouldn't really be used, and its only used in intel-iommu.c.

> atomic_cmpxchg()
> atomic64_cmpxchg()
> atomic_long_cmpxchg()

They're part of the atomic*_t family and should be used on their
respective types, no point in changing that.

> local_cmpxchg()(in kernel/events/ring_buffer.c)

This is part of the local_t API, also no real point to change that.

> this_cpu_cmpxchg()

This is part of the this_cpu*() family, and there's no way you can
generate the same code using the below to.

> cmpxchg()
> cmpxchg_local()

Which leaves these, which are used in all other cases.

> Since cmpxchg() internally handles the width, do you think it makes
> sense to replace the above uses of cmpxchg with the document API
> (cmpxchg, atomic_cmpxchg, cmpxchg_local)?
>=20
> I am willing to do this and wanted to know if it something you think
> is worth pursuing.

Don't think that's useful. If you really want to go do something, try
the annotation I suggested to get the parisc/sparc32 things correct
again. Add the __atomic sparse address space and the store()/load()
accessors.

--vzUQzca511KWT6Hk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTkW3UAAoJEHZH4aRLwOS6O1oP/iPeYJi6gzGCIZr3x3gG66iL
6IxE46ETiIIB5FdNg2MYvbh5Fa2gWIpXB/hkRDgBu9Q/RvycmAHLM7PUxaWVTv0s
mg1LM7V6/EwnUbW//Yn/e1XZWmtPlKeJZmFkS7VlNukc4f/UUiA8ib7m1HgK1dXb
F7Y5Q1KU477FnUfAb1rPabuv2Rir9WRuRu96NP2nPIMqGX4KqZS2E0vYVkxi7YWA
8zg9uBOkLKzjNCvJ1mWuOzJcGmeDhKrwoeAo3H1r+LZDc9CUqLAm8nEPru6W1vq6
YLenpbpXfz0pVnrYT30S/3Xs3o0unCe+5JQS0RFrssPNY0AOxZPkpe198+HjC+P4
kJIC8KMgZfFD0bT9fOn8ty/fbv1oeFfiqThgVkfdJET3YYSjhzZeoa1JRP8uqoT7
lN3AcX7iUnrXVd3QBDsl1lN4Wv8uvhdafwKDLEvjUbgmpjmq2J1xFCxHcBwcX08m
6+tBPS8XtNX+jWL7AWf9a0CmwJgP8PHBaa6h0uR6xGPI5KoaIsfsD5AdIUiUPnb1
LUu23QUpdwWWB/d8R376YfI2EqC5lIx9y9AcMAU5r9+jaj/KbUNePjpeP+0us73F
GNR7+nGjrgXSKx0nntAoU0IJCRJVadhwhXVpZ/yt0AiSZDMke8zIyudBHvl62Fwb
TvjNJdVX81xwxSvvBzta
=aZEi
-----END PGP SIGNATURE-----

--vzUQzca511KWT6Hk--

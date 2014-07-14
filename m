Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377AbaGNKQv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 06:16:51 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:34391 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755316AbaGNKQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 06:16:26 -0400
Date: Mon, 14 Jul 2014 12:16:11 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "H. Peter Anvin" <hpa@zytor.com>,
        "David S.Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Chandramouli Narayanan <mouli@linux.intel.com>,
        Vinodh Gopal <vinodh.gopal@intel.com>,
        James Guilford <james.guilford@intel.com>,
        Wajdi Feghali <wajdi.k.feghali@intel.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 6/7] sched: add function nr_running_cpu to expose
 number of tasks running on cpu
Message-ID: <20140714101611.GS9918@twins.programming.kicks-ass.net>
References: <cover.1405074379.git.tim.c.chen@linux.intel.com>
 <1405110784.2970.655.camel@schen9-DESK>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2z7AKWNQ4hR/M4ga"
Content-Disposition: inline
In-Reply-To: <1405110784.2970.655.camel@schen9-DESK>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2z7AKWNQ4hR/M4ga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 11, 2014 at 01:33:04PM -0700, Tim Chen wrote:
> This function will help a thread decide if it wants to to do work
> that can be delayed, to accumulate more tasks for more efficient
> batch processing later.
>=20
> However, if no other tasks are running on the cpu, it can take
> advantgae of the available cpu cycles to complete the tasks
> for immediate processing to minimize delay, otherwise it will yield.

Ugh.. and ignore topology and everything else.

Yet another scheduler on top of the scheduler.

We have the padata muck, also only ever used by crypto.
We have the workqueue nonsense, used all over the place
And we have btrfs doing their own padata like muck.
And I'm sure there's at least one more out there, just because.

Why do we want yet another thing?

I'm inclined to go NAK and get people to reduce the amount of async
queueing and processing crap.

--2z7AKWNQ4hR/M4ga
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTw63rAAoJEHZH4aRLwOS6jycP/iXJe7qpHcGSEWhGMxv6LdnH
Bggi9SzB5e9sbcYm73ZxQAbZl1LZUTjH3cSv64nETbizo+xFSRmtQlhMEKukXOS2
uD/aBaEE0s5QjQ5GVEIat+EwDh1OZYpLS2YWzN65B3NVijGAnX1cgHaqgyjdEP00
aXdq1ySnjz6THZJhki8KNDqfkxeJXlA1UAW//wyLOue8mt9NbTJqh/Edy4WHU3dE
jLBgn/Cclo5Txk3yxAr4otpbvc0PMBmQvwTspvExBXh8b+DUAh7LaZjYMFKVqYrl
hD9zz8HrXe7wZlAxjIGoxVBFm7rDdl+9So8DK/Keu6SjEclNjK0WqM/PrKFs8G+R
YdhmdrqNlZHlxuIvtG0ki9jzoGL45tm2XoOvIZH098EUzlhosL/BmM+E/FKWlYD3
lqhlAe26Ve8HsDCmpDwrYo2cWl/lPiHJV7wJ+MYNBl9eMrWzqJGyrRkHlwlLMPUN
HxEureNThJ4U1DgSRYqiuFTDYms03JwB5Ysa1RVVdCb2yOZvog4iT7nHPCiZ85pQ
NOKGqCtGBsbvvKjgCZJbNgIXhoPE1ZVmMUA/UZId5pSkuni9VGo61gb6zk7J4jLD
lSWefTsfXM0ytW5wIqhI8D/XjYc86RYXU3yW2dGiowpSpzXVcxvwq23BJBtsmKc8
j7/6q38LtoGlzk52zybs
=EROs
-----END PGP SIGNATURE-----

--2z7AKWNQ4hR/M4ga--

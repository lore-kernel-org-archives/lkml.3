Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744AbaGNSSB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 14:18:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:53452 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbaGNSRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 14:17:52 -0400
Date: Mon, 14 Jul 2014 20:17:38 +0200
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
Message-ID: <20140714181738.GI9918@twins.programming.kicks-ass.net>
References: <cover.1405074379.git.tim.c.chen@linux.intel.com>
 <1405110784.2970.655.camel@schen9-DESK>
 <20140714101611.GS9918@twins.programming.kicks-ass.net>
 <1405354214.2970.663.camel@schen9-DESK>
 <20140714161432.GC9918@twins.programming.kicks-ass.net>
 <1405357534.2970.701.camel@schen9-DESK>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UrGtnQA9R6QcIU0f"
Content-Disposition: inline
In-Reply-To: <1405357534.2970.701.camel@schen9-DESK>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UrGtnQA9R6QcIU0f
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 14, 2014 at 10:05:34AM -0700, Tim Chen wrote:
> I was trying to explain why the algorithm is implemented this way
> because of its batching nature.
>=20
> There is a whole class of async algorithm that can provide
> substantial speedup by doing batch processing and uses workqueue.
> The multi-buffer sha1 version has 2.2x speedup over existing
> AVX2 version, and can have even more speedup when AVX3=20
> comes round.  Workqueue is a natural way to implement=20
> this.  I don't think a throughput speedup of 2.2x is "crap".
>=20
> We are not inventing anything new, but ask for a=20
> very simple helper function to know if there's something else
> running on our cpu to help us make a better decision=20
> of whether we should flush the batched jobs immediately.
>=20
> And also asynchronous crypto interface is already used substantially
> in crypto and has a well established infrastructure. =20

The crap I was talking about is that there's a metric ton of 'async'
interfaces all different.

Your multi-buffer thing isn't generic either, it seems lmiited to sha1.
It does not reuse padata, it does not extend workqueues, it does not
remove the btrfs nonsense, it adds yet anotehr thing.

--UrGtnQA9R6QcIU0f
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTxB7CAAoJEHZH4aRLwOS606UQAKElNTYpWF7yo/ar86mVWM2d
dgWTcSd1CrvNAMMHGSgyDVZdnU+SFJFDbg7Rp/zlzx4hTLB7tjh4vIYzSOx7G8H+
E1yYXrOksltzNo1Bxcn7R7hsd1vRV29ePTllV47blLpmZn/6EiOrY74KKZWisf8/
4B5DwuCNNFVVNBsqzbbdJHygmvSGkmtlvEKmQpBnQwwZQeSbPrAU+4sGl7cerWdM
o7uMCevEdcgrio3HS27xFBHa8vpN9Zyj6F0o89o8lIXZKSV+LrfUAzT7FauJSl+2
2su25b3TPVJSjkRF0L8tGUj8ApP0BGv0m2WYM57Gk2JwATZYHcDWB+ClE1y6P5xi
S9rvSOQwYkW0q1PCA2m5PwYXT8swUw8s5Jv04ZAOfF0GhMtpP0JCvQCBBXMGKB1T
KVl19ahfp4/BzZaveNMZcI6lLls5NSOfH5RLIfG9J/FEO9PDQ0FWap2EfBKKRQsz
5aoY6lhejqqCUK7kA/PuvTBfqIWeWVPBhN571oIm4fpsyFc2Hw6p5PpU+79aXUXX
RbhlnmWlvXUvL2yVcIVIq6DZjvRxT98zy1DAoRQqNkrjLTkD1obK0dFT8b6NE72O
9LUQllmC/TpP+WRkQ+KxiCw4V/175CP/b459DvKjPuIFKzl3rIjhyIz9U8/z2CY8
52BLl1xdz3bJ9od6V+K+
=Q30h
-----END PGP SIGNATURE-----

--UrGtnQA9R6QcIU0f--

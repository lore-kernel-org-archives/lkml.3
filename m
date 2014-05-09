Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458AbaEIJpu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 05:45:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:48279 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174AbaEIJpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 05:45:49 -0400
Date: Fri, 9 May 2014 11:45:43 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: riel@redhat.com
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, mgorman@suse.de,
        chegu_vinod@hp.com
Subject: Re: [PATCH 1/4] numa,x86: store maximum numa node distance
Message-ID: <20140509094543.GP30445@twins.programming.kicks-ass.net>
References: <1399569811-14362-1-git-send-email-riel@redhat.com>
 <1399569811-14362-2-git-send-email-riel@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IGPMjTREWkoKVnU2"
Content-Disposition: inline
In-Reply-To: <1399569811-14362-2-git-send-email-riel@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IGPMjTREWkoKVnU2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 08, 2014 at 01:23:28PM -0400, riel@redhat.com wrote:
> From: Rik van Riel <riel@redhat.com>
>=20
> Store the maximum node distance, so the numa placement code can do
> better placement on systems with complex numa topology.
>=20
> The function max_node_distance will return LOCAL_DISTANCE if the
> system has simple NUMA topology, with only a single level of
> remote distance.
>=20
> Signed-off-by: Rik van Riel <riel@redhat.com>
> Tested-by: Chegu Vinod <chegu_vinod@hp.com>
> ---
>  arch/x86/include/asm/topology.h |  3 +++
>  arch/x86/mm/numa.c              | 25 +++++++++++++++++++++++++
>  include/linux/topology.h        |  3 +++
>  3 files changed, 31 insertions(+)
>=20

Why are you doing this in arch code? I would've expected some extra code
to sched_init_numa() which is generic code that analyses the distance
table and reconstructs the actual topology from it.

--IGPMjTREWkoKVnU2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTbKPHAAoJEHZH4aRLwOS6zx0P/14Xl9BBo8Xo1TZQ9ISIBE3X
oLa8L/T6B6Apn6yrMUJmdO3M2z9SAJ+hizbG+7jn7veBtOVYwod+LTZBIJf24Kqr
sFyYDGE5CGTp8hsJ+w+ohXoRgt3UXwI48Wpk0TUaOBMxVLA6+S61/IpsUfGTaQN2
Txf0Xek5m3INW+kiB8MLOjEtH/fP53DKOzwVVWVlv3V8JdlRczxEjHIwkeXGyPS3
n+5t757BLXxCOV9rsRA9sJ7ok/I+8wkq2qp0px/V9CnWSqP2Qm1BEAurB7s9xn1k
qzIW3K3NGtyeqAJmSmIyOwpOUwNk9K3JUZq1WSmQiszLdzvEFV4qpbCqmgCYdpYD
rtYLRniOQz+TT7Ypbcop0zxNCwaXfADCbczwkU7jlHjPMknxFgSAVo5p4upBPHxG
07zt/WzroUR1iGqFb1mEye6yYuj/ZNIYp/DaQ2v8cLsGDafFCd+yYjkjJwTRPrrd
dNhqjDvSh6FH7LZBnyKp3o/hdsQAtyaF1M8bSz+TKoHGIxWkuXuLUbvBmw4AZN2x
JRsq4+XPBjdQZeUZNo+C87VSwoj16u2zD8p/fwrHfu+6b5In+YZSj4k/NlVgB9Na
OF4OwJa1yiB72p7VLKRBksO+wTNXUE8wvCvG0y97J2vOtE9N5NpqCeT4aDTtT2DU
BuhwHNcCHDl5sPekRm9Z
=811B
-----END PGP SIGNATURE-----

--IGPMjTREWkoKVnU2--

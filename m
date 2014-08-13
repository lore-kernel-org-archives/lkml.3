Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751698AbaHMLLa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 07:11:30 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:32851 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbaHMLL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 07:11:29 -0400
Date: Wed, 13 Aug 2014 13:11:12 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Rik van Riel <riel@redhat.com>,
        linux-kernel@vger.kernel.org,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Frank Mayhar <fmayhar@google.com>,
        Frederic Weisbecker <fweisbec@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sanjay Rao <srao@redhat.com>, Larry Woodman <lwoodman@redhat.com>
Subject: Re: [PATCH RFC] time: drop do_sys_times spinlock
Message-ID: <20140813111112.GJ9918@twins.programming.kicks-ass.net>
References: <20140812142539.01851e52@annuminas.surriel.com>
 <20140812191218.GA15210@redhat.com>
 <1407913190.5542.50.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qyEdwqDpCJsIV+9Q"
Content-Disposition: inline
In-Reply-To: <1407913190.5542.50.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qyEdwqDpCJsIV+9Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 13, 2014 at 08:59:50AM +0200, Mike Galbraith wrote:
=20
> I was told that clock_gettime(CLOCK_PROCESS_CPUTIME_ID) has scalability
> issues on BIG boxen

> I'm sure the real clock_gettime() using proggy that gummed up a ~1200
> core box for "a while" wasn't the testcase below, which will gum it up
> for a long while, but looks to me like using CLOCK_PROCESS_CPUTIME_ID
> from LOTS of threads is a "Don't do that, it'll hurt a LOT".

Yes, don't do that. Its unavoidably slow and bad.

--qyEdwqDpCJsIV+9Q
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT60fQAAoJEHZH4aRLwOS610kP/0VdjfxaNrCd+9slVyfkGGhU
TmOKlivsA/xqTwGnfzYDlF5KvRJgWpZ4oc1fEZ/O6PUU0M098GclJHvYWU8ioKZH
xe5aHHcgitJsA66HsYjpfrX/sswrFSzAFzckp9cdwa/f/HKsW1OwZhX886q11FHF
fZxorKLsOeFXXjIkmPHuXdR69PX26O5BA9WlrEqHqPqTe/k22siVnIgXcUzn8Qih
RqdwvhRygPcJAKRKc10sFlCWQluz91FxxDFJ4WGBJG8JFuJp+AMgHRJu1Fv9Wvkg
CLlCfvOYN1IAoBgL9DRnQMLEZx5LpYw9cAaNKptHOYZ7qnj6vgOL00RBf/wr5Nvl
63wmb4ibGjX4v4s5PJpMBZC8baJgm2MgAnxEs0Mr/QoImvaWJfmwD2VfPEhVCVOv
XFViOkuxhH/BYkjDZig+Hvf2JwdvHYC54MtnIqZg0O7xn532aBXgAQDGIJrqeMKu
gh3LLpX7xAoXA5JO6bcoGY4ezsBEC2Bp+pgiMOW+5i75d1h53speu1FiHnpZG8+3
FO5Ty21XgEo232zcQwIB2OLR8HXAbokDWoEjQL85BHRy5R/txO417wdRJNpw2HQ/
wDEO7u2c2XgK9CTgYt2D6H7Qu7NHMMyAqWc90P1Wtx1vw0bxoGpdgKU4ks1fRaVd
2xW5WB0Xr/WHi6YNbWrp
=AlvP
-----END PGP SIGNATURE-----

--qyEdwqDpCJsIV+9Q--

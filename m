Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712AbaE1PRl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 11:17:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:43320 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754058AbaE1PRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 11:17:39 -0400
Date: Wed, 28 May 2014 17:17:30 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "efault@gmx.de" <efault@gmx.de>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>
Subject: Re: [PATCH v2 08/11] sched: get CPU's activity statistic
Message-ID: <20140528151730.GW11096@twins.programming.kicks-ass.net>
References: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org>
 <1400860385-14555-9-git-send-email-vincent.guittot@linaro.org>
 <20140528121001.GI19967@e103034-lin>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EzoGi9kFQAnUjl0a"
Content-Disposition: inline
In-Reply-To: <20140528121001.GI19967@e103034-lin>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EzoGi9kFQAnUjl0a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 28, 2014 at 01:10:01PM +0100, Morten Rasmussen wrote:
> The basic problem is that worst case: sum starting from 0 and period
> already at LOAD_AVG_MAX =3D 47742, it takes LOAD_AVG_MAX_N =3D 345 periods
> (ms) for sum to reach 47742.=20

But it takes only 4 periods (4*32ms) to get ~94% of the way there,=20

So our half-time is 32 * 1024 ms, now look at \Sum_i=3D1,4 1/(2^i) =3D
0.9375. So 4 periods (4*32*1024=3D131072 ms) gets us ~94% of the way
there.

Now, granted, 4 periods of 32-ish ms is still very long, but nowhere
near as horrid as the full convergence.

--EzoGi9kFQAnUjl0a
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJThf4KAAoJEHZH4aRLwOS6920P/3Mo61XO0U0+Yp4uw5kGaWAp
GVUQZY/Eio38+gIM8E8a6QNmBJET6QXMWwRvQTe2rZljRhnWeb+wzDzcyyFF2DzA
fI8dJd8iD6x+ZGtVsIiDQcgdft6fSiiZdSEvYmSuH9SJL1NqRljYeJsg2X6X5ATT
ZNRCnzlwN+ynyepJ8VUMzW265aUYlPB/iSuUqOqsVWInVAOxJv2bih7LyHRL/nvc
BgFtKNHZKDGQoUbCvVKpIoube+EKrpY78ILK0spKFIzGLD/7Wm+uR30fupm/jvUT
3UL+DOhv6M1Qi7ftCaahbN9ew/CXZkCRZ2++z0/KdC3Zzo5mkVnH9Ue0ieNrmHTX
+ajxJEanjLyf2+ixh+D94OfYsjwuRYkwGVXPbdWoZm392VJzem0M1C0G3yhynr3G
r/av3Jaf0viXKBQJ1l2kTL+DOLRI2iuG9yyCfqYXjGKhEw2FuIYnSvsNksfQ7jnA
WAyHx9+D/0xlwwVAeelsV7rVdOKtgvmj3vDaVV7jF/SeI6kjGhecKfVC4TTT5ZKb
UgqCEukVmm74K6Wl3bdOo1K/wZqecQhiS9nU1sx/7/H7OsKHK8AtQorW1NbpBXgP
gvHP1pIpR8yybm2Jx87n0I+evWAy0Zz+EjRKl1+ahvE1HfPRoxfYqOiH4p9SL1Cy
9JkYhNIbIyztfTszt1Ac
=tD/y
-----END PGP SIGNATURE-----

--EzoGi9kFQAnUjl0a--

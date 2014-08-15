Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006AbaHOJog (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 05:44:36 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:44636 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbaHOJof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 05:44:35 -0400
Date: Fri, 15 Aug 2014 11:44:16 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Rik van Riel <riel@redhat.com>,
        linux-kernel@vger.kernel.org,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Frank Mayhar <fmayhar@google.com>,
        Frederic Weisbecker <fweisbec@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sanjay Rao <srao@redhat.com>, Larry Woodman <lwoodman@redhat.com>
Subject: Re: [PATCH RFC] time,signal: protect resource use statistics with
 seqlock
Message-ID: <20140815094416.GD19379@twins.programming.kicks-ass.net>
References: <20140813133526.1eb5526f@cuia.bos.redhat.com>
 <20140813180807.GA8098@redhat.com>
 <53EBADB1.2020403@redhat.com>
 <20140813184511.GA9663@redhat.com>
 <20140813170324.544aaf2d@cuia.bos.redhat.com>
 <20140814132239.GA24465@redhat.com>
 <20140814174849.GA5091@redhat.com>
 <1408079971.5536.37.camel@marge.simpson.net>
 <20140815062819.GY19379@twins.programming.kicks-ass.net>
 <1408095453.5567.6.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ojZBYePqDcGaG1TE"
Content-Disposition: inline
In-Reply-To: <1408095453.5567.6.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ojZBYePqDcGaG1TE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 15, 2014 at 11:37:33AM +0200, Mike Galbraith wrote:
> On Fri, 2014-08-15 at 08:28 +0200, Peter Zijlstra wrote:=20
> > On Fri, Aug 15, 2014 at 07:19:31AM +0200, Mike Galbraith wrote:
> > > For the N threads doing this on N cores case, seems rq->lock hammering
> > > will still be a source of major box wide pain.  Is there any correctn=
ess
> > > reason to add up unaccounted ->on_cpu beans, or is that just value
> > > added? =20
> >=20
> > That delta can be arbitrarily large with nohz_full. And without
> > nohz_full the error is nr_cpus*TICK_NSEC, which I bet is larger than the
> > reported clock resolution.
> >=20
> > Having a non-constant error bound is annoying for you never quite know
> > what to expect.
>=20
> Ah, yeah, that could get rather large.
>=20
> > Also; why do we care about PROCESS_CPUTIME? People should really not use
> > it. What are the 'valid' usecases you guys care about?
>=20
> I don't care much, said "don't do that" before I saw a similar big box
> problem had popped up with times().

Urgh, yes times().. Now I don't think we do very accurate accounting of
those particular numbers, so we could fudge some of that. Typically we
only do TICK_NSEC granularity accounting on user/system divide anyhow,
seeing how putting timestamp reads in the kernel<>user switch is
_expensive_ -- see NOHZ_FULL.

--ojZBYePqDcGaG1TE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT7dZwAAoJEHZH4aRLwOS6dB0QAKCee+iIgRmgnw2R3w6TP6KR
3UnRfEtSbe5hB1ivrM4q12/CQjuFjWjHVhSGSGe5D0Sn0tyUcovl3OjTuLdCMnwD
BxELncgtSX+RzsDBN57jAwo0dP1snUjLCYTxNLpXeZbutgNx19gKDz86qD4ZA8gy
2lOTwDdbklQlJo0oPs4XLNP74jtyZWygsh4hGPWut6CnPJyR3LvgamEkTObBL3g5
HJ9vl+8kPw6QSUrT6c1ZjscNBfTHzJEVnML17nwJFLTP0HBDalu96StL8+9pN7q7
JiEWYSkHPzzspVNhFV4m2fDF17QnLS4rWuSuK9masBY40SO7O4xwKY/o/Q0qDd6q
EyRI6GteLSWZP5rgge1NCytgdDBo8FXRQiu249uJIrm1Zxv/pf4nlH9396e5vupt
dvAhfnGTuhFyzX/5+o2gqM1LYe2OO73HK1Z7ZeOdW6xx5M61Tvb8SlK12ccTAQQ4
wLRfpaRxEF/+EAy53UK3+t9AyvtlcJ/6RnSss7NHtjf68UIhEa1s3oZ8EWYxzxS3
KHDQf0nhjeHr09CjCSaGDNQTVeBCAfQ6+38BCv9nOx6Hv/vDJb68yWXjXbjcF/2B
a1LJK6uLJJIq8wzEQESsO1KUxbl/VL4AYG37I5XbocRs6qaXD0xdaxm1h4hb3hqS
WDfgx+ZxN0n5hkx7nRmy
=F5pj
-----END PGP SIGNATURE-----

--ojZBYePqDcGaG1TE--

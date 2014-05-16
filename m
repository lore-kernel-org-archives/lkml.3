Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757842AbaEPQV1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 12:21:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:40585 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757818AbaEPQVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 12:21:25 -0400
Date: Fri, 16 May 2014 18:21:17 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Sasha Levin <sasha.levin@oracle.com>, Ingo Molnar <mingo@kernel.org>,
        acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Dave Jones <davej@redhat.com>,
        tytso@mit.edu, price@mit.edu, hannes@stressinduktion.org
Subject: Re: BUG_ON drivers/char/random.c:986 (Was: perf: use after free in
 perf_remove_from_context)
Message-ID: <20140516162117.GY11096@twins.programming.kicks-ass.net>
References: <5370EBE9.6@oracle.com>
 <20140516153455.GV11096@twins.programming.kicks-ass.net>
 <53763775.3040602@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tJKub4+frm2HVP3B"
Content-Disposition: inline
In-Reply-To: <53763775.3040602@linux.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tJKub4+frm2HVP3B
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 16, 2014 at 09:06:13AM -0700, H. Peter Anvin wrote:
> On 05/16/2014 08:34 AM, Peter Zijlstra wrote:
> >=20
> > While fuzzing to reproduce my issue I hit the below, its triggered loads
> > of times and then the machine wedged (needed a power cycle), I can
> > provide the full console log if people care.
> >=20
> > Anybody seen that one before?
> >=20
>=20
> I certainly haven't... this bad.  Any idea what the actual system call
> looked like?

Sadly, no, while I had syscall tracing enabled, the bug I'm chasing is
non fatal so I hadn't set it to dump on bug -- not that dumping 24*1.4M
trace buffers over serial would've completed this side of the century.

I did save the trinity output (including seeds) but my experience so far
is that that is no guarantee for reproduction.

--tJKub4+frm2HVP3B
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTdjr9AAoJEHZH4aRLwOS6f0IQAKSJnghojPDCMnQWRD8fDGmk
7wuR0XOjb9jxChPJ+i2THlFeULfWcmY9E9bGsey3w6nH+7+ygjlkJ7xcfaN7o76I
KZCrQFDEnJP6SIxJtpFvoN8qjUlNM03Aal0bM1p2hINyszhn6MdMEnu8Ig3Zbczs
MQnLWOZmX40o3PZw7FWOypzpGtHa3fOpr2trFJPykzrw8lbhMnen4zbkDki+fTJ+
diIR9tbkn2uJNztprwVWLUEs1KfpcQlPYfmGjeAi9u1HmMngoqV8hVE9Qp9rZgps
y8lFAJfzJYmqq4A56A1w42xZYfeHEBBuUuVprFl/HiKczszPDWQtkEREQXbrpzMM
IATX53qBhwM50/s3NeQJLglqHJF7tbxSBK7TkS5o0Kg7ZdEbt8RVF1k+U1NUNENE
TxeSsPRkpwcvAWYIvUnnwQIHeY1lwyTbCfqDMzzTLIgBxH9YIT6L12V6lWp18iJ3
/tOkz0A0LL/0NrqPFxd59pr5Y2UpCQUlNZa0qwVQzp5P4lFsY5wURqNjFc6kxycA
vZXTZblmDgS3hMh4OI+UJ2mkrw2wL4Q8BlNA9B/tp+d7iwFtz3EQRSyVN2o3P5cV
m8TE8EEeVWONxoQIoR1iyjiUnvxTehSsQcADI+dV/6hsZWMbTcQYaoh7Ksf6vLhx
c9sFoDP8l1oyL7Ep1ONr
=BSBI
-----END PGP SIGNATURE-----

--tJKub4+frm2HVP3B--

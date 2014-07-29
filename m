Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745AbaG2H4x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 03:56:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:34925 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbaG2H4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 03:56:52 -0400
Date: Tue, 29 Jul 2014 09:56:37 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <cl@gentwo.org>
Cc: Sasha Levin <sasha.levin@oracle.com>, akpm@linux-foundation.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>,
        John Stultz <johnstul@us.ibm.com>, Mike Frysinger <vapier@gentoo.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, hughd@google.com,
        viresh.kumar@linaro.org, hpa@zytor.com, mingo@kernel.org
Subject: Re: vmstat: On demand vmstat workers V8
Message-ID: <20140729075637.GA19379@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.11.1407100903130.12483@gentwo.org>
 <53D31101.8000107@oracle.com>
 <alpine.DEB.2.11.1407281353450.15405@gentwo.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pEQDlUeuaD3XV+9x"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1407281353450.15405@gentwo.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pEQDlUeuaD3XV+9x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 28, 2014 at 01:55:17PM -0500, Christoph Lameter wrote:
> On Fri, 25 Jul 2014, Sasha Levin wrote:
>=20
> > This patch doesn't interact well with my fuzzing setup. I'm seeing
> > the following:
> >
> > [  490.446927] BUG: using __this_cpu_read() in preemptible [00000000] c=
ode: kworker/16:1/7368
> > [  490.447909] caller is __this_cpu_preempt_check+0x13/0x20
>=20
> __this_cpu_read() from vmstat_update is only called from a kworker that
> is bound to a single cpu. A false positive?

kworkers are never guaranteed to be so, its a 'feature' :/

--pEQDlUeuaD3XV+9x
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT11O1AAoJEHZH4aRLwOS61PUP/R/S+B40g7gd2IuLe4SbVCAs
llPxoJDjdcT3bQyMf7kvUG8echjGZ+6EuQ7DcysUYwlE7Am8MsLH8zGaxNYN/ZIf
gxKW0vP034O+7gD2igpXy27+/2WVQeZJvYoeDDo7lIAv4XFEdw35Ra+rqBHTdkmK
ltfA40sYwAG5VSRhb3YEoglMYQ0reuIu+gUcpZAMqc3hCR4Dl9drPL1rnVhyCcEF
3Kn05qR/gB5ktZN1ju/YO74Vp8rDK3V9U7kt8mvX2SuhrLcsmWB76lbOQWoMv4Bc
lHaRh8PyzN/zQcFzyfcxwBYRVUQHc+KHYQzedFsJY5nkOugDbiCSLBp2b3IEoVZo
r+PWD5yRcWiuAR6v2b2TcvYGYJ1cuEpOTgbSQCPMcI6GglYCnqJa3mh/SP3BHIkw
H0zKRnYuq9jr25kIgd928avmrceJmayA+qEOokstJD1Llt1QueZ/xF3kOcglL9L0
4FK5asoMJ28Hg62XUmMFDpRrdKIXuzi6D1qz6dMa9OTBf6BRjbuEk+Yx/ZxNA0xe
+LltXPobiehCuJgnCqf5RPP2M8HpYk6sZ45vuzMeRRiQwCgb1H8AJxhmkkqxlYVd
BGBVvMkZ679d9Wb5IEDFEYhvjE5YqqMrzYYQ3cpoBQiGm/kieCaBr9QqJVzmMfuY
VoVdEp3ISffIyo4pyy6C
=GQuK
-----END PGP SIGNATURE-----

--pEQDlUeuaD3XV+9x--

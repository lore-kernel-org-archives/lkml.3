Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072AbaFCPDM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 11:03:12 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:55884 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbaFCPDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 11:03:11 -0400
Date: Tue, 3 Jun 2014 17:02:59 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 5/5] nohz: Use IPI implicit full barrier against
 rq->nr_running r/w
Message-ID: <20140603150259.GV30445@twins.programming.kicks-ass.net>
References: <1401806420-31018-1-git-send-email-fweisbec@gmail.com>
 <1401806420-31018-6-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VFtJ6YJpdOijWzIn"
Content-Disposition: inline
In-Reply-To: <1401806420-31018-6-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VFtJ6YJpdOijWzIn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 03, 2014 at 04:40:20PM +0200, Frederic Weisbecker wrote:
> A full dynticks CPU is allowed to stop its tick when a single task runs.
> Meanwhile when a new task gets enqueued, the CPU must be notified so that
> it can restart its tick to maintain local fairness and other accounting
> details.
>=20
> This notification is performed by way of an IPI. Then when the target
> receives the IPI, we expect it to see the new value of rq->nr_running.
>=20
> Hence the following ordering scenario:
>=20
>    CPU 0                   CPU 1
>=20
>    write rq->running       get IPI
>    smp_wmb()               smp_rmb()
>    send IPI                read rq->nr_running
>=20
> But Paul Mckenney says that nowadays IPIs imply a full barrier on
> all architectures. So we can safely remove this pair and rely on the
> implicit barriers that come along IPI send/receive. Lets
> just comment on this new assumption.
>=20
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Kevin Hilman <khilman@linaro.org>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Viresh Kumar <viresh.kumar@linaro.org>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

--VFtJ6YJpdOijWzIn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTjeOjAAoJEHZH4aRLwOS6pRsQAK6wqSkpBKJVHq5ozsFkU2H3
msuBHV2anuvWjJIetsDk0nrlZ6ZZ0/LrJW6dxCFXrSHIkS5dgbDkwYJq2YeuBZGC
k46ojFG/RrroSEJ5cmtCDgXwV8K8ed3InPoPMnAqlLJgNsSFJOwO1/S267z/TMUY
FJoQ0Dlc5+y6/tF0pcLT4CWj6TTvcWBtKrLgYwhJ5WlZ/YUFh1Tva4IXU7LgrnQG
ZF9y8cEuFGeQrRdJlsHc3QQaoEd00ZxQPJ3Z4HpyCnVWRlzDHxEa0j0BmqY5ZBag
NGgfstUJWBtWRaVFF2p6+ZesquxLrcgEX6qvhrjZb4YinfHEz721VOCedD5y1ZYM
sQ6z+lhTAcvo6tYjnp8ir7o2ehsM4+MwlnUN/Mlt4qBTrRHFtLa/k6uixCIGkzmW
uB8316udviJ2aa+CuetmBQKarQVjult4T1s+dpWWEptdFgn8o4HgBYHOa78WDZeo
bNmi/eVzTdUO9QVRQRIOQNc5W2alLeMMwnPSEMidYpOBNOKZM0qLlpX0ScvLz9vJ
1AhK9x9JemyTQlw5BMqxRaMUb2sKmM51fOVlnqzQ9+d7d8HGOzE1gHoRCO+2nfOG
f6A7qg/seCTW2xC96OZkOmpwIqciPkr4qND0BTVLmsdQ0QRte0tpu/3PJ/nnlK9S
cOlDvtbYLSjOm0QQS96a
=C3dI
-----END PGP SIGNATURE-----

--VFtJ6YJpdOijWzIn--

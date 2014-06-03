Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932836AbaFCPBE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 11:01:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:41998 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932080AbaFCPBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 11:01:02 -0400
Date: Tue, 3 Jun 2014 17:00:54 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 4/5] nohz: Move full nohz kick to its own IPI
Message-ID: <20140603150054.GU30445@twins.programming.kicks-ass.net>
References: <1401806420-31018-1-git-send-email-fweisbec@gmail.com>
 <1401806420-31018-5-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fI9rxb8OPOZXsIa9"
Content-Disposition: inline
In-Reply-To: <1401806420-31018-5-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fI9rxb8OPOZXsIa9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 03, 2014 at 04:40:19PM +0200, Frederic Weisbecker wrote:
> Now that the irq work subsystem can queue remote callbacks, it's
> a perfect fit to safely queue IPIs when interrupts are disabled
> without worrying about concurrent callers.
>=20
> Lets use it for the full dynticks kick to notify a CPU that it's
> exiting single task mode.
>=20
> This unbloats a bit the scheduler IPI that the nohz code was abusing
> for its cool "callable anywhere/anytime" properties.
>=20
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Kevin Hilman <khilman@linaro.org>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Viresh Kumar <viresh.kumar@linaro.org>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  include/linux/tick.h     |  9 ++++++++-
>  kernel/sched/core.c      |  5 +----
>  kernel/sched/sched.h     |  2 +-
>  kernel/time/tick-sched.c | 10 ++++++----
>  4 files changed, 16 insertions(+), 10 deletions(-)
>=20

--fI9rxb8OPOZXsIa9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTjeMmAAoJEHZH4aRLwOS6gDkP/0nkwPvVojo/Sp8BPUmlj3Re
CGyHl0Jo5v+WGka7FeXzjcwL+NefRs1dyAVcPAuO68d/oetA1leE2UpbHpLIpO8h
CDfCQRxKTJ+8a/f6TPmxIDQ2fSR6hygTd67zyRT8iooUh9m77ZLx6doGYxL8hXhe
pY8x8sn4obxJIKpnuxcgQeKYDPQbIFPVLkOJmkv5YqVKKKuPQxiKjx6L8ynDdCUF
p5EqE/u+HaaxFGru+8G9j7pmZZWCaYSkQMwne3zJEhiGQdfQ1sDddnL2PIPjJZju
kXzVbGmeUHZjTb1yNU9pjgcfhVoJVbCe8s3tK4CrPA1TB5u4wUsC37SVoHQ8zGsc
OSzB1voF0t7//DIH3UXKIeHm6cVsGCVjum04dWORXRu2qANjNdr/qc4OTeKJpkJ+
SI9JPupW04xQWwwqweXreVFJ0bAvNGuLFIA49muvsmdW9/4FrEL/VI1x5w94zUCK
JW4bPsyY6qG7duJZTAIrXhTI0DxEXTV8kgk6ZHHmECwtSRLGShwCRQgL46q9/CAn
4xkFsoWzr/6tRtNjcZPH71g2IDrzU21FDAlF1HI8DBrf6AM/XDxb2XaY4ZNmRGiL
iyHmmOCNg7anB5xVxcsrBPZrB9JxmmmpvdfK3RhVi+Pm3G07Fpllbwz5LS0Gg4sS
c2z+TzUaAPDcaBKcsxEZ
=8GGy
-----END PGP SIGNATURE-----

--fI9rxb8OPOZXsIa9--

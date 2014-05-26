Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbaEZQCe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 12:02:34 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:33571 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbaEZQCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 12:02:33 -0400
Date: Mon, 26 May 2014 18:02:24 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 3/5] irq_work: Implement remote queueing
Message-ID: <20140526160224.GM30445@twins.programming.kicks-ass.net>
References: <1401028191-29756-1-git-send-email-fweisbec@gmail.com>
 <1401028191-29756-4-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yTu8xYwxoJJ7HOQW"
Content-Disposition: inline
In-Reply-To: <1401028191-29756-4-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yTu8xYwxoJJ7HOQW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, May 25, 2014 at 04:29:49PM +0200, Frederic Weisbecker wrote:
> +bool irq_work_queue_on(struct irq_work *work, int cpu)
> +{
> +	/* Only queue if not already pending */
> +	if (!irq_work_claim(work))
> +		return false;
> +
> +	/* All work should have been flushed before going offline */
> +	WARN_ON_ONCE(cpu_is_offline(cpu));
	WARN_ON_ONCE(in_nmi());


Also, I would do both these checks before the claim thing.

> +
> +	if (llist_add(&work->llnode, &per_cpu(raised_list, cpu)))
> +		native_send_call_func_single_ipi(cpu);
> +
> +	return true;
> +}
> +EXPORT_SYMBOL_GPL(irq_work_queue_on);



--yTu8xYwxoJJ7HOQW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTg2WQAAoJEHZH4aRLwOS6QlsP/jgwY/dTeRYus/swMsIJIst4
+1r7LYZYqQbH5VJF8rTN63CeyEXuMaBKMUDWnnFcC2A1poDszaap4IbWzgeyPiBD
+Ty/4wnp+SJl64gUDKWLVPApUKixfj8D7wp2tCP+6XPdi6gDdFQELj0MP92Fx0ud
T8ec3W7spNJgebsYpspWbImXlSN9IVCF3FvgNC85P45cmboak2vLclAS44ynAZIJ
ZGZWFvgIx6Phh02r0x9lkruxWHQLczGoLoCsYm5aikwhDZd/ro2V0XW0Ed9+VzWL
hrc3QdCR/nR5Cmoh5TjQdZ0UMGMzCNggwVO7geQMxj/p2uvOIOVeVGYofp+ocUQ5
F0tqFumWqT0KU+aJdyBBSe5GjEnsQuu3Zp14i7FiQNipaoejnYLgC7eurU81wuiJ
qi7jGtmkM9QpwtJq84ZeBiVSFDfEGA1U6IkkWwYm57eRChlA5WMCLOjZ6RPlhGm9
mV/QepJruUvwpY1Hi/Wb3wFFqB7H9+j7wRa/E36VrJRK5eTW4hRcjqODICGO6kNl
57D+uUOq4m7Oj1qFklqRsiXbiEYKRmNhKsoJyk0M3XaevwLOBZSteFErcHVrXxf5
sQv+1Zs2Gi2eWz9JbWUa7i52iX6vUzrP8gK8RcYTiVfJEPwQIYKJs94hyeJv7gtf
SYI0yOA5iFuMk4100qLe
=1pta
-----END PGP SIGNATURE-----

--yTu8xYwxoJJ7HOQW--

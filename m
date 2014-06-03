Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932642AbaFCOyy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 10:54:54 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:52923 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754236AbaFCOyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 10:54:52 -0400
Date: Tue, 3 Jun 2014 16:54:42 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 1/5] irq_work: Split raised and lazy lists
Message-ID: <20140603145442.GS30445@twins.programming.kicks-ass.net>
References: <1401806420-31018-1-git-send-email-fweisbec@gmail.com>
 <1401806420-31018-2-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YjQsDnI/3MvG4QUn"
Content-Disposition: inline
In-Reply-To: <1401806420-31018-2-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YjQsDnI/3MvG4QUn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 03, 2014 at 04:40:16PM +0200, Frederic Weisbecker wrote:
> @@ -90,10 +89,10 @@ EXPORT_SYMBOL_GPL(irq_work_queue);
> =20
>  bool irq_work_needs_cpu(void)
>  {
> -	struct llist_head *this_list;
> +	struct llist_head *list;
> =20
> -	this_list =3D &__get_cpu_var(irq_work_list);
> -	if (llist_empty(this_list))
> +	list =3D &__get_cpu_var(lazy_list);
> +	if (llist_empty(list))
>  		return false;
> =20
>  	/* All work should have been flushed before going offline */

Does this mean needs_cpu() only checks the lazy list? What about archs
without the arch_irq_work_raise() function? They run the other list from
the tick too.

--YjQsDnI/3MvG4QUn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTjeGxAAoJEHZH4aRLwOS6GPQP/jCk7g159UJJ8YB5QaVLiSGY
0HDYxQX+yKnz3Hzt1nZ70OFSY5/0dSvFxj/u3OGz3bcjD6WDtSjzwoHUZTPdt21t
XG8ZrEVfq142iYKt8HRlxB2azOvWuXcS3dJ/DVmSlq4pU5ZR33XMOSquyOBlZ1OE
GbZhQ+UOrn38SQGOa5ocKXlQg45O9zwWq2O4WQ0ce+J550BP1QCMyK7h+ued9YLv
VhZHU6mLnwMu/48/lBmdho/Hf9P1toN51KLtzmWt6dR+zJgq3hIKc6tJpk9cOX20
9kBP99bbPCCAXT+5KoKuzpWBUwst1SZgAGYrhayArdQtw4L85wD9VzW0Bulz+EIW
xeq4EMjQrPUCYC9Q9IirVUE1RKA06ZNhV6cGcr9WhhKlbJBiwpDoeLfEJFdLLnX5
tqX0++uZqrHa//rFRuDsdaYON9VE5CEgOazaeKJsX3oWi54I9xUYf0N15eNP65Cj
R/qlcgfxQoNUopIvRsdvfTddLo0569Jb3/Fe4fMiEtB99nD4d9E6eWzhIwD2YIJe
LkMEzGur+BPgYm92iEzWLoJJQTjZe+nn/sAFmMe4IVqgXnn3vkKuEFo918Xpev4/
75XpHWiaUatEV7k2ZNcp+v18m5caV4YdSTu8Z9lTZTiTwbWHnU3mp9LB+62A1zk/
Sw/0ThgPel0C5ZMdkmX2
=CXxA
-----END PGP SIGNATURE-----

--YjQsDnI/3MvG4QUn--

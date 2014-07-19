Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032AbaGSHUU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 03:20:20 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:46802 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578AbaGSHUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 03:20:19 -0400
Date: Sat, 19 Jul 2014 09:19:51 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 02/10] nohz: Kick full dynticks timer targets with an
 empty IPI
Message-ID: <20140719071951.GS9918@twins.programming.kicks-ass.net>
References: <1405730661-9355-1-git-send-email-fweisbec@gmail.com>
 <1405730661-9355-3-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BoDqKHKmWrz+Gi55"
Content-Disposition: inline
In-Reply-To: <1405730661-9355-3-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BoDqKHKmWrz+Gi55
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jul 19, 2014 at 02:44:13AM +0200, Frederic Weisbecker wrote:
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 7f3063c..f3e48b8 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -693,7 +693,7 @@ static bool wake_up_full_nohz_cpu(int cpu)
>  	if (tick_nohz_full_cpu(cpu)) {
>  		if (cpu != smp_processor_id() ||
>  		    tick_nohz_tick_stopped())
> -			tick_nohz_full_kick_cpu(cpu);
> +			irq_work_void_on(cpu);

So no, while the previous function name was descriptive, the new one
leave one wondering.

--BoDqKHKmWrz+Gi55
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTyhwRAAoJEHZH4aRLwOS6MOQQAJ0AOutkO306Mvy59phnR+mD
n7WbvRv41eW9CjXBFMfdzgGiAEsxcc0kLLtoHQVpYnhTly1/iQYpmxLs+E3XmSbx
ypPjsPKtMf53MNx9OcBm80hfEGq/CRDPC0QSkHflGL2uA7WpT/8qy4GZF/pFEbpL
0Lx46OHdVguBvm2Y30Z3hW1sYRjxczXNVjcXEuGu1BOryskfdLvkos4jODIX3ZDh
TZhMyrSq3vI4CDcIgrPAehkl1uWLcSrnHAAhyNfaS9XIx42kABgUZTYCYVgXQrds
pFWK3c5NZa0Iqqxxn7Z1MlKz5cufN+GW163w+GmGbCKOeFYCS4o1fwpSpLxHUptz
GfY24UqTdML8UNuNX9Zl6hT8VX6pfSdTAF5g5g+Yarr3jWM1+gwMPe3eSy9wU3jG
HDL0WQczLrF63BJ9JNjlxBMeCc8iWquap8NgssC7xVO0CjhsfeQIS4NX4ACJuxim
uflKcjw6v1nEUsnCUDLulGjajSugRmcbjse2qmiQc2BtMO4AUN4N+dMt5l4Lsopc
d/Yp5SnrP6SiOyTnTKLMD5dkkbrId36qgrwq9sK63JR7N4d3l/vaN6kzbB/PNuNt
JefqE+CajwWO7qZEh63NaBVeDucZoMHVVkBRzJ1dOoH/9zL0bDP8aJs1yMtOMGdi
QJaqzwGYJznbhISCEhmZ
=TyFa
-----END PGP SIGNATURE-----

--BoDqKHKmWrz+Gi55--

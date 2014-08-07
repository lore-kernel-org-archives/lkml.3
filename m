Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441AbaHGIte (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 04:49:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:46166 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052AbaHGItc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 04:49:32 -0400
Date: Thu, 7 Aug 2014 10:49:21 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH v3 tip/core/rcu 1/9] rcu: Add call_rcu_tasks()
Message-ID: <20140807084921.GK19379@twins.programming.kicks-ass.net>
References: <20140731215445.GA21933@linux.vnet.ibm.com>
 <1406843709-23396-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <53DEE1CD.4000705@cn.fujitsu.com>
 <20140804074620.GH9918@twins.programming.kicks-ass.net>
 <53DF41ED.2020508@cn.fujitsu.com>
 <20140804115043.GA31903@linux.vnet.ibm.com>
 <20140804122515.GR19379@twins.programming.kicks-ass.net>
 <20140804145648.GE3588@twins.programming.kicks-ass.net>
 <53E029BB.2010200@cn.fujitsu.com>
 <20140805215510.GT8101@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qsqI6JipFTsTKuUK"
Content-Disposition: inline
In-Reply-To: <20140805215510.GT8101@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qsqI6JipFTsTKuUK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 05, 2014 at 02:55:10PM -0700, Paul E. McKenney wrote:
> +/* Check for nohz_full CPUs executing in userspace. */
> +static void check_no_hz_full_tasks(void)
> +{
> +#ifdef CONFIG_NO_HZ_FULL
> +	int cpu;
> +	struct task_struct *t;
> +
> +	for_each_online_cpu(cpu) {
> +		cond_resched();
> +		rcu_read_lock();
> +		t = rcu_dynticks_task_cur(cpu);
> +		if (t == NULL || is_idle_task(t)) {
> +			rcu_read_unlock();
> +			continue;
> +		}
> +		if (ACCESS_ONCE(t->rcu_tasks_holdout))
> +			ACCESS_ONCE(t->rcu_tasks_holdout) = 0;
> +		rcu_read_unlock();
> +	}
> +#endif /* #ifdef CONFIG_NO_HZ_FULL */
> +}

That's not hotplug safe afaict, and I've no idea if someone pointed that
out already because people refuse to trim email and I can't be arsed to
wade through pages and pages of quoting.

--qsqI6JipFTsTKuUK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT4z2RAAoJEHZH4aRLwOS62rgP/0NmZ/tgv0uXBSVkBUEpt8PR
uJj10zzsh/o+sjcuWDbBqkUZXtwmzp01Pqt01dmOXhUiIRg+XixgOSylhy1ZbqpI
K+uMXhuYfiPzEYzKy/15YP0NcIKLxpz7rZq+Eku4hl6z4Z0LW/HKzHYFLIVs4Bbz
bh/FQ0v42dCEoE9k6aEbmrH27PggbU5l1o6QDySpgCCgFrkFXpDGxeTUzlW+jekC
HuogBVSC0cpqKbxld8xQJtDSvrk0iITWtkU7QU/KS6vucfxFhQHeuy3m+5bki5cR
1CefVWs89UYj8K7qB7lk4YWQRuOpOT3CgSF9BClT7FWXLUpv7DTaPH5oycpUHX2U
BL8QGUZ/4yRkkQynvB+4xXi7vxu3KW5/b5V9kdGS8vdUCH6v5EG4ZBK1JBXYpoME
9Z8u4P2sic/HskHtZt9FloHXPW8pEGkRisgQ1ta9xNv9y9TOMYa6lKAeHiukpOXF
+TJ/zvrBXDzeXcFsGSehzvNIZb/ftABIvULdi4xRqUe94OSE4329My83557wp/ki
sSohG0cvf7Vmi9PkIxhHuWxp0nAg+l6eesX8zSx0iKD50UOM7Zr3sNztnXC7Wnyv
7VyvLvuGEr2bWmGKOWOVAU+x0kptwlwJttGjiP92Ylqop7ApqGNosRH2WcFMeFtm
YS1/MQc9rarlPKuicVcU
=lqEe
-----END PGP SIGNATURE-----

--qsqI6JipFTsTKuUK--

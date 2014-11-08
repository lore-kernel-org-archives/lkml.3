Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873AbaKHQNo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 11:13:44 -0500
Received: from smtprelay0136.hostedemail.com ([216.40.44.136]:60588 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753725AbaKHQNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 11:13:42 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1981:2194:2199:2393:2559:2562:2828:2895:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3870:3871:3872:4250:4321:5007:6261:7875:7903:9040:10004:10400:10848:11026:11232:11658:11914:12043:12438:12517:12519:12555:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: anger25_1fe73487c3661
X-Filterd-Recvd-Size: 2272
Message-ID: <1415463217.23530.26.camel@perches.com>
Subject: Re: [PATCH v6] Move BTRFS RCU string to common library
From: Joe Perches <joe@perches.com>
To: Omar Sandoval <osandov@osandov.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Date: Sat, 08 Nov 2014 08:13:37 -0800
In-Reply-To: <1415436384-13691-1-git-send-email-osandov@osandov.com>
References: <1415407155.23530.24.camel@perches.com>
	 <1415436384-13691-1-git-send-email-osandov@osandov.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-11-08 at 00:46 -0800, Omar Sandoval wrote:
> The RCU-friendly string API used internally by BTRFS is generic enough for
> common use. This doesn't add any new functionality, but instead just moves the
> code and documents the existing API.

Some more trivia, can be updated later if desired.

> diff --git a/include/linux/rcustring.h b/include/linux/rcustring.h
> new file mode 100644
[]
> +
> +/**
> + * printk_in_rcu() - printk in an RCU read-side critical section

It'd be nice to show the arguments for kernel-doc here

> + */
> +#define printk_in_rcu(fmt, ...)			\
> +	do {					\
> +		rcu_read_lock();		\
> +		printk(fmt, __VA_ARGS__);	\

This should use ##__VA_ARGS__ to allow the
compiler to elide the comma when using

	printk_in_rcu("Hello World!");

> +		rcu_read_unlock();		\
> +	} while (0)
> +
> +/**
> + * printk_ratelimited_in_rcu() - printk_ratelimited in an RCU read-side critical
> + * section
> + */
> +#define printk_ratelimited_in_rcu(fmt, ...)		\
> +	do {						\
> +		rcu_read_lock();			\
> +		printk_ratelimited(fmt, __VA_ARGS__);	\
> +		rcu_read_unlock();			\
> +	} while (0)
> +
> +#endif

Here too


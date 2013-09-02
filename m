Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757063Ab3IBAGh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 20:06:37 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:56143 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305Ab3IBAGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 20:06:36 -0400
X-Originating-IP: 50.43.39.152
Date: Sun, 1 Sep 2013 17:06:26 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Wang Shilong <wangshilong1991@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org,
        sparse@chrisli.org, lttng-dev@lists.lttng.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>
Subject: Re: rcu: Make rcu_assign_pointer's assignment volatile and type-safe
Message-ID: <20130902000626.GA22111@leaf>
References: <5223d2b1.W0Uf1KjUIaBOcCMH%wangshilong1991@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5223d2b1.W0Uf1KjUIaBOcCMH%wangshilong1991@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 02, 2013 at 07:50:09AM +0800, Wang Shilong wrote:
> Hello, Using checkpatch.pl, i get the following warnings(errors):
> WARNING: line over 80 characters
> #57: FILE: include/linux/rcupdate.h:518:
> +		extern void __rcu_assign_pointer_typecheck(int, typeof(*(v)) __kernel *); \

It'd get much uglier if wrapped, and the function name needs to stay
unique to avoid conflicts with the macro context.  I don't plan to
change this.

> ERROR: need consistent spacing around '*' (ctx:WxB)
> #72: FILE: include/linux/rcupdate.h:568:
> +		ACCESS_ONCE(p) = (typeof(*(v)) __force space *)(v); \

False positive; checkpatch.pl seems to parse this as multiplication
rather than a cast.

- Josh Triplett

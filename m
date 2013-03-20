Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757960Ab3CTQRO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 12:17:14 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58056 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379Ab3CTQRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 12:17:13 -0400
Date: Wed, 20 Mar 2013 12:17:04 -0400 (EDT)
Message-Id: <20130320.121704.1797978839297064162.davem@davemloft.net>
To: cmetcalf@tilera.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        gilad@benyossef.com, sasha.levin@oracle.com, akpm@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, yoshfuji@linux-ipv6.org
Subject: Re: [PATCH] dynticks: avoid flow_cache_flush() interrupting every
 core
From: David Miller <davem@davemloft.net>
In-Reply-To: <201303192143.r2JLhZIX020469@farm-0021.internal.tilera.com>
References: <201303192143.r2JLhZIX020469@farm-0021.internal.tilera.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Wed, 20 Mar 2013 09:17:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Metcalf <cmetcalf@tilera.com>
Date: Tue, 19 Mar 2013 17:35:58 -0400

> Previously, if you did an "ifconfig down" or similar on one core, and
> the kernel had CONFIG_XFRM enabled, every core would be interrupted to
> check its percpu flow list for items that could be garbage collected.
> 
> With this change, we generate a mask of cores that actually have any
> percpu items, and only interrupt those cores.  When we are trying to
> isolate a set of cpus from interrupts, this is important to do.
> 
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
> ---
> This change stands alone so could be taken into the net tree if
> desired, but it is most useful in the context of Frederic Weisbecker's
> linux-dynticks work.  So it could be taken up through either tree,
> but it certainly needs sign-off from someone familiar with net/core/flow.c.

I'm find with this going into the dynticks changes:

Acked-by: David S. Miller <davem@davemloft.net>

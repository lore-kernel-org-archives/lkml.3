Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115AbaARDKN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 22:10:13 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:41793 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041AbaARDKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 22:10:11 -0500
Date: Fri, 17 Jan 2014 19:10:10 -0800 (PST)
Message-Id: <20140117.191010.934120940597677468.davem@davemloft.net>
To: tj@kernel.org
Cc: lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        nhorman@tuxdriver.com, tgraf@suug.ch
Subject: Re: [PATCH 1/6] cgroup: make CONFIG_NET_CLS_CGROUP and
 CONFIG_NETPRIO_CGROUP bool instead of tristate
From: David Miller <davem@davemloft.net>
In-Reply-To: <1389982317-22225-2-git-send-email-tj@kernel.org>
References: <1389982317-22225-1-git-send-email-tj@kernel.org>
	<1389982317-22225-2-git-send-email-tj@kernel.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>
Date: Fri, 17 Jan 2014 13:11:52 -0500

> net_cls and net_prio are the only cgroups which are allowed to be
> built as modules.  The savings from allowing the two controllers to be
> built as modules are tiny especially given that cgroup module support
> itself adds quite a bit of complexity.
> 
> The following are the sizes of vmlinux with both built as module and
> both built as part of the kernel image with cgroup module support
> removed.
> 
> 	text		data		bss		dec
> 	20292207	2411496		10784768	33488471
> 	20293421	2412568		10784768	33490757
> 
> The total difference is 2286 bytes.  Given that none of other
> controllers has much chance of being made a module and that we're
> unlikely to add new modular controllers, the added complexity is
> simply not justifiable.
> 
> As a first step to drop cgroup module support, this patch changes the
> two config options to bool from tristate and drops module related code
> from the two controllers.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Acked-by: David S. Miller <davem@davemloft.net>

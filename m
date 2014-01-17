Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742AbaAQUiB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 15:38:01 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33303 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332AbaAQUh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 15:37:58 -0500
Date: Fri, 17 Jan 2014 15:37:38 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Graf <tgraf@suug.ch>, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 1/6] cgroup: make CONFIG_NET_CLS_CGROUP and
 CONFIG_NETPRIO_CGROUP bool instead of tristate
Message-ID: <20140117203738.GE19452@hmsreliant.think-freely.org>
References: <1389982317-22225-1-git-send-email-tj@kernel.org>
 <1389982317-22225-2-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389982317-22225-2-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 17, 2014 at 01:11:52PM -0500, Tejun Heo wrote:
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
> Cc: Neil Horman <nhorman@tuxdriver.com>
> Cc: Thomas Graf <tgraf@suug.ch>
> Cc: "David S. Miller" <davem@davemloft.net>
Acked-by: Neil Horman <nhorman@tuxdriver.com>


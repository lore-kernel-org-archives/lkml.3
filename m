Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751669AbaKKSab (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 13:30:31 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:60042 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbaKKSaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 13:30:30 -0500
Date: Tue, 11 Nov 2014 13:30:27 -0500 (EST)
Message-Id: <20141111.133027.1109527863491750125.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, courmisch@gmail.com
Subject: Re: [RFC PATCH net-next] net: Convert LIMIT_NETDEBUG to
 net_dbg_ratelimited
From: David Miller <davem@davemloft.net>
In-Reply-To: <1415560642.23530.43.camel@perches.com>
References: <1415307221.21526.0.camel@perches.com>
	<20141108.204202.2273082249078358608.davem@davemloft.net>
	<1415560642.23530.43.camel@perches.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 11 Nov 2014 10:30:29 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Sun, 09 Nov 2014 11:17:22 -0800

> Use the more common dynamic_debug capable net_dbg_ratelimited
> and remove the LIMIT_NETDEBUG macro.
> 
> This may have some negative impact on messages that were
> emitted at KERN_INFO that are not not enabled at all unless
> DEBUG is defined or dynamic_debug is enabled.  Even so, 
> these messages are now _not_ emitted by default.
> 
> This eliminates the use of the net_msg_warn sysctl
> "/proc/sys/net/core/warnings".
> 
> All messages are still ratelimited.
> 
> Some KERN_LEVEL uses are changed to KERN_DEBUG.
> 
> Miscellanea:
> 
> o Update the sysctl documentation
> o Remove the embedded uses of pr_fmt
> o Coalesce format fragments
> o Realign arguments
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
> 
> Let me know if you want this consolidate patch broken up
> into multiple patches or any of the messages and the
> macro kept.

No objections, please respin with the variable moved and the EXPORT_SYMBOL
removed.

Thanks.

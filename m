Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761Ab3LTAVk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 19:21:40 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:37086 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756362Ab3LTAVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 19:21:38 -0500
Date: Thu, 19 Dec 2013 19:21:36 -0500 (EST)
Message-Id: <20131219.192136.1089859619183118911.davem@davemloft.net>
To: leigh@solinno.co.uk
Cc: nschichan@freebox.fr, linux@arm.linux.org.uk, jason@lakedaemon.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        florian@openwrt.org, linux-arm-kernel@lists.infradead.org,
        sebastian.hesselbarth@gmail.com
Subject: Re: [PATCH v2] net: mvmdio: fix interrupt timeout handling
From: David Miller <davem@davemloft.net>
In-Reply-To: <1387458588-17231-1-git-send-email-leigh@solinno.co.uk>
References: <52B2D97F.4070200@gmail.com>
	<1387458588-17231-1-git-send-email-leigh@solinno.co.uk>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 19 Dec 2013 16:21:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Leigh Brown <leigh@solinno.co.uk>
Date: Thu, 19 Dec 2013 13:09:48 +0000

> This version corrects the whitespace issue.
> 
> orion_mdio_wait_ready uses wait_event_timeout to wait for the
> SMI interrupt to fire.  wait_event_timeout waits for between
> "timeout - 1" and "timeout" jiffies.  In this case a 1ms timeout
> when HZ is 1000 results in a wait of 0 to 1 jiffies, causing
> premature timeouts.
> 
> This fix ensures a minimum timeout of 2 jiffies, ensuring
> wait_event_timeout will always wait at least 1 jiffie.
> 
> Issue reported by Nicolas Schichan.
> 
> Tested-by: Nicolas Schichan <nschichan@freebox.fr>
> Signed-off-by: Leigh Brown <leigh@solinno.co.uk>

Applied, and queued up for -stable.

I wonder how many other wait_event_timeout() users potentially have
this problem.

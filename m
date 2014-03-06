Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410AbaCFVG0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 16:06:26 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:33326 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbaCFVGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 16:06:24 -0500
Date: Thu, 06 Mar 2014 16:06:22 -0500 (EST)
Message-Id: <20140306.160622.59358366688518505.davem@davemloft.net>
To: mkl@pengutronix.de
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH] net: sched: dev_deactivate_many(): use msleep(1)
 instead of yield() to wait for outstanding qdisc_run calls
From: David Miller <davem@davemloft.net>
In-Reply-To: <1393976987-23555-1-git-send-email-mkl@pengutronix.de>
References: <1393976987-23555-1-git-send-email-mkl@pengutronix.de>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 06 Mar 2014 13:06:24 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>
Date: Wed,  5 Mar 2014 00:49:47 +0100

> @@ -839,7 +839,7 @@ void dev_deactivate_many(struct list_head *head)
>  	/* Wait for outstanding qdisc_run calls. */
>  	list_for_each_entry(dev, head, unreg_list)
>  		while (some_qdisc_is_busy(dev))
> -			yield();
> +			msleep(1)
>  }

I don't understand this.

yield() should really _mean_ yield.

The intent of a yield() call, like this one here, is unambiguously
that the current thread cannot do anything until some other thread
gets onto the cpu and makes forward progress.

Therefore it should allow lower priority threads to run, not just
equal or higher priority ones.

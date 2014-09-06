Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751158AbaIFANO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 20:13:14 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:57760 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbaIFANL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 20:13:11 -0400
Date: Fri, 05 Sep 2014 17:13:06 -0700 (PDT)
Message-Id: <20140905.171306.1460013939580748402.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: prashant@broadcom.com, bpoirier@suse.de, mchan@broadcom.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v6 4/4] tg3: Fix tx_pending checks for tg3_tso_bug
From: David Miller <davem@davemloft.net>
In-Reply-To: <1409961810.26422.149.camel@edumazet-glaptop2.roam.corp.google.com>
References: <1409880647-14887-5-git-send-email-bpoirier@suse.de>
	<1409960135.18724.33.camel@prashant>
	<1409961810.26422.149.camel@edumazet-glaptop2.roam.corp.google.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 05 Sep 2014 17:13:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Fri, 05 Sep 2014 17:03:30 -0700

> Instead of this private helper (and pretty limited one btw), we could
> add a core function, that would build skbs with order-0 fragments.
> 
> Instead of skb_linearize(), I guess many call sites could instead use
> this new helper.
> 
> Because as you said, skb_linearize() of one 64KB GSO packet can ask
> order-5 allocations, and this generally does not work reliably.

xen-netback could make use of this helper too.

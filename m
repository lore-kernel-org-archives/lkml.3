Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961Ab3KAWBw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 18:01:52 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:59209 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639Ab3KAWBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 18:01:50 -0400
Date: Fri, 01 Nov 2013 18:01:47 -0400 (EDT)
Message-Id: <20131101.180147.629210014672277622.davem@davemloft.net>
To: xiyou.wangcong@gmail.com
Cc: mchan@broadcom.com, tdmackey@booleanhaiku.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bnx2: Use dev_kfree_skb_any() in bnx2_tx_int()
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAM_iQpXPrEj619=PRaKN4PxgOoEB96U0mLFS65AzXOezSWvhxQ@mail.gmail.com>
References: <CAM_iQpWAbSWVeAMwhQADTwO_RdYUXfog-wG9gs4+Zek0g_5Oyg@mail.gmail.com>
	<20131031.002602.2030884257299947291.davem@davemloft.net>
	<CAM_iQpXPrEj619=PRaKN4PxgOoEB96U0mLFS65AzXOezSWvhxQ@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Fri, 01 Nov 2013 15:01:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Thu, 31 Oct 2013 21:19:16 -0700

> 2013年10月30日 下午9:26于 "David Miller" <davem@davemloft.net>写道：
>>
>> We have to provide a softint compatible environment for this callback
>> to run in else everything is completely broken.
>>
>> All these drivers can safely assume softirq safe locking is
>> sufficient, you're suggesting we need to take this hardirq safety and
>> I'm really not willing to allow things to go that far.  A lot of
>> effort has been expended precisely to avoid that kind of overhead and
>> cost.
> 
> Alright, I am thinking to move netpoll_poll_dev() to a delayed work.
 
What if the printk is outputting a message that will help us discover
that work queues are deadlocked?

You can't delay the message, because every layer of indirection you
add increases the possibility that the message it never seen.  You
have to do it synchronously.

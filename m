Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817Ab3J3VcE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 17:32:04 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:34663 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529Ab3J3VcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 17:32:02 -0400
Date: Wed, 30 Oct 2013 17:32:00 -0400 (EDT)
Message-Id: <20131030.173200.2256841895208134119.davem@davemloft.net>
To: xiyou.wangcong@gmail.com
Cc: tdmackey@booleanhaiku.com, mchan@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bnx2: Use dev_kfree_skb_any() in bnx2_tx_int()
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAM_iQpV6ufX5-OOrNQtsXH0_9itjU-FriOoutyKfDEWdg-irQw@mail.gmail.com>
References: <CAM_iQpXzJOxZ3MFNthKw5ye=WcxDWbiPaHuL=pHMz7D1R4nJ+w@mail.gmail.com>
	<20131030.024003.1476890051483056287.davem@davemloft.net>
	<CAM_iQpV6ufX5-OOrNQtsXH0_9itjU-FriOoutyKfDEWdg-irQw@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 30 Oct 2013 14:32:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Wed, 30 Oct 2013 12:23:52 -0700

> On Tue, Oct 29, 2013 at 11:40 PM, David Miller <davem@davemloft.net> wrote:
>> From: Cong Wang <xiyou.wangcong@gmail.com>
>> Date: Tue, 29 Oct 2013 20:50:08 -0700
>>
>>> Normally ->poll() is called in softirq context, while netpoll could
>>> be called in any context depending on its caller.
>>
>> It still makes amends to make the execution context still looks
>> "compatible" as far as locking et al. is concerned.
> 
> Adjusting netpoll code for IRQ context is much harder
> than just calling dev_kfree_skb_any()...
> 
> What's more, we have similar change before:
> 
> commit ed79bab847d8e5a2986d8ff43c49c6fb8ee3265f
> Author: Eric Dumazet <eric.dumazet@gmail.com>
> Date:   Wed Oct 14 14:36:43 2009 +0000
> 
>     virtio_net: use dev_kfree_skb_any() in free_old_xmit_skbs()

Explain to me then why other ethernet drivers implemented identically,
such as tg3, can use plain dev_kfree_skb() just fine?

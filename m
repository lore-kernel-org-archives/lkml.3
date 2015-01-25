Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478AbbAYGnp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 01:43:45 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:60349 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbbAYGnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 01:43:43 -0500
Date: Sat, 24 Jan 2015 22:43:42 -0800 (PST)
Message-Id: <20150124.224342.425895080003524375.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: sfeldma@gmail.com, netdev@vger.kernel.org, nic_swsd@realtek.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next 1/7] r8152: adjust rx_bottom
From: David Miller <davem@davemloft.net>
In-Reply-To: <0835B3720019904CB8F7AA43166CEEB2EE6E9F@RTITMBSV03.realtek.com.tw>
References: <0835B3720019904CB8F7AA43166CEEB2EE6E76@RTITMBSV03.realtek.com.tw>
	<20150119.215220.720365670558757349.davem@davemloft.net>
	<0835B3720019904CB8F7AA43166CEEB2EE6E9F@RTITMBSV03.realtek.com.tw>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sat, 24 Jan 2015 22:43:42 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Tue, 20 Jan 2015 03:24:52 +0000

>  David Miller [mailto:davem@davemloft.net] 
>> Sent: Tuesday, January 20, 2015 10:52 AM
> [...]
>> agg->list is not local, you have to use a spinlock to protect
>> modifications to it, some other sites which modify agg->list do take
>> the lock properly.
>> 
>> You cannot modify a list like agg->list without proper locking.
> 
> Excuse me. I don't understand.
> 
> Before step1
>    tp_rx_done->listA->listB->listC->listD->...
>    rx_queue->
> Because the other function would chage tp->rx_done,
> I need move the lists with spin lock.
> 
> After step1
>    tp_rx_done->
>    rx_queue->listA->listB->listC->listD->...
> 
> Now I dequeue one of the lists from the list_head and
> deal with it.
>    tp_rx_done->
>    rx_queue->listA->listC->listD->...
>                     listB
> 
> Then, if I want to put it back to rx_queue, I have to
> use spin lock. Why? No other function would chage
> rx_queue and the items in it.

What keeps rtl_start_rx() from running in parallel with
r8152_submit_rx(), or any other accessor of the RX agg->list?

You also keep using different terminology from me when
discussing what lists do or do not need protection, and that
is going to make it difficult for anyone to follow our
conversation at all.

We're talking specifically about RX agg->list objects and
whether access to them need synchronization or not.


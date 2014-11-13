Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934332AbaKMVWo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 16:22:44 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:59897 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934114AbaKMVWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 16:22:42 -0500
Date: Thu, 13 Nov 2014 16:22:40 -0500 (EST)
Message-Id: <20141113.162240.1823683928052355016.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] r8152: adjust rtl_start_rx
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141112.223146.2221136950144767962.davem@davemloft.net>
References: <20141112.144949.645590790916569141.davem@davemloft.net>
	<0835B3720019904CB8F7AA43166CEEB2ECE8EF@RTITMBSV03.realtek.com.tw>
	<20141112.223146.2221136950144767962.davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 13 Nov 2014 13:22:42 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Wed, 12 Nov 2014 22:31:46 -0500 (EST)

> From: Hayes Wang <hayeswang@realtek.com>
> Date: Thu, 13 Nov 2014 02:31:14 +0000
> 
>> My last method which I mentioned yesterday is similar to
>> this one. The difference is that I would re-use the rx
>> buffers, so I have to add them to the list for re-submitting,
>> not alwayes allocate new one.
>> 
>> Although one rx buffer could contain many packets, I don't
>> think the whole size of the rx buffer is alwayes used.
>> Therefore, I re-use the rx buffers to avoid allocating
>> the 16K bytes rx buffer alwayes. This also makes sure that
>> I always have the buffers to submit without allocating new
>> one.
>> 
>> If you could accept this, I would modify this patch by
>> this way.
> 
> I'll reread your original patch and think some more about this.

What if even the first r8152_submit_rx() fails?  What ever will cause
any of these retries to trigger at all?

Second, why does your patch increment 'i' with 'i++;' in the error
break path?  You should mark the first failed entry as unallocated
with actual_length == 0 and place it on the rx_done queue.

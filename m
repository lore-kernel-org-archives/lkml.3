Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab3C1SBF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 14:01:05 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:43748 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249Ab3C1SBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 14:01:01 -0400
Date: Thu, 28 Mar 2013 14:00:57 -0400 (EDT)
Message-Id: <20130328.140057.1029413611130335133.davem@davemloft.net>
To: tgraf@suug.ch
Cc: honkiko@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stephen@networkplumber.org
Subject: Re: [PATCH 1/6] net-next: replace obsolete NLMSG_* with type safe
 nlmsg_*
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130328143216.GC23043@casper.infradead.org>
References: <1364402824-32680-1-git-send-email-honkiko@gmail.com>
	<20130328143216.GC23043@casper.infradead.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Thu, 28 Mar 2013 11:00:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Graf <tgraf@suug.ch>
Date: Thu, 28 Mar 2013 14:32:16 +0000

> On 03/28/13 at 12:47am, Hong Zhiguo wrote:
>> diff --git a/net/ipv4/udp_diag.c b/net/ipv4/udp_diag.c
>> index 505b30a..467fb92 100644
>> --- a/net/ipv4/udp_diag.c
>> +++ b/net/ipv4/udp_diag.c
>> @@ -64,9 +64,9 @@ static int udp_dump_one(struct udp_table *tbl, struct sk_buff *in_skb,
>>  		goto out;
>>  
>>  	err = -ENOMEM;
>> -	rep = alloc_skb(NLMSG_SPACE((sizeof(struct inet_diag_msg) +
>> -				     sizeof(struct inet_diag_meminfo) +
>> -				     64)), GFP_KERNEL);
>> +	rep = nlmsg_new(sizeof(struct inet_diag_msg) +
>> +				     sizeof(struct inet_diag_meminfo) + 64,
>> +				     GFP_KERNEL);
> 
> This is formatted incorrectly, otherwise the patch looks good.

I'll fix it up when I commit.

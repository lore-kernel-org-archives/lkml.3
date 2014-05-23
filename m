Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305AbaEWQqN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 12:46:13 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53585 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178AbaEWQqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 12:46:11 -0400
Date: Fri, 23 May 2014 12:46:04 -0400 (EDT)
Message-Id: <20140523.124604.1978823006121667147.davem@davemloft.net>
To: jim_baxter@mentor.com
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, kamal@canonical.com, bhutchings@solarflare.com,
        edumazet@google.com, mszeredi@suse.cz, fw@strlen.de
Subject: Re: skbuff truesize incorrect.
From: David Miller <davem@davemloft.net>
In-Reply-To: <537F130F.6080901@mentor.com>
References: <537E5C63.7080607@mentor.com>
	<20140522.165833.414855217799383878.davem@davemloft.net>
	<537F130F.6080901@mentor.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 23 May 2014 09:46:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Baxter <jim_baxter@mentor.com>
Date: Fri, 23 May 2014 10:21:19 +0100

> On 22/05/14 21:58, David Miller wrote:
>> From: Jim Baxter <jim_baxter@mentor.com>
>> Date: Thu, 22 May 2014 21:21:55 +0100
>> 
>>> If there are multiple clones for an skb all pointing at the same data,
>>> will that distort the memory used when they all have the same truesize?
>> 
>> What is distorted about it?
>> 
>> Each clone references exactly that much backing memory.
>>
> 
> Thank you for you help, I think distorted was the wrong word.
> 
> 
> I think I am confused what truesize is used for it looks like it is used
> to deallocate memory, is this correct?

It's used to determine how much to charge sockets against their read
and write memory limits.


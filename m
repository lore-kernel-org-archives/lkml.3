Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057Ab3J2VnB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 17:43:01 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:48993 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab3J2VnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 17:43:00 -0400
Date: Tue, 29 Oct 2013 17:42:58 -0400 (EDT)
Message-Id: <20131029.174258.1677867676998240250.davem@davemloft.net>
To: mroos@linux.ee
Cc: hannes@stressinduktion.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, steffen.klassert@secunet.com
Subject: Re: 3.12-rc7 regression - network panic from ipv6
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.SOC.1.00.1310292338010.22172@math.ut.ee>
References: <alpine.SOC.1.00.1310292221550.19416@math.ut.ee>
	<20131029210758.GA18323@order.stressinduktion.org>
	<alpine.SOC.1.00.1310292338010.22172@math.ut.ee>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 29 Oct 2013 14:42:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Meelis Roos <mroos@linux.ee>
Date: Tue, 29 Oct 2013 23:38:28 +0200 (EET)

>> > Some bad news - in a system where 3.12-rc6 and earlier worked fine, 
>> > 3.12-rc7 panics or hangs repeatedly with network traffic (torrent being 
>> > good test). First there is BUG from ipv6 code, followed by panic.
>> 
>> Could you do a bisect on this? There seems to be one commit for this
>> particular function _decode_session6:
>> 
>> commit bafd4bd4dcfa13145db7f951251eef3e10f8c278
>> Author: Steffen Klassert <steffen.klassert@secunet.com>
>> Date:   Mon Sep 9 10:38:38 2013 +0200
>> 
>>     xfrm: Decode sessions with output interface.
>>     
>>     The output interface matching does not work on forward
>>     policy lookups, the output interface of the flowi is
>>     always 0. Fix this by setting the output interface when
>>     we decode the session.
>> 
>> Maybe try to just revert this change locally and try again?
> 
> Yes, just reverting this patch on top of rc7 gets rid of the problem for 
> me.

Steffen please fix this or I'll have to revert.

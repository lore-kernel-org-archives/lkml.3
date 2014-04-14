Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163AbaDNSC5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 14:02:57 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:56738 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177AbaDNSCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 14:02:55 -0400
Date: Mon, 14 Apr 2014 14:02:53 -0400 (EDT)
Message-Id: <20140414.140253.788885546068554928.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: nasa4836@gmail.com, jchapman@katalix.com, edumazet@google.com,
        joe@perches.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [BUG] A panic caused by null pointer dereference aftering
 updating to
From: David Miller <davem@davemloft.net>
In-Reply-To: <1397498082.4222.29.camel@edumazet-glaptop2.roam.corp.google.com>
References: <1397497204.4222.28.camel@edumazet-glaptop2.roam.corp.google.com>
	<20140414.134901.2191404761213317963.davem@davemloft.net>
	<1397498082.4222.29.camel@edumazet-glaptop2.roam.corp.google.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 14 Apr 2014 11:02:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Mon, 14 Apr 2014 10:54:42 -0700

> On Mon, 2014-04-14 at 13:49 -0400, David Miller wrote:
> 
>> Yep that would handle the l2tp cases, but vxlan needs something different
>> since it goes through iptunnel_xmit().
>> 
>> So perhaps as a quick fix we can add an 'sk' arg to both
>> ip_queue_xmit() and ip_local_out().
> 
> Right, I am working on this right now.

Thanks a lot Eric.

BTW, it occurs to me that there may be some other spots in the output path
that expect that if SKB is ETH_P_IP then skb->sk is IP socket.  For example
somewhere in netfilter or packet classifier paths.

Just FYI... that was one of the things I was going to audit.

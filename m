Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751150AbaJAEYv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 00:24:51 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:47245 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861AbaJAEYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 00:24:49 -0400
Message-ID: <1412137489.16704.26.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH net v6 4/4] tg3: Fix tx_pending checks for tg3_tso_bug
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Prashant <prashant@broadcom.com>
Cc: David Miller <davem@davemloft.net>, bpoirier@suse.de, mchan@broadcom.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 30 Sep 2014 21:24:49 -0700
In-Reply-To: <542B71B1.4020103@broadcom.com>
References: <1409960135.18724.33.camel@prashant>
		<1409961810.26422.149.camel@edumazet-glaptop2.roam.corp.google.com>
		<20140905.171306.1460013939580748402.davem@davemloft.net>
	 <20140905.213902.1124686922505260665.davem@davemloft.net>
	 <542B71B1.4020103@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-09-30 at 20:14 -0700, Prashant wrote:

> Sorry about the late reply, out of all the HW bug conditions checked in 
> tg3_tx_frag_set() the most frequently hit condition is the short 8 byte 
> dma bug, where the chip cannot handle TX descriptors whose data buffer 
> is 8 bytes or less. Most of the LSO skb's given to the driver has their 
> fragments filled upto PAGE_SIZE (expect the last fragment depending on 
> skb->len). And if such a LSO skb's last fragment meets the 8 bytes HW 
> bug condition the above routine will not help workaround this particular 
> case.

Thats pretty easy to work around.

Say rebuilt skb has N frags (N > 1 given your description)

They are numbered 0, ... N-2, N-1

Instead of filling N-2 completely, fill it to PAGE_SIZE-8, so that last
frag has at least 8 bytes in it.

Also take a look at commit 2e4e44107176d552f8bb1bb76053e850e3809841
("net: add alloc_skb_with_frags() helper")




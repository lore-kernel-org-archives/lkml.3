Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852AbaJAS3r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 14:29:47 -0400
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:43926 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065AbaJAS3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 14:29:45 -0400
X-IronPort-AV: E=Sophos;i="5.04,633,1406617200"; 
   d="scan'208";a="47052285"
Message-ID: <542C4817.60301@broadcom.com>
Date: Wed, 1 Oct 2014 11:29:43 -0700
From: Prashant <prashant@broadcom.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: David Miller <davem@davemloft.net>, <bpoirier@suse.de>,
        <mchan@broadcom.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net v6 4/4] tg3: Fix tx_pending checks for tg3_tso_bug
References: <1409960135.18724.33.camel@prashant>		<1409961810.26422.149.camel@edumazet-glaptop2.roam.corp.google.com>		<20140905.171306.1460013939580748402.davem@davemloft.net>	 <20140905.213902.1124686922505260665.davem@davemloft.net>	 <542B71B1.4020103@broadcom.com> <1412137489.16704.26.camel@edumazet-glaptop2.roam.corp.google.com>
In-Reply-To: <1412137489.16704.26.camel@edumazet-glaptop2.roam.corp.google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 9/30/2014 9:24 PM, Eric Dumazet wrote:
> On Tue, 2014-09-30 at 20:14 -0700, Prashant wrote:
>
>> Sorry about the late reply, out of all the HW bug conditions checked in
>> tg3_tx_frag_set() the most frequently hit condition is the short 8 byte
>> dma bug, where the chip cannot handle TX descriptors whose data buffer
>> is 8 bytes or less. Most of the LSO skb's given to the driver has their
>> fragments filled upto PAGE_SIZE (expect the last fragment depending on
>> skb->len). And if such a LSO skb's last fragment meets the 8 bytes HW
>> bug condition the above routine will not help workaround this particular
>> case.
>
> Thats pretty easy to work around.
>
> Say rebuilt skb has N frags (N > 1 given your description)
>
> They are numbered 0, ... N-2, N-1
>
> Instead of filling N-2 completely, fill it to PAGE_SIZE-8, so that last
> frag has at least 8 bytes in it.

definitely it can be tweaked to match what is needed with additional 
workarounds.

>
> Also take a look at commit 2e4e44107176d552f8bb1bb76053e850e3809841
> ("net: add alloc_skb_with_frags() helper")
>
>
This helper is much modular/flexible than the initial proposed one. Thanks.
>

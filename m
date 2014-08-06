Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390AbaHFSJo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 14:09:44 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:36006 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754355AbaHFSJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 14:09:43 -0400
X-IronPort-AV: E=Sophos;i="5.01,813,1400025600"; 
   d="scan'208";a="160020553"
Message-ID: <53E26F64.6080301@citrix.com>
Date: Wed, 6 Aug 2014 19:09:40 +0100
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <steffen.klassert@secunet.com>, <minipli@googlemail.com>,
        <dborkman@redhat.com>, <tgraf@suug.ch>, <joe@perches.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xenproject.org>
Subject: Re: [PATCH net-next v4 4/4 RFC] pktgen: Allow sending IPv4 TCP packets
References: <1407159435-7951-1-git-send-email-zoltan.kiss@citrix.com>	<1407159435-7951-5-git-send-email-zoltan.kiss@citrix.com> <20140805.130901.2116578415179622318.davem@davemloft.net>
In-Reply-To: <20140805.130901.2116578415179622318.davem@davemloft.net>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/14 21:09, David Miller wrote:
> From: Zoltan Kiss <zoltan.kiss@citrix.com>
> Date: Mon, 4 Aug 2014 14:37:14 +0100
>
>> @@ -3559,6 +3616,14 @@ static void pktgen_xmit(struct pktgen_dev *pkt_dev)
>>   		pkt_dev->last_pkt_size = pkt_dev->skb->len;
>>   		pkt_dev->allocated_skbs++;
>>   		pkt_dev->clone_count = 0;	/* reset counter */
>> +
>> +		if (netif_needs_gso(pkt_dev->skb, netif_skb_features(pkt_dev->skb))) {
>> +			pr_err("Device don't have necessary GSO features! netif_skb_features: %llX summed %u\n",
>> +			       netif_skb_features(pkt_dev->skb),
>> +			       pkt_dev->skb->ip_summed);
>> +			pkt_dev->sofar++;
>> +			goto out;
>> +		}
>>   	}
>>
>>   	if (pkt_dev->delay && pkt_dev->last_ok)
>
> Woe be to the person who actually triggers this condition.  This function
> happens potentially millions of times per second, there is no value in
> emitting a log message every time.
Indeed, I'll put a ratelimit around it.

Zoli


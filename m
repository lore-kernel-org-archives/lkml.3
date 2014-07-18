Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965642AbaGRKQp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 06:16:45 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:39801 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965268AbaGRKQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 06:16:41 -0400
Message-ID: <53C8F3BC.4060607@gmail.com>
Date: Fri, 18 Jul 2014 15:45:24 +0530
From: Varka Bhadram <varkabhadram@gmail.com>
Organization: CDAC-HYD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Neil Armstrong <superna9999@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] net: macb: Separate rx and tx ring init function
References: <53C8EE60.8020707@gmail.com> <53C8F280.9040507@gmail.com> <53C8F34D.9090503@gmail.com>
In-Reply-To: <53C8F34D.9090503@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2014 03:43 PM, Neil Armstrong wrote:
> Le 18/07/2014 12:10, Varka Bhadram a écrit :
>> On 07/18/2014 03:22 PM, Neil Armstrong wrote:
>>> A single method is called to initialize the TX and RX
>>> rings. Separate the methods into distinct ones for
>>> MACB and GEM context.
>>>
>>> Signed-off-by: Neil Armstrong <narmstrong@neotion.com>
>>> ---
>>>    drivers/net/ethernet/cadence/macb.c |   33 ++++++++++++++++++++++++---------
>>>    drivers/net/ethernet/cadence/macb.h |    3 ++-
>>>    2 files changed, 26 insertions(+), 10 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/cadence/macb.c b/drivers/net/ethernet/cadence/macb.c
>>> index e9daa07..20ad483 100644
>>> --- a/drivers/net/ethernet/cadence/macb.c
>>> +++ b/drivers/net/ethernet/cadence/macb.c
>>> @@ -1219,7 +1219,14 @@ out_err:
>>>    	return -ENOMEM;
>>>    }
>>>    
>>> -static void gem_init_rings(struct macb *bp)
>>> +static void gem_init_rx_rings(struct macb *bp)
>>> +{
>>> +	bp->rx_tail = bp->rx_prepared_head = 0;
>>> +
>>> +	gem_rx_refill(bp);
>>> +}
>>> +
>>> +static void gem_init_tx_rings(struct macb *bp)
>>>    {
>>>    	int i;
>>>    
>>> @@ -1229,12 +1236,10 @@ static void gem_init_rings(struct macb *bp)
>>>    	}
>>>    	bp->tx_ring[TX_RING_SIZE - 1].ctrl |= MACB_BIT(TX_WRAP);
>>>    
>>> -	bp->rx_tail = bp->rx_prepared_head = bp->tx_head = bp->tx_tail = 0;
>>> -
>>> -	gem_rx_refill(bp);
>>> +	bp->tx_head = bp->tx_tail = 0;
>> This is not the preferred way of doing it....
>>
>> multiple assignments should be avoided
> Should I change it ? I only moved the lines, the logic hasn't changed.
>
Yes. we can change the logic also....  :-)

-- 
Regards,
Varka Bhadram.


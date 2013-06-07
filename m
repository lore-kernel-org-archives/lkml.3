Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab3FGIgo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 04:36:44 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:33473 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab3FGIgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 04:36:41 -0400
Message-ID: <51B19B94.6060301@atmel.com>
Date: Fri, 7 Jun 2013 10:36:36 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <netdev@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <plagnioj@jcrosoft.com>,
        <hein_tibosch@yahoo.es>, <s.trumtrar@pengutronix.de>,
        <michal.simek@xilinx.com>, <monstr@monstr.eu>
Subject: Re: [PATCH 0/2 v4] net/macb: RX path enhancement
References: <cover.1370418770.git.nicolas.ferre@atmel.com> <20130606.162358.506642916485125446.davem@davemloft.net>
In-Reply-To: <20130606.162358.506642916485125446.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/2013 01:23, David Miller :
> From: Nicolas Ferre <nicolas.ferre@atmel.com>
> Date: Wed, 5 Jun 2013 09:57:10 +0200
>
>> Here is the patch series for modifying the RX path in macb driver.
>> This change applies on GEM variant of the Cadence IP and introduces
>> function pointers to match the path to the proper adapter. The move
>> to RX buffers adapted to MTU and that can be DMAed directly in SKB
>> is done in two steps but can be merged in a single patch.
>>
>> v4: - rebased on top of net-next
>>      - removed the last patch of the series which needs rework
>>
>> v3: - rebased on top of net-next (containing recently added
>>        net/macb: fix ISR clear-on-write behavior only for some SoC)
>>      - added the ___cacheline_aligned_in_smp qualifier to napi field
>>        following Ben Hutchings' advice
>>
>> v2: - gave up the idea of using non-coherent memory for
>>        rx buffers
>>      - addition of the struct macb layout optimization
>
> Applied to net-next but I had to fix the printf format strings
> used in macb_init_rx_buffer_size().
>
> netdev->mtu is "unsigned int" so "%u"
> bp->rx_buffer_size is "size_t" so "%Zu"
>
> otherwise we get build warnings.

Thanks David.

Best regards,
-- 
Nicolas Ferre

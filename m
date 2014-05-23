Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751127AbaEWIGR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 04:06:17 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:41458 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbaEWIGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 04:06:13 -0400
Message-ID: <537F0171.5070902@6wind.com>
Date: Fri, 23 May 2014 10:06:09 +0200
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reply-To: nicolas.dichtel@6wind.com
Organization: 6WIND
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: =?UTF-8?B?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@freescale.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Lei Xu <Lei.Xu@freescale.com>, Sandeep Malik <Sandeep.Malik@freescale.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC ipsec-next] xfrm: make sha256 icv truncation length RFC-compliant
References: <1400771437-14096-1-git-send-email-horia.geanta@freescale.com> <1400771437-14096-2-git-send-email-horia.geanta@freescale.com> <537E1FD8.8030504@6wind.com> <537EEAA6.7000506@freescale.com>
In-Reply-To: <537EEAA6.7000506@freescale.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 23/05/2014 08:28, Horia Geantă a écrit :
> On 5/22/2014 7:03 PM, Nicolas Dichtel wrote:
>> Le 22/05/2014 17:10, Horia Geanta a écrit :
>>> From: Lei Xu <Lei.Xu@freescale.com>
>>>
>>> Currently the sha256 icv truncation length is set to 96bit
>>> while the length is defined as 128bit in RFC4868.
>>> This may result in somer errors when working with other IPsec devices
>>> with the standard truncation length.
>>> Thus, change the sha256 truncation length from 96bit to 128bit.
>> The patch was already proposed, but it was kept as-is for userspace
>> compatibility.
>>
>> See: https://lkml.org/lkml/2012/3/7/431
>
> Thanks, somehow I missed that.
>
> So this just means bad luck for user space tools (for e.g. ipsec-tools - setkey,
> racoon - and any other PF_KEY-based tool) that AFAICT cannot override the
> default truncated icv size, right?
You can change the default value with the netlink attribute
XFRMA_ALG_AUTH_TRUNC (option 'auth-trunc' in iproute2).


Regards,
Nicolas

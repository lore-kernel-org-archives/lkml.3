Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759866Ab3GaPKs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 11:10:48 -0400
Received: from forward-corp1g.mail.yandex.net ([95.108.253.251]:48225 "EHLO
	forward-corp1g.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751803Ab3GaPKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 11:10:46 -0400
X-Greylist: delayed 437 seconds by postgrey-1.27 at vger.kernel.org; Wed, 31 Jul 2013 11:10:46 EDT
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Message-ID: <51F9273B.2020408@yandex-team.ru>
Date: Wed, 31 Jul 2013 19:03:23 +0400
From: Roman Gushchin <klamm@yandex-team.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: "David S. Miller" <davem@davemloft.net>, raise.sail@gmail.com,
        ebiederm@xmission.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: check net.core.somaxconn sysctl values
References: <51F917CF.7010905@yandex-team.ru> <1375281457.10515.98.camel@edumazet-glaptop>
In-Reply-To: <1375281457.10515.98.camel@edumazet-glaptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31.07.2013 18:37, Eric Dumazet wrote:
> On Wed, 2013-07-31 at 17:57 +0400, Roman Gushchin wrote:
>> It's possible to assign an invalid value to the net.core.somaxconn
>> sysctl variable, because there is no checks at all.
>>
>> The sk_max_ack_backlog field of the sock structure is defined as
>> unsigned short. Therefore, the backlog argument in inet_listen()
>> shouldn't exceed USHRT_MAX. The backlog argument in the listen() syscall
>> is truncated to the somaxconn value. So, the somaxconn value shouldn't
>> exceed 65535 (USHRT_MAX).
>> Also, negative values of somaxconn are meaningless.
>>
>> before:
>> $ sysctl -w net.core.somaxconn=256
>> net.core.somaxconn = 256
>> $ sysctl -w net.core.somaxconn=65536
>> net.core.somaxconn = 65536
>> $ sysctl -w net.core.somaxconn=-100
>> net.core.somaxconn = -100
>>
>> after:
>> $ sysctl -w net.core.somaxconn=256
>> net.core.somaxconn = 256
>> $ sysctl -w net.core.somaxconn=65536
>> error: "Invalid argument" setting key "net.core.somaxconn"
>> $ sysctl -w net.core.somaxconn=-100
>> error: "Invalid argument" setting key "net.core.somaxconn"
>>
>> Signed-off-by: Roman Gushchin <klamm@yandex-team.ru>
>> ---
>>    net/core/sysctl_net_core.c | 6 +++++-
>>    1 file changed, 5 insertions(+), 1 deletion(-)
>
>
> We had a discussion about this one month ago, as Changli Gao posted a
> patch. http://patchwork.ozlabs.org/patch/255460/
>
> So proper credits would be nice ;)

Ok :)

> Based on a prior patch from Changli Gao
>
> Reported-by: Changli Gao <xiaosuo@gmail.com>
> Suggested-by: Eric Dumazet <edumazet@google.com>
>
> Acked-by: Eric Dumazet <edumazet@google.com>
>

Thanks!

PS I've forwarded your letter back to the lkml by mistake.
Sorry)

Regards,
Roman


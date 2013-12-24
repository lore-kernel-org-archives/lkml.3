Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650Ab3LXQko (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 11:40:44 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:52166 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316Ab3LXQkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 11:40:42 -0500
Message-ID: <52B9B90E.6040106@cogentembedded.com>
Date: Tue, 24 Dec 2013 20:40:46 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Ding Tianhong <dingtianhong@huawei.com>,
        Michal Ostrowski <mostrows@earthlink.net>,
        Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 06/20] ppp: slight optimization of addr compare
References: <52B96FCD.50901@huawei.com>	 <52B9B559.2060400@cogentembedded.com> <1387902949.2259.51.camel@joe-AO722>
In-Reply-To: <1387902949.2259.51.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 24-12-2013 20:35, Joe Perches wrote:

> []
>>> diff --git a/drivers/net/ppp/pppoe.c b/drivers/net/ppp/pppoe.c
> []
>>> @@ -131,12 +131,13 @@ static inline struct pppoe_net *pppoe_pernet(struct net *net)
>>>
>>>    static inline int cmp_2_addr(struct pppoe_addr *a, struct pppoe_addr *b)
>>>    {
>>> -	return a->sid == b->sid && !memcmp(a->remote, b->remote, ETH_ALEN);
>>> +	return a->sid == b->sid && ether_addr_equal(a->remote,
>>> +							      b->remote);

>>      If it really doesn't fit insto single line, the continuation line should
>> start right under 'a->remote'.

> Better still might be
>
> 	return a->sid == b->sid &&
> 	       ether_addr_equal(a->remote, b->remote);

    Actually, after the second look, I don't know why the line was broken at all.

WBR, Sergei



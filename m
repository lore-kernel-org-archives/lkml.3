Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735Ab3EUPvr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 11:51:47 -0400
Received: from forward-corp1f.mail.yandex.net ([95.108.130.40]:42459 "EHLO
	forward-corp1f.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754691Ab3EUPvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 11:51:45 -0400
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Message-ID: <519B9809.1010408@yandex-team.ru>
Date: Tue, 21 May 2013 19:51:37 +0400
From: Roman Gushchin <klamm@yandex-team.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: paulmck@linux.vnet.ibm.com, Dipankar Sarma <dipankar@in.ibm.com>,
        zhmurov@yandex-team.ru, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] rcu: fix a race in hlist_nulls_for_each_entry_rcu macro
References: <519B38EC.90401@yandex-team.ru>   <20130521120906.GD3578@linux.vnet.ibm.com>  <1369143885.3301.221.camel@edumazet-glaptop>  <519B8908.9080007@yandex-team.ru> <1369150693.3301.233.camel@edumazet-glaptop>
In-Reply-To: <1369150693.3301.233.camel@edumazet-glaptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.05.2013 19:38, Eric Dumazet wrote:
> On Tue, 2013-05-21 at 18:47 +0400, Roman Gushchin wrote:
>
>> This code has the same mistake: it is rcu_dereference_raw(head->first),
>> so there is nothing that prevents gcc to store the (head->first) value
>> in a register.
>
> If other rcu accessors have the same problem, a more complete patch is
> needed.

Ok, I'll try to provide a complete patch ASAP.

>
> Thanks
>
>
>


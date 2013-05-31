Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668Ab3EaRvi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 13:51:38 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:60872 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696Ab3EaRvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 13:51:31 -0400
Message-ID: <51A8E326.70800@cogentembedded.com>
Date: Fri, 31 May 2013 21:51:34 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Davidlohr Bueso <davidlohr.bueso@hp.com>,
        =?ISO-8859-1?Q?Bj=F8rn_Mo?= =?ISO-8859-1?Q?rk?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: skbuff: use _RET_IP_
References: <1369861743.4188.33.camel@buesod1.americas.hpqcorp.net>  <51A6768B.5050603@cogentembedded.com> <87obbsohd1.fsf@nemi.mork.no>  <1369962688.1751.6.camel@buesod1.americas.hpqcorp.net>  <1369977659.10556.34.camel@joe-AO722> <51A8B4A4.1010204@cogentembedded.com> <1370019292.10556.79.camel@joe-AO722>
In-Reply-To: <1370019292.10556.79.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 05/31/2013 08:54 PM, Joe Perches wrote:

>>> Don't use a standalone gcc compiled program to
>>> determine what the kernel outputs.
> []
>>> The kernel output is;
>>> 	printk("0x%lx\n", 0x100ul)		0x100
>>> 	printk("%p\n", (void *)0x100ul)		00000100
>>> 	printk("%#p\n", (void *)0x100ul)	0x00000100
>>> The last one isn't used at all in kernel source. (gcc complains)
>>> It's always "0x%p"
>>       I was talking about using "%#lx", not "%#p". I don't see it in your
>> example.
> "0x%lx" and "%#lx" produce the same output in the kernel.
>
> The latter isn't used very often though.

    It's already used in the same format string in this case. That's why 
I suggested
not to deviate from the existing code.

WBR, Sergei


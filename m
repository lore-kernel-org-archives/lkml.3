Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617AbaJ0Omy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 10:42:54 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:19833 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907AbaJ0Omw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 10:42:52 -0400
Message-ID: <544E59DC.3060906@oracle.com>
Date: Mon, 27 Oct 2014 10:42:36 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: a.ryabinin@samsung.com, pablo@netfilter.org, mschmidt@redhat.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] netlink: don't copy over empty attribute data
References: <54471438.1040907@oracle.com>	<20141022.021508.2011745433893496421.davem@davemloft.net>	<544D849A.4040304@oracle.com> <20141026.220350.2098346782596904995.davem@davemloft.net>
In-Reply-To: <20141026.220350.2098346782596904995.davem@davemloft.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/2014 10:03 PM, David Miller wrote:
> From: Sasha Levin <sasha.levin@oracle.com>
> Date: Sun, 26 Oct 2014 19:32:42 -0400
> 
>> How so? GCC states clearly that you should *never* pass a NULL
>> pointer there:
>>
>> "The pointers passed to memmove (and similar functions in <string.h>) must
>> be non-null even when nbytes==0" (https://gcc.gnu.org/gcc-4.9/porting_to.html).
>>
>> Even if it doesn't dereference it, it can break somehow in a subtle way. Leaving
>> the kernel code assuming that gcc (or any other compiler) would always behave
>> the same in a situation that shouldn't occur.
> 
> Show me a legal way in which one could legally dereference the pointer
> when length is zero, and I'll entertain this patch.

The moment you've triggered an undefined behaviour you have GCC license to
dereference anything it wants. GCC would be well within it's rights
dereferencing a NULL "from".

They even state it clearly in that GCC 4.9 porting guide I've linked above:

"""
Calling copy(p, NULL, 0) can therefore deference a null pointer and crash.

The example above needs to be fixed to avoid the invalid memmove call, for example:


    if (nbytes != 0)
      memmove (dest, src, nbytes);
"""


Thanks,
Sasha

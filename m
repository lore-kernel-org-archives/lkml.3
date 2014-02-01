Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933215AbaBAN6G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 08:58:06 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:57380 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933167AbaBAN5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 08:57:39 -0500
Message-ID: <52ECFD53.7010401@gmail.com>
Date: Sat, 01 Feb 2014 21:57:39 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: James Hogan <james.hogan@imgtec.com>
CC: Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        andreas.dilger@intel.com, Greg KH <gregkh@linuxfoundation.org>,
        bergwolf@gmail.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        oleg.drokin@intel.com, jacques-charles.lafoucriere@cea.fr,
        jinshan.xiong@intel.com, linux-metag@vger.kernel.org,
        Antonio Quartulli <antonio@meshcoding.com>,
        David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] drivers: staging: lustre: lustre: include: add "__attribute__((packed))"
 for the related union
References: <52DA4E6A.1000308@gmail.com> <20140118100547.GS7444@mwanda> <52DA56C2.5010802@gmail.com> <20140118142404.GT7444@mwanda> <52DBA3D4.3090308@gmail.com> <52DD0EFF.2010305@imgtec.com> <20140120123045.GV7444@mwanda> <52DD18A5.1090308@imgtec.com> <20140120125603.GD4815@mwanda> <20140120211356.GG4815@mwanda> <52DE4DA3.7090301@imgtec.com> <52E3A642.7010307@gmail.com>
In-Reply-To: <52E3A642.7010307@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2014 07:55 PM, Chen Gang wrote:
> On 01/21/2014 06:36 PM, James Hogan wrote:
>> Hi Dan,
>>
>> On 20/01/14 21:13, Dan Carpenter wrote:
>>> I made a quick and dirty sparse patch to check for this.  I don't think
>>> I will bother trying to send it to sparse upstream, but you can if you
>>> want to.
>>>
>>> It found 289 unions which might need a __packed added.  The lustre
>>> unions were not in my allmodconfig so they're not listed.
>>
>> Thanks a lot for this, it seems to be useful. I'm adapting it to reduce
>> false negatives (e.g. omitting the check if the struct/union is already
>> packed), and I imagine it could be made to only warn about padded
>> unpacked structs/unions which are used as nested members of packed
>> structs/unions. It wouldn't catch everything but would probably catch a
>> lot of cases that are most likely to be genuine since they would have
>> been packed at the outer level for a reason.
>>
>>> Perhaps there could be a command line option or a pragma so that unions
>>> will work in the kernel.  We don't care about linking to outside
>>> libraries.
>>
>> We still interact with userland via structs and unions, so it would
>> probably have to exclude anything in uapi/.
>>
> 

It seems, our kernel still stick to treate 'pack' region have effect
with both 'align' and 'sizeof'.

So for compiler, could we add one additional cflag parameter to tell
compiler to switch it (compatible with ABI, or satisfy upstream kernel).

And for kernel, it will be OK enough to only append this parameter to
KBUILD_CFLAGS in "arch/metag/Makefile".


Thanks.

> Thank all of you firstly.
> 
> But excuse me, I am still not quit clear that: "what need we do enough
> to solve this feature issue?"
> 
> So I guess our current result is:
> 
>  - It is not a good idea to only let kernel to fit with compiler.
> 
>  - It is not a good idea to only let compiler to fit with kernel.
> 
>  - Need let compiler and kernel to fit with each other:
> 
>    - compiler will print related warning, but not break compiling.
>      so metag compiler need be improvement (check and warn for it).
> 
>    - if check alignment explicitly in kernel source code, it need be
>      fixed within kernel: "apply related patches (pack each struct or
>      union), but the related patch comments need be improved".
> 
> Is what I guess correct?
> 
> Thanks.
> 


-- 
Chen Gang

Open, share and attitude like air, water and life which God blessed

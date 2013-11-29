Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445Ab3K2Wta (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 17:49:30 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:51603 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750905Ab3K2Wt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 17:49:28 -0500
Message-ID: <52991A39.8030103@metafoo.de>
Date: Fri, 29 Nov 2013 23:50:33 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130922 Icedove/17.0.9
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        dmaengine@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH] lib/vsprintf.c: add %paD format specifier for dma_addr_t
 types
References: <1385638084-10719-1-git-send-email-andriy.shevchenko@linux.intel.com>  <1385663555.12210.19.camel@joe-AO722> <1385729760.1871.23.camel@smile> <1385763040.12210.34.camel@joe-AO722>
In-Reply-To: <1385763040.12210.34.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2013 11:10 PM, Joe Perches wrote:
> On Fri, 2013-11-29 at 14:56 +0200, Andy Shevchenko wrote:
>> On Thu, 2013-11-28 at 10:32 -0800, Joe Perches wrote:
>>> On Thu, 2013-11-28 at 13:28 +0200, user.email wrote:
>>>> From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>>>>
>>>> Add the %paD format specifier for printing a dma_addr_t type, since the
>>>> DMA address size on some platforms can vary based on build options,
>>>> regardless of the native integer type.
>>>
>>> OK, but I prefer this one because upper case is
>>> sometimes used to specify upper case only output.
>>> ala %x %X and %pUl %pUL.
>>
>> No objections.
>>
>>> https://lkml.org/lkml/2013/9/12/483
>>
>> Hmm... Still not in kernel. Do you know reason why it so?
>
> It was just for discussion and I didn't sign or push it
> to anyone else.
>
> What's slightly funny is how far back dma_addr_t printk
> discussions go.
>
> http://lkml.indiana.edu/hypermail/linux/kernel/0202.1/1221.html
>
> Anyway, if you think you're going to do a lot of
> transforms of printk("%x", dma_addr_t) with or without
> (unsigned long long) or (u64) casts, I'll submit a signed
> patch to Andrew.
>
> Let me know.
>
> In an aside for Julia Lawall (added to cc's), I tried to
> do a spatch grep for dma_addr_t (and phys_addr_t) types
> that were cast to (unsigned long) or (u64) but I was
> unsuccessful.  Is there something else I need to do?
>
> $ cat dma_addr_t.cocci
> @@
> dma_addr_t foo;
> @@
>
> * (unsigned long long)foo;

Remove the semicolon, otherwise it will only match statements which are nothing 
but the cast.

>
> $ cat t.c
> #include <linux/types.h>
> #include <linux/printk.h>
>
> int foo(dma_addr_t a)
> {
> 	printk("test: %llx\n", (unsigned long long)a);
> }
>
> $ spatch --all-includes --local-includes  -I include/ --sp-file dma_addr_t.cocci t.c
> init_defs_builtins: /usr/local/share/coccinelle/standard.h
> HANDLING: t.c
> $
>
> --
> To unsubscribe from this list: send the line "unsubscribe dmaengine" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


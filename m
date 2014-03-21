Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751328AbaCUTgQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 15:36:16 -0400
Received: from mail.windriver.com ([147.11.1.11]:53533 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbaCUTgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 15:36:12 -0400
Message-ID: <532C94B0.9090602@windriver.com>
Date: Fri, 21 Mar 2014 15:36:16 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, Fengguang Wu <fengguang.wu@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Subject: Re: [PATCH] lkdtm: include cacheflush.h
References: <20140214235849.GA30703@www.outflux.net>	<CAP=VYLpYhOR3xoX5AjvENR_FRLNsgGE4w275_SZEvBa_UwZrmw@mail.gmail.com> <CAGXu5jKZwxPbhE1a0MfjQBRe0Dzxip0iiR2Rp4JFn38YRQFk_Q@mail.gmail.com>
In-Reply-To: <CAGXu5jKZwxPbhE1a0MfjQBRe0Dzxip0iiR2Rp4JFn38YRQFk_Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.56.57]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-03-21 03:33 PM, Kees Cook wrote:
> On Fri, Mar 21, 2014 at 12:31 PM, Paul Gortmaker
> <paul.gortmaker@windriver.com> wrote:
>> On Fri, Feb 14, 2014 at 6:58 PM, Kees Cook <keescook@chromium.org> wrote:
>>> Some architectures need cacheflush.h explicitly included (mips) for
>>> use of flush_icache_range():
>>>
>>>     config: make ARCH=mips allmodconfig
>>>     All error/warnings:
>>>     >> ERROR: "flush_icache_range" undefined!
>>
>> The linux-next builds still fail with a similar error:
>>
>> http://kisskb.ellerman.id.au/kisskb/buildresult/10808358/
>>
>> I'm not sure if it ever was a compile error, or if it was always
>> a missing export symbol type error as it is apparently now.
> 
> It seems no one picked up this fix? Greg, you normally take my lkdtm work...

No, the "fix" is there, in linux-next, but it doesn't work.  :)

Paul.
--

> 
> -Kees
> 
>>
>> Paul.
>> --
>>
>>>
>>> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
>>> Signed-off-by: Kees Cook <keescook@chromium.org>
>>> ---
>>>  drivers/misc/lkdtm.c |    1 +
>>>  1 file changed, 1 insertion(+)
>>>
>>> diff --git a/drivers/misc/lkdtm.c b/drivers/misc/lkdtm.c
>>> index 47ed2d321351..2ebd52e05773 100644
>>> --- a/drivers/misc/lkdtm.c
>>> +++ b/drivers/misc/lkdtm.c
>>> @@ -46,6 +46,7 @@
>>>  #include <linux/debugfs.h>
>>>  #include <linux/vmalloc.h>
>>>  #include <linux/mman.h>
>>> +#include <asm/cacheflush.h>
>>>
>>>  #ifdef CONFIG_IDE
>>>  #include <linux/ide.h>
>>> --
>>> 1.7.9.5
>>>
>>>
>>> --
>>> Kees Cook
>>> Chrome OS Security
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
> 

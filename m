Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751582AbaCaWMb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 18:12:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49678 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987AbaCaWM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 18:12:29 -0400
Message-ID: <5339E81C.4010901@zytor.com>
Date: Mon, 31 Mar 2014 15:11:40 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Behan Webster <behanw@converseincode.com>, arnd@arndb.de
CC: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org, pageexec@freemail.hu,
        Mark Charlebois <charlebm@gmail.com>
Subject: Re: [PATCH] LLVMLinux: Remove warning about returning an uninitialized
 variable
References: <1395470329-15065-1-git-send-email-behanw@converseincode.com> <5339D57A.4050504@zytor.com> <5339E7CB.2080001@converseincode.com>
In-Reply-To: <5339E7CB.2080001@converseincode.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2014 03:10 PM, Behan Webster wrote:
>>>
>>> diff --git a/include/asm-generic/cmpxchg-local.h
>>> b/include/asm-generic/cmpxchg-local.h
>>> index d8d4c89..4c41bb8 100644
>>> --- a/include/asm-generic/cmpxchg-local.h
>>> +++ b/include/asm-generic/cmpxchg-local.h
>>> @@ -41,6 +41,7 @@ static inline unsigned long
>>> __cmpxchg_local_generic(volatile void *ptr,
>>>           break;
>>>       default:
>>>           wrong_size_cmpxchg(ptr);
>>> +        prev = 0;
>>>       }
>>>       raw_local_irq_restore(flags);
>>>       return prev;
>>>
>> Shouldn't this be a build time assert (__compiletime_error())?
> I changed it to a __noreturn on wrong_size_cmpxchg thanks to James
> Bottomley.
> 
> Which would be better?
> 

__compiletime_error traps at compile time rather than link time, which
is what you want.

	-hpa



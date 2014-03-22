Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751432AbaCVPp6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 11:45:58 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:65417 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbaCVPp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 11:45:56 -0400
Message-ID: <532DB02D.4030602@converseincode.com>
Date: Sat, 22 Mar 2014 08:45:49 -0700
From: Behan Webster <behanw@converseincode.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org, pageexec@freemail.hu,
        Mark Charlebois <charlebm@gmail.com>
Subject: Re: [PATCH] LLVMLinux: Remove warning about returning an uninitialized
 variable
References: <1395470329-15065-1-git-send-email-behanw@converseincode.com> <201403221101.16961.arnd@arndb.de>
In-Reply-To: <201403221101.16961.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/14 03:01, Arnd Bergmann wrote:
> On Saturday 22 March 2014, behanw@converseincode.com wrote:
>> diff --git a/include/asm-generic/cmpxchg-local.h b/include/asm-generic/cmpxchg-local.h
>> index d8d4c89..4c41bb8 100644
>> --- a/include/asm-generic/cmpxchg-local.h
>> +++ b/include/asm-generic/cmpxchg-local.h
>> @@ -41,6 +41,7 @@ static inline unsigned long __cmpxchg_local_generic(volatile void *ptr,
>>                  break;
>>          default:
>>                  wrong_size_cmpxchg(ptr);
>> +               prev = 0;
>>          }
>>          raw_local_irq_restore(flags);
>>          return prev;
>
> How about using __unreachable() instead to annotate the fact that you won't
> get here?
Yours is a _much_ better idea. Will fix.

Thanks,

Behan

-- 
Behan Webster
behanw@converseincode.com


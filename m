Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873AbaCVQbZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 12:31:25 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:64575 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbaCVQbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 12:31:22 -0400
Message-ID: <532DBAD0.6030904@converseincode.com>
Date: Sat, 22 Mar 2014 09:31:12 -0700
From: Behan Webster <behanw@converseincode.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: arnd@arndb.de, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org, pageexec@freemail.hu,
        Mark Charlebois <charlebm@gmail.com>
Subject: Re: [PATCH v2] LLVMLinux: Remove warning about returning an uninitialized
 variable
References: <201403221101.16961.arnd@arndb.de> <1395503299-15203-1-git-send-email-behanw@converseincode.com> <20140322162147.GA9034@ravnborg.org>
In-Reply-To: <20140322162147.GA9034@ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/14 09:21, Sam Ravnborg wrote:
> On Sat, Mar 22, 2014 at 08:48:19AM -0700, behanw@converseincode.com wrote:
>> From: Behan Webster <behanw@converseincode.com>
>>
>> Fix uninitialized return code in default case in cmpxchg-local.h
>>
>> This patch fixes the code to prevent an uninitialized return value that is detected
>> when compiling with clang. The bug produces numerous warnings when compiling the
>> Linux kernel with clang.
>>
>> Signed-off-by: Behan Webster <behanw@converseincode.com>
>> Signed-off-by: Mark Charlebois <charlebm@gmail.com>
>> ---
>>   include/asm-generic/cmpxchg-local.h | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/include/asm-generic/cmpxchg-local.h b/include/asm-generic/cmpxchg-local.h
>> index d8d4c89..9112111 100644
>> --- a/include/asm-generic/cmpxchg-local.h
>> +++ b/include/asm-generic/cmpxchg-local.h
>> @@ -41,6 +41,7 @@ static inline unsigned long __cmpxchg_local_generic(volatile void *ptr,
>>   		break;
>>   	default:
>>   		wrong_size_cmpxchg(ptr);
>> +		__builtin_unreachable();
> It is unreachable() - see compiler.h
Oh I see.

Behan

-- 
Behan Webster
behanw@converseincode.com


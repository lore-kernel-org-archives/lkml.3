Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615AbaCHAwx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 19:52:53 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:58537 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbaCHAww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 19:52:52 -0500
Message-ID: <531A69E0.3000407@converseincode.com>
Date: Fri, 07 Mar 2014 16:52:48 -0800
From: Behan Webster <behanw@converseincode.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: pageexec@freemail.hu, khali@linux-fr.org, rostedt@goodmis.org
CC: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org, dwmw2@infradead.org,
        Mark Charlebois <charlebm@gmail.com>
Subject: Re: [PATCH] module: LLVMLinux: Remove unused function warning from
 __param_check macro
References: <1394219327-5591-1-git-send-email-behanw@converseincode.com> <531A4E84.9996.3260AF06@pageexec.freemail.hu>
In-Reply-To: <531A4E84.9996.3260AF06@pageexec.freemail.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/14 14:56, PaX Team wrote:
> On 7 Mar 2014 at 11:08, behanw@converseincode.com wrote:
>
>> diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
>> index c3eb102..5ce1f67 100644
>> --- a/include/linux/moduleparam.h
>> +++ b/include/linux/moduleparam.h
>> @@ -346,6 +346,7 @@ static inline void destroy_params(const struct kernel_param *params,
>>   /* The macros to do compile-time type checking stolen from Jakub
>>      Jelinek, who IIRC came up with this idea for the 2.4 module init code. */
>>   #define __param_check(name, p, type) \
>> +	static inline type *__check_##name(void) __attribute__ ((unused)); \
>>   	static inline type *__check_##name(void) { return(p); }
> why can't you have the attr on the definition itself:
>
> static inline __unused type *__check_##name(void) { return(p); }
>
>
>
"__unused" isn't defined anywhere I can find, except in:

src/linux/drivers/net/ethernet/amd/declance.c:#define __unused 
__attribute__ ((unused))

But this does work.

-       static inline type *__check_##name(void) { return(p); }
+       static inline __attribute__((unused)) \
+               type *__check_##name(void) { return(p); }

If this is preferred, I will resubmit.

Behan

-- 
Behan Webster
behanw@converseincode.com


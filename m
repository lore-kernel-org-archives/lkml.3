Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475AbaCHCVy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 21:21:54 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:51308 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbaCHCVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 21:21:53 -0500
Message-ID: <531A7EBC.1050205@converseincode.com>
Date: Fri, 07 Mar 2014 18:21:48 -0800
From: Behan Webster <behanw@converseincode.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: khali@linux-fr.org, rostedt@goodmis.org, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org, dwmw2@infradead.org,
        pageexec@freemail.hu, Mark Charlebois <charlebm@gmail.com>
Subject: Re: [PATCH v2] module: LLVMLinux: Remove unused function warning
 from __param_check macro
References: <531A73EB.6060403@codeaurora.org>	 <1394244623-25623-1-git-send-email-behanw@converseincode.com> <1394245074.6972.7.camel@joe-AO722>
In-Reply-To: <1394245074.6972.7.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/14 18:17, Joe Perches wrote:
> On Fri, 2014-03-07 at 18:10 -0800, behanw@converseincode.com wrote:
>> This code makes a compile time type check that is optimized away. Clang
>> complains that it generates an unused function.
> []
>> diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
> []
>> @@ -346,7 +346,7 @@ static inline void destroy_params(const struct kernel_param *params,
>>   /* The macros to do compile-time type checking stolen from Jakub
>>      Jelinek, who IIRC came up with this idea for the 2.4 module init code. */
>>   #define __param_check(name, p, type) \
>> -	static inline type *__check_##name(void) { return(p); }
>> +	static inline __always_unused type *__check_##name(void) { return(p); }
> Perhaps __maybe_unused ?
I thought about that (and even tested with __maybe_unused), but I 
*think* they are always unused, except at compile time (see comment 
above). Though I could be wrong.

I'm certainly okay with __maybe_unused if that is preferable.

Behan

-- 
Behan Webster
behanw@converseincode.com


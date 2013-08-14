Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933324Ab3HNWPX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 18:15:23 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:50473 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933273Ab3HNWPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 18:15:19 -0400
Message-ID: <520C0175.4050003@codeaurora.org>
Date: Wed, 14 Aug 2013 15:15:17 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: behanw@converseincode.com, linux@arm.linux.org.uk, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org, charlebm@gmail.com,
        mingo@redhat.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: LLVMLinux: Change "extern inline" to "gnu_inline"
 in ARM ftrace.h
References: <1376516261-2071-1-git-send-email-behanw@converseincode.com> <1376516261-2071-2-git-send-email-behanw@converseincode.com> <1376517370.1949.115.camel@joe-AO722>
In-Reply-To: <1376517370.1949.115.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/13 14:56, Joe Perches wrote:
> On Wed, 2013-08-14 at 17:37 -0400, behanw@converseincode.com wrote:
>> From: Mark Charlebois <charlebm@gmail.com>
>>
>> With compilers which follow the C99 standard (like modern versions of gcc and
>> clang), "extern inline" does the wrong thing (emits code for an externally
>> linkable version of the inline function). In this case using the gnu_inline
>> attribute makes inline do the right thing on gcc and on clang.
> Why not convert these to static inline?

In this case we should probably just delete the entire thing and make it
unconditional in the header. It looks like it compiles with gcc still.

>
>> diff --git a/arch/arm/include/asm/ftrace.h b/arch/arm/include/asm/ftrace.h
> []
>> @@ -45,7 +45,8 @@ void *return_address(unsigned int);
>>  
>>  #else
>>  
>> -extern inline void *return_address(unsigned int level)
>> +extern inline __attribute__((gnu_inline))
>> +void *return_address(unsigned int level)
>>  {
>>  	return NULL;
>>  }
>
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation


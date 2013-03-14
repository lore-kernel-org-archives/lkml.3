Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758180Ab3CNRsV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 13:48:21 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:11582 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757873Ab3CNRsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 13:48:19 -0400
X-IronPort-AV: E=Sophos;i="4.84,845,1355126400"; 
   d="scan'208";a="29498840"
Message-ID: <51420D62.7030701@codeaurora.org>
Date: Thu, 14 Mar 2013 10:48:18 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: mmotm 2013-03-01-15-50 uploaded (strict user copy)
References: <20130301235135.E9F105A41B2@corp2gmr1-2.hot.corp.google.com> <51316B64.90102@infradead.org> <5131753F.3070302@codeaurora.org>
In-Reply-To: <5131753F.3070302@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/13 19:42, Stephen Boyd wrote:
> On 03/01/13 19:00, Randy Dunlap wrote:
>> on i386:
>>
>> ERROR: "copy_from_user_overflow" [fs/binfmt_misc.ko] undefined!
>>
>> which I don't understand.
>> lib/usercopy.o is built and building binfmt_misc.c says:
>>
>>   CC [M]  fs/binfmt_misc.o
>> In file included from arch/x86/include/asm/uaccess.h:537:0,
>>                  from include/linux/uaccess.h:5,
>>                  from include/linux/highmem.h:8,
>>                  from include/linux/pagemap.h:10,
>>                  from fs/binfmt_misc.c:27:
>> arch/x86/include/asm/uaccess_32.h: In function 'parse_command.part.1':
>> arch/x86/include/asm/uaccess_32.h:211:26: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct [enabled by default]
> Hm.. That's because it's part of lib and not obj, right?
>
> diff --git a/lib/Makefile b/lib/Makefile
> index 59fabd0..4c55104 100644
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -15,7 +15,7 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
>          is_single_threaded.o plist.o decompress.o kobject_uevent.o \
>          earlycpio.o percpu-refcount.o
>  
> -lib-$(CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS) += usercopy.o
> +obj-$(CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS) += usercopy.o
>  lib-$(CONFIG_MMU) += ioremap.o
>  lib-$(CONFIG_SMP) += cpumask.o
>  
>

Andrew, can you squash this into "Kconfig: consolidate
CONFIG_DEBUG_STRICT_USER_COPY_CHECKS"?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation


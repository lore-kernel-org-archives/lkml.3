Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539Ab3HAX7s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 19:59:48 -0400
Received: from intranet.asianux.com ([58.214.24.6]:50317 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab3HAX7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 19:59:47 -0400
X-Spam-Score: -100.8
Message-ID: <51FAF631.5010204@asianux.com>
Date: Fri, 02 Aug 2013 07:58:41 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jonas Bonn <jonas@southpole.se>
CC: linux@openrisc.net,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] openrisc: Makefile: append "-D__linux__" to KBUILD_CFLAGS
References: <51F885C3.3040501@asianux.com> <51FA2E77.1020809@southpole.se>
In-Reply-To: <51FA2E77.1020809@southpole.se>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2013 05:46 PM, Jonas Bonn wrote:
> On 07/31/2013 05:34 AM, Chen Gang wrote:
>> Need append "_D__linux__" to KBUILD_CFLAGS, just like some of another
>> architectures have done, or 'allmodconfig' can not pass compiling.
>>
>> The related error:
>>
>>      CC [M]  fs/coda/psdev.o
>>    In file included from include/linux/coda.h:65:0,
>>                     from fs/coda/psdev.c:45:
>>    include/uapi/linux/coda.h:221:2: error: expected
>> specifier-qualifier-list before 'u_quad_t'
>>
>> The related compiler information:
>>
>>    [root@dhcp122 ~]# /usr/local/bin/or32-linux-gcc -v
>>    Using built-in specs.
>>    COLLECT_GCC=/usr/local/bin/or32-linux-gcc
>>   
>> COLLECT_LTO_WRAPPER=/usr/local/libexec/gcc/or32-linux/4.5.1-or32-1.0rc1/lto-wrapper
>>
>>    Target: or32-linux
>>    Configured with: ../gcc-openrisc/configure --target=or32-linux
>> --disable-nls --enable-languages=c --without-headers --disable-shared
>> --disable-threads --enable-werror=no
>>    Thread model: single
>>    gcc version 4.5.1-or32-1.0rc1 (GCC)
>>
>>
>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> 
> Thanks.  Applied.

Thank you very much for your whole work.

> /Jonas
> 
>> ---
>>   arch/openrisc/Makefile |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/openrisc/Makefile b/arch/openrisc/Makefile
>> index 4739b83..89076a6 100644
>> --- a/arch/openrisc/Makefile
>> +++ b/arch/openrisc/Makefile
>> @@ -24,7 +24,7 @@ OBJCOPYFLAGS    := -O binary -R .note -R .comment -S
>>   LDFLAGS_vmlinux :=
>>   LIBGCC         := $(shell $(CC) $(KBUILD_CFLAGS)
>> -print-libgcc-file-name)
>>
>> -KBUILD_CFLAGS    += -pipe -ffixed-r10
>> +KBUILD_CFLAGS    += -pipe -ffixed-r10 -D__linux__
>>
>>   ifeq ($(CONFIG_OPENRISC_HAVE_INST_MUL),y)
>>       KBUILD_CFLAGS += $(call cc-option,-mhard-mul)
>>
> 
> 
> 


-- 
Chen Gang

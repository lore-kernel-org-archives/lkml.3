Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671AbaCGSkD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 13:40:03 -0500
Received: from mail-qg0-f41.google.com ([209.85.192.41]:38958 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbaCGSkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 13:40:01 -0500
Message-ID: <531A127E.2040005@gmail.com>
Date: Fri, 07 Mar 2014 10:39:58 -0800
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Max Filippov <jcmvbkbc@gmail.com>
CC: David Daney <david.daney@cavium.com>,
        "linux-xtensa@linux-xtensa.org" <linux-xtensa@linux-xtensa.org>,
        Chris Zankel <chris@zankel.net>, Marc Gauthier <marc@cadence.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xtensa: enable sorting extable at build time
References: <1392724128-22920-1-git-send-email-jcmvbkbc@gmail.com> <CAMo8BfJAOTHHmmiEpL7jZa4ySvyPYsHGYUY+myN68BeewjeWYg@mail.gmail.com>
In-Reply-To: <CAMo8BfJAOTHHmmiEpL7jZa4ySvyPYsHGYUY+myN68BeewjeWYg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2014 01:56 AM, Max Filippov wrote:
> On Tue, Feb 18, 2014 at 3:48 PM, Max Filippov <jcmvbkbc@gmail.com> wrote:
>> Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
>> ---
>>   arch/xtensa/Kconfig   | 1 +
>>   scripts/sortextable.c | 5 +++++
>>   2 files changed, 6 insertions(+)
>
> Ping?
> David, is this OK for scripts/sortextable.c?

If you wish, you can add Acked-by: me.

But I am not the maintainer of the file, so you will have to get someone 
else to merge it.

David Daney


>
>> diff --git a/arch/xtensa/Kconfig b/arch/xtensa/Kconfig
>> index 1ccaf91..381370d 100644
>> --- a/arch/xtensa/Kconfig
>> +++ b/arch/xtensa/Kconfig
>> @@ -14,6 +14,7 @@ config XTENSA
>>          select GENERIC_PCI_IOMAP
>>          select ARCH_WANT_IPC_PARSE_VERSION
>>          select ARCH_WANT_OPTIONAL_GPIOLIB
>> +       select BUILDTIME_EXTABLE_SORT
>>          select CLONE_BACKWARDS
>>          select IRQ_DOMAIN
>>          select HAVE_OPROFILE
>> diff --git a/scripts/sortextable.c b/scripts/sortextable.c
>> index cc49062..1052d48 100644
>> --- a/scripts/sortextable.c
>> +++ b/scripts/sortextable.c
>> @@ -35,6 +35,10 @@
>>   #define EM_ARCOMPACT   93
>>   #endif
>>
>> +#ifndef EM_XTENSA
>> +#define EM_XTENSA      94
>> +#endif
>> +
>>   #ifndef EM_AARCH64
>>   #define EM_AARCH64     183
>>   #endif
>> @@ -281,6 +285,7 @@ do_file(char const *const fname)
>>          case EM_AARCH64:
>>          case EM_MICROBLAZE:
>>          case EM_MIPS:
>> +       case EM_XTENSA:
>>                  break;
>>          }  /* end switch */
>>
>> --
>> 1.8.1.4
>


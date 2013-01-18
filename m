Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755786Ab3AROZn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 09:25:43 -0500
Received: from mail1.windriver.com ([147.11.146.13]:61008 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291Ab3AROZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 09:25:41 -0500
Message-ID: <50F95B5F.6080204@windriver.com>
Date: Fri, 18 Jan 2013 08:25:35 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <arnd@arndb.de>, Mischa Jonker <Mischa.Jonker@synopsys.com>
Subject: Re: [PATCH v2 57/76] ARC: kgdb support
References: <1358511930-7424-1-git-send-email-vgupta@synopsys.com> <1358511930-7424-58-git-send-email-vgupta@synopsys.com> <50F94AFF.9010801@windriver.com> <50F94EC5.9070905@synopsys.com>
In-Reply-To: <50F94EC5.9070905@synopsys.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2013 07:31 AM, Vineet Gupta wrote:
> On Friday 18 January 2013 06:45 PM, Jason Wessel wrote:
>> On 01/18/2013 06:25 AM, Vineet Gupta wrote:
>>> From: Mischa Jonker <mjonker@synopsys.com>
>>>
>>> Signed-off-by: Mischa Jonker <mjonker@synopsys.com>
>>> Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
>>> Cc: Jason Wessel <jason.wessel@windriver.com>
>> Acked-by: Jason Wessel <jason.wessel@windriver.com>
>>
>>> ---
>>>  arch/arc/Kconfig            |    3 +-
>>>  arch/arc/include/asm/kgdb.h |   61 +++++++++++++
>>>  arch/arc/kernel/Makefile    |    1 +
>>>  arch/arc/kernel/kgdb.c      |  205 +++++++++++++++++++++++++++++++++++++++++++
>>>  arch/arc/kernel/traps.c     |    6 ++
>>>  5 files changed, 275 insertions(+), 1 deletions(-)
>>>  create mode 100644 arch/arc/include/asm/kgdb.h
>>>  create mode 100644 arch/arc/kernel/kgdb.c
>>>
>>> diff --git a/arch/arc/Kconfig b/arch/arc/Kconfig
>>> index d735de8..b954387 100644
>>> --- a/arch/arc/Kconfig
>>> +++ b/arch/arc/Kconfig
>>> @@ -23,6 +23,7 @@ config ARC
>>>  	select GENERIC_PENDING_IRQ if SMP
>>>  	select GENERIC_SIGALTSTACK
>>>  	select GENERIC_SMP_IDLE_THREAD
>>> +	select HAVE_ARCH_KGDB
>>>  	select HAVE_ARCH_TRACEHOOK
>>>  	select HAVE_GENERIC_HARDIRQS
>>>  	select HAVE_KPROBES
>>> @@ -383,7 +384,7 @@ config ARC_DW2_UNWIND
>>>  
>>>  config ARC_DBG_TLB_PARANOIA
>>>  	bool "Paranoia Checks in Low Level TLB Handlers"
>>> -	depends on ARC_DBG && !SMP
>>> +	depends on ARC_DBG
>>>  	default n
>>>  
>>>  config ARC_DBG_TLB_MISS_COUNT
>>> diff --git a/arch/arc/include/asm/kgdb.h b/arch/arc/include/asm/kgdb.h
>>> new file mode 100644
>>> index 0000000..f3c4934
>>> --- /dev/null
>>> +++ b/arch/arc/include/asm/kgdb.h
>>> @@ -0,0 +1,61 @@
>>> +/*
>>> + * kgdb support for ARC
>>> + *
>>> + * Copyright (C) 2012 Synopsys, Inc. (www.synopsys.com)
>>> + *
>>> + * This program is free software; you can redistribute it and/or modify
>>> + * it under the terms of the GNU General Public License version 2 as
>>> + * published by the Free Software Foundation.
>>> + */
>>> +
>>> +#ifndef __ARC_KGDB_H__
>>> +#define __ARC_KGDB_H__
>>> +
>>> +#ifdef CONFIG_KGDB
>>> +
>>> +#include <asm/user.h>
>>> +
>>> +/* to ensure compatibility with Linux 2.6.35, we don't implement the get/set
>>> + * register API yet */
>> I did think this note was slightly odd.   Is this mainly because you have some kind of out of tree version of this code against an older kernel?
> Thanks for your review and ACK, Jason. We did the initial port against 2.6.35 and
> later moved over to 3.2 - both of which were out-of-tree. We will take a look at
> it again and clean this up.
>
>> The main thing that you lose by not doing this the ability to display and set registers from the kdb shell.
>>
>> From the pure gdb only end of things, gdb operates more efficiently for doing things like setting or reading the program counter, frame pointer or variable mapped registers when using a rs232 connection.  There is no loss or gain in actual functionality by not implementing the individual get/set register method if you only intend to use gdb.
>>
>> Cheers,
>> Jason.
> OK - we will fix this up - but I presume it is not a gating item for the port
> submission.

No gate what so ever.   I was just pointing out what you lose access to by without implementing the optional functions. :-)

Cheers,
Jason.

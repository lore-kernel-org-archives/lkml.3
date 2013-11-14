Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab3KNOUR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 09:20:17 -0500
Received: from mail-yh0-f45.google.com ([209.85.213.45]:43139 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415Ab3KNOUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 09:20:11 -0500
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Nov 2013 09:20:11 EST
Message-ID: <5284DA88.6060809@linaro.org>
Date: Thu, 14 Nov 2013 09:13:28 -0500
From: David Long <dave.long@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, Rabin Vincent <rabin@rab.in>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 07/13] ARM: move generic thumb instruction parsing
 code to new files for use by other features
References: <1381871068-27660-1-git-send-email-dave.long@linaro.org>  <1381871068-27660-8-git-send-email-dave.long@linaro.org> <1384362541.3392.40.camel@linaro1.home>
In-Reply-To: <1384362541.3392.40.camel@linaro1.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/13 12:09, Jon Medhurst (Tixy) wrote:
> On Tue, 2013-10-15 at 17:04 -0400, David Long wrote:
>> From: "David A. Long" <dave.long@linaro.org>
>>
>> Move the thumb version of the kprobes instruction parsing code into more generic
>
> This patch is moving the 'ARM' instructions, not 'thumb' instructions,
> so both description and title needs fixing for that.

Indeed.  I've fixed it for the next version.

> Actually, after looking at patch 08/13, that one seems to erroneously
> include the thumb reorg, I'm guessing that was meant to be in this patch
> instead, or in a standalone patch?

I've now broken the thumb reorg out into its own patch with appropriate 
description.

>> files from where it can be used by uprobes and possibly other subsystems. The
>> symbol names will be made more generic in a subsequent part of this patchset.
>>
>> Signed-off-by: David A. Long <dave.long@linaro.org>
>> ---
>>   arch/arm/include/asm/probes.h    |   2 +
>>   arch/arm/kernel/Makefile         |   4 +-
>>   arch/arm/kernel/kprobes-arm.c    | 723 +-------------------------------------
>>   arch/arm/kernel/kprobes-common.c | 422 +---------------------
>>   arch/arm/kernel/kprobes-test.c   |   1 +
>>   arch/arm/kernel/kprobes-thumb.c  |   1 +
>>   arch/arm/kernel/kprobes.c        |   1 +
>>   arch/arm/kernel/kprobes.h        | 372 --------------------
>>   arch/arm/kernel/probes-arm.c     | 730 +++++++++++++++++++++++++++++++++++++++
>>   arch/arm/kernel/probes-arm.h     |  38 ++
>>   arch/arm/kernel/probes.c         | 441 +++++++++++++++++++++++
>>   arch/arm/kernel/probes.h         | 395 +++++++++++++++++++++
>>   12 files changed, 1622 insertions(+), 1508 deletions(-)
>>   create mode 100644 arch/arm/kernel/probes-arm.c
>>   create mode 100644 arch/arm/kernel/probes-arm.h
>>   create mode 100644 arch/arm/kernel/probes.c
>>   create mode 100644 arch/arm/kernel/probes.h
>
> A git tip: if you use the -C argument with git format-patch (and
> send-email I assume) then it will detect files which are copies of
> others and produce a much smaller patch, as well as a more informative
> file summary. I believe that this is OK for submissions posted to
> mailing lists, I know that I've seen people regularly reminded to use -M
> (which detects file renames).
>
> [...]

I will give this a try with the next round.

>
>> --- a/arch/arm/kernel/kprobes-arm.c
>> +++ b/arch/arm/kernel/kprobes-arm.c
>> @@ -63,10 +63,8 @@
>>   #include <linux/module.h>
>>
>>   #include "kprobes.h"
>> -
>> -#define sign_extend(x, signbit) ((x) | (0 - ((x) & (1 << (signbit)))))
>> -
>> -#define branch_displacement(insn) sign_extend(((insn) & 0xffffff) << 2, 25)
>> +#include "probes.h"
>
> Rather than include "probes.h" after "kprobes.h" here, (and in the other
> 7 places in this patch, and other patches) I think it would make more
> sense to have kprobes.h include probes.h as kprobes code is always going
> to depend on the new generic probe functions.

Suggested change applied for next version.

-dl



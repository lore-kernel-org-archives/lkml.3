Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615AbaAOQnJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 11:43:09 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:47882 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbaAOQnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 11:43:07 -0500
Message-ID: <52D6BA99.6020409@linaro.org>
Date: Wed, 15 Jan 2014 11:43:05 -0500
From: David Long <dave.long@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>
CC: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, Rabin Vincent <rabin@rab.in>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        davem@davemloft.net, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 02/16] ARM: move shared uprobe/kprobe definitions into
 new include file
References: <1387166930-13182-1-git-send-email-dave.long@linaro.org>  <1387166930-13182-3-git-send-email-dave.long@linaro.org> <1387543568.3404.36.camel@linaro1.home>
In-Reply-To: <1387543568.3404.36.camel@linaro1.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/13 07:46, Jon Medhurst (Tixy) wrote:
> On Sun, 2013-12-15 at 23:08 -0500, David Long wrote:
>> From: "David A. Long" <dave.long@linaro.org>
>>
>> Separate the kprobe-only definitions from the definitions needed by
>> both kprobes and uprobes.
>>
>> Signed-off-by: David A. Long <dave.long@linaro.org>
>> ---
>>   arch/arm/include/asm/kprobes.h | 15 +--------------
>>   arch/arm/include/asm/probes.h  | 18 ++++++++++++++++++
>>   2 files changed, 19 insertions(+), 14 deletions(-)
>>   create mode 100644 arch/arm/include/asm/probes.h
>>
>> diff --git a/arch/arm/include/asm/kprobes.h b/arch/arm/include/asm/kprobes.h
>> index f82ec22..30fc11b 100644
>> --- a/arch/arm/include/asm/kprobes.h
>> +++ b/arch/arm/include/asm/kprobes.h
>> @@ -28,21 +28,8 @@
>>   #define kretprobe_blacklist_size	0
>>
>>   typedef u32 kprobe_opcode_t;
>> -
>>   struct kprobe;
>> -typedef void (kprobe_insn_handler_t)(struct kprobe *, struct pt_regs *);
>> -typedef unsigned long (kprobe_check_cc)(unsigned long);
>> -typedef void (kprobe_insn_singlestep_t)(struct kprobe *, struct pt_regs *);
>> -typedef void (kprobe_insn_fn_t)(void);
>> -
>> -/* Architecture specific copy of original instruction. */
>> -struct arch_specific_insn {
>> -	kprobe_opcode_t			*insn;
>> -	kprobe_insn_handler_t		*insn_handler;
>> -	kprobe_check_cc			*insn_check_cc;
>> -	kprobe_insn_singlestep_t	*insn_singlestep;
>> -	kprobe_insn_fn_t		*insn_fn;
>> -};
>> +#include <asm/probes.h>
>>
>>   struct prev_kprobe {
>>   	struct kprobe *kp;
>> diff --git a/arch/arm/include/asm/probes.h b/arch/arm/include/asm/probes.h
>> new file mode 100644
>> index 0000000..21da148
>> --- /dev/null
>> +++ b/arch/arm/include/asm/probes.h
>> @@ -0,0 +1,18 @@
>
> This new file doesn't have any copyright/license notice, I suggest you
> copy the one from kprobes.h and include a note to say this new files
> contents were copied, e.g. start it like...
>
> /*
>   * arch/arm/include/asm/probes.h
>   *
>   * Original contents copied from arch/arm/include/asm/kprobes.h
>   * which contains the following notice...
>   *
>   * Copyright (C) 2006, 2007 Motorola Inc.
>   *
>   * This program is free software; you can redistribute it and/or modify
> [...]
>

Fixed.

>> +#ifndef _ASM_PROBES_H
>> +#define _ASM_PROBES_H
>> +
>> +typedef void (kprobe_insn_handler_t)(struct kprobe *, struct pt_regs *);
>> +typedef unsigned long (kprobe_check_cc)(unsigned long);
>> +typedef void (kprobe_insn_singlestep_t)(struct kprobe *, struct pt_regs *);
>> +typedef void (kprobe_insn_fn_t)(void);
>> +
>> +/* Architecture specific copy of original instruction. */
>> +struct arch_specific_insn {
>> +	kprobe_opcode_t			*insn;
>> +	kprobe_insn_handler_t		*insn_handler;
>> +	kprobe_check_cc			*insn_check_cc;
>> +	kprobe_insn_singlestep_t	*insn_singlestep;
>> +	kprobe_insn_fn_t		*insn_fn;
>> +};
>> +
>> +#endif
>

-dl



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045AbaBDCH3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 21:07:29 -0500
Received: from mail-qc0-f177.google.com ([209.85.216.177]:42148 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbaBDCH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 21:07:27 -0500
Message-ID: <52F04B5C.5060301@linaro.org>
Date: Mon, 03 Feb 2014 21:07:24 -0500
From: David Long <dave.long@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>
CC: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        linux-kernel@vger.kernel.org, Rabin Vincent <rabin@rab.in>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        davem@davemloft.net, Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [PATCH v5 07/16] ARM: Remove use of struct kprobe from generic
 probes code
References: <1390507559-4697-1-git-send-email-dave.long@linaro.org>  <1390507559-4697-8-git-send-email-dave.long@linaro.org> <1391439425.3509.16.camel@linaro1.home>
In-Reply-To: <1391439425.3509.16.camel@linaro1.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/14 09:57, Jon Medhurst (Tixy) wrote:
> On Thu, 2014-01-23 at 15:05 -0500, David Long wrote:
>> From: "David A. Long" <dave.long@linaro.org>
>>
>> Change the generic ARM probes code to pass in the opcode and architecture-specific
>> structure separately instead of using struct kprobe, so we do not pollute
>> code being used only for uprobes or other non-kprobes instruction
>> interpretation.
>>
>> Signed-off-by: David A. Long <dave.long@linaro.org>
>> ---
>
> One minor nit-pick...
>
> [...]
>> diff --git a/arch/arm/kernel/kprobes-thumb.c b/arch/arm/kernel/kprobes-thumb.c
>> index c7ee290..cea707a 100644
>> --- a/arch/arm/kernel/kprobes-thumb.c
>> +++ b/arch/arm/kernel/kprobes-thumb.c
> [...]
>> @@ -593,7 +590,7 @@ t16_emulate_pop_pc(struct kprobe *p, struct pt_regs *regs)
>>   	bx_write_pc(pc, regs);
>>   }
>>
>> -static enum kprobe_insn __kprobes
>> +enum kprobe_insn __kprobes
>>   t16_decode_pop(kprobe_opcode_t insn, struct arch_specific_insn *asi,
>>   		struct decode_header *d)
>>   {
>
> The above removal of 'static' appears to be an unneeded accidental
> change?
>

Yes, that got lost during editing.  The change has been made.

-dl


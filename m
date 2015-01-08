Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775AbbAHRcK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 12:32:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57750 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751592AbbAHRcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 12:32:08 -0500
Message-ID: <54AEBEE0.8030100@redhat.com>
Date: Thu, 08 Jan 2015 23:01:12 +0530
From: Pratyush Anand <panand@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "tixy@linaro.org" <tixy@linaro.org>,
        "ananth@in.ibm.com" <ananth@in.ibm.com>,
        "sandeepa.prabhu@linaro.org" <sandeepa.prabhu@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "anil.s.keshavamurthy@intel.com" <anil.s.keshavamurthy@intel.com>,
        "masami.hiramatsu.pt@hitachi.com" <masami.hiramatsu.pt@hitachi.com>,
        "wcohen@redhat.com" <wcohen@redhat.com>,
        "oleg@redhat.com" <oleg@redhat.com>
Subject: Re: [RFC 1/8] ARM64: Move BRK opcodes defines from kprobes.h to insn.h
References: <cover.1420038188.git.panand@redhat.com> <5beb1ff58d4928a873be5e898b62d8cc2003ec7c.1420038188.git.panand@redhat.com> <20150108165506.GP11583@arm.com>
In-Reply-To: <20150108165506.GP11583@arm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thursday 08 January 2015 10:25 PM, Will Deacon wrote:
> On Wed, Dec 31, 2014 at 03:21:17PM +0000, Pratyush Anand wrote:
>> Its better to keep all BRK opcodes used by kprobes and uprobes at one
>> place. Therefore move these defines to asm/insn.h.
>>
>> Signed-off-by: Pratyush Anand <panand@redhat.com>
>> ---
>>   arch/arm64/include/asm/insn.h | 6 ++++++
>>   arch/arm64/kernel/kprobes.h   | 7 +------
>>   2 files changed, 7 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/insn.h b/arch/arm64/include/asm/insn.h
>> index e2ff32a93b5c..87fa48746806 100644
>> --- a/arch/arm64/include/asm/insn.h
>> +++ b/arch/arm64/include/asm/insn.h
>> @@ -23,6 +23,12 @@
>>   /* A64 instructions are always 32 bits. */
>>   #define	AARCH64_INSN_SIZE		4
>>
>> +/* BRK opcodes with ESR encoding  */
>> +#define BRK64_ESR_MASK		0xFFFF
>> +#define BRK64_ESR_KPROBES	0x0004
>> +#define BRK64_OPCODE_KPROBES	0xD4200080	/* "brk 0x4" */
>
> These might be better off in debug-monitors.h, but I guess that's for the
> kprobes series to sort out.
>

Agreed.

~Pratyush
>> +#define ARCH64_NOP_OPCODE	0xD503201F
>
> We have aarch64_insn_gen_nop for this.
>
> Will
>

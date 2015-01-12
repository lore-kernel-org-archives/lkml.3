Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849AbbALFFt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 00:05:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60448 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751759AbbALFFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 00:05:46 -0500
Message-ID: <54B355FA.60702@redhat.com>
Date: Mon, 12 Jan 2015 10:34:58 +0530
From: Pratyush Anand <panand@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: tixy@linaro.org, linux@arm.linux.org.uk, ananth@in.ibm.com,
        sandeepa.prabhu@linaro.org, catalin.marinas@arm.com,
        will.deacon@arm.com, linux-kernel@vger.kernel.org,
        anil.s.keshavamurthy@intel.com, masami.hiramatsu.pt@hitachi.com,
        wcohen@redhat.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC 8/8] ARM64: Add uprobe support
References: <cover.1420038188.git.panand@redhat.com> <0694af6935f9c6873ef8d25ad51630a40a74a116.1420038188.git.panand@redhat.com> <20150109175936.GB13161@redhat.com>
In-Reply-To: <20150109175936.GB13161@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Friday 09 January 2015 11:29 PM, Oleg Nesterov wrote:
> On 12/31, Pratyush Anand wrote:
>>
>> +int arch_uprobe_analyze_insn(struct arch_uprobe *auprobe, struct mm_struct *mm,
>> +		unsigned long addr)
>> +{
>> +	probe_opcode_t insn;
>> +
>> +	insn = *(probe_opcode_t *)(&auprobe->insn[0]);
>> +
>> +	switch (arm_probe_decode_insn(insn, &auprobe->ainsn)) {
>> +	case INSN_REJECTED:
>> +		return -EINVAL;
>> +
>> +	case INSN_GOOD_NO_SLOT:
>> +		auprobe->simulate = true;
>> +		if (auprobe->ainsn.prepare)
>> +			auprobe->ainsn.prepare(insn, &auprobe->ainsn);
>> +		break;
>> +
>> +	case INSN_GOOD:
>> +	default:
>> +		break;
>> +	}
>> +
>> +	return 0;
>> +}
>
> forgot to mention... shouldn't it also check IS_ALIGNED(addr, AARCH64_INSN_SIZE) ?
>
> I do not know if unaligned insn address is valid on arm64 or not, but please

AARCH64 instructions are always of fixed lenght ie 4 bytes. I do not see 
possibility of addr being unaligned. Please let me know, if I am missing 
something.

> note that at least it should not cross the page boundary, set_swbp() needs to
> write AARCH64_INSN_SIZE == UPROBE_SWBP_INSN bytes and it assumes that this
> should fit the single page.

So, again I do not see the possibility of crossing of page boundary for 
any instruction address.

~Pratyush

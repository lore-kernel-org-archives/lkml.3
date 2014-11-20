Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640AbaKTHUX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 02:20:23 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:43052 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbaKTHUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 02:20:22 -0500
Message-ID: <546D962F.3080309@hitachi.com>
Date: Thu, 20 Nov 2014 16:20:15 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
Cc: David Long <dave.long@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        William Cohen <wcohen@redhat.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 5/5] arm64: Add HAVE_REGS_AND_STACK_ACCESS_API feature
References: <1416292375-29560-1-git-send-email-dave.long@linaro.org> <1416292375-29560-6-git-send-email-dave.long@linaro.org> <20141118145228.GN18842@arm.com>
In-Reply-To: <20141118145228.GN18842@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/11/18 23:52), Will Deacon wrote:
> Hi David,
> 
> On Tue, Nov 18, 2014 at 06:32:55AM +0000, David Long wrote:
>> From: "David A. Long" <dave.long@linaro.org>
>>
>> Add HAVE_REGS_AND_STACK_ACCESS_API feature for arm64.
> 
> [...]
> 
>> diff --git a/arch/arm64/include/asm/ptrace.h b/arch/arm64/include/asm/ptrace.h
>> index d3e782a..24cc048 100644
>> --- a/arch/arm64/include/asm/ptrace.h
>> +++ b/arch/arm64/include/asm/ptrace.h
>> @@ -111,6 +111,8 @@ struct pt_regs {
>>  	u64 syscallno;
>>  };
>>  
>> +#define MAX_REG_OFFSET (offsetof(struct pt_regs, orig_x0))
> 
> Is orig_x0 actually useful to this API? If not, we could instead operate on
> the user_pt_regs structure, and define the maximum offset in terms of sizeof
> that.

It depends on the architecture, but this patch provides the common interface
for kprobe-tracer. I think this code looks OK, since kprobe-tracer doesn't
use user_pt_regs.

> 
>> +#define ARM_cpsr	pstate
>> +#define ARM_pc		pc
>> +#define ARM_sp		sp
>> +#define ARM_lr		regs[30]
>> +#define ARM_fp		regs[29]
>> +#define ARM_x28		regs[28]
>> +#define ARM_x27		regs[27]
> 
> [...]
> 
> I don't think we need these #defines.

Agreed.

Thank you,


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com



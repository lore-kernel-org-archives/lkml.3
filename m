Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762317Ab3DBVEl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 17:04:41 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:23189
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761576Ab3DBVEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 17:04:40 -0400
X-Forefront-Antispam-Report: CIP:160.33.194.228;KIP:(null);UIP:(null);IPV:NLI;H:usculsndmail01v.am.sony.com;RD:mail.sonyusa.com;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(z10d0kzbb2dI98dI9371I936eI1432Izz1f42h1fc6h1ee6h1de0h1202h1e76h1d1ah1d2ahzzz2fh2a8h668h839h93fhd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1b0ah1155h)
Message-ID: <515B48DE.4000808@am.sony.com>
Date: Tue, 2 Apr 2013 14:08:46 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux kernel <linux-kernel@vger.kernel.org>,
        Russell King <rmk@arm.linux.org.uk>
Subject: Re: RFC: right way to conditional-ize some macros for LTO
References: <5155E28A.30509@am.sony.com> <1364907037.3650.54.camel@linaro1.home>
In-Reply-To: <1364907037.3650.54.camel@linaro1.home>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2013 05:50 AM, Jon Medhurst (Tixy) wrote:
> On Fri, 2013-03-29 at 11:50 -0700, Tim Bird wrote:
>> The macros themselves seem empty.  Can someone tell me what they do?
>> What is the status of these macros?  Are they even needed?
> 
> The names of the macros are for Thumb2 instructions which are redundant
> when building for the ARM instruction set. Newer toolchains which
> support the unified assembler syntax will effectively ignore them and I
> guess these empty macros are there so people can write assembler which
> will compile with older toolchains.
> 
>> Could they be
>> made conditional on something like NEED_IT_MACROS, and then have that set only
>> in the arch/arm/kernel/kprobes-test-thumb.c, before the unified.h is included?
> 
> That file needs the real Thumb2 instructions, not empty macros, and
> indeed it doesn't use them, because it is only compiled when
> CONFIG_THUMB2_KERNEL=y and that selects CONFIG_ARM_ASM_UNIFIED and those
> 'it' macro's are guarded by #ifndef CONFIG_ARM_ASM_UNIFIED.
> 
> Note, there are other files which use the 'it' instructions, e.g.
> arch/arm/include/asm/futex.h.
> 
>> I would like get this minor issue resolved in mainline, to make it easier for Andi
>> to get his LTO work upstream and have it work with ARM.
>>
>> Any suggestions are welcome.
> 
> If your toolchain supports the unified assembler syntax, you could try
> enabling CONFIG_ARM_ASM_UNIFIED in ARM builds.

Thanks very much!  It may well be that any toolchain capable of supporting
LTO will support the unified assembler syntax, in which case it would make
sense for LTO to enable this, on ARM.  I'll check it out.
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Workgroup of the Linux Foundation
Senior Staff Engineer, Sony Network Entertainment
=============================


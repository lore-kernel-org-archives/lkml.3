Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751593Ab3K1Wje (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 17:39:34 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:49840 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab3K1Wjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 17:39:33 -0500
Message-ID: <5297C61F.8000801@linaro.org>
Date: Fri, 29 Nov 2013 07:39:27 +0900
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Jiang Liu <liuj97@gmail.com>, Will Deacon <will.deacon@arm.com>
CC: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v5 2/7] arm64: introduce interfaces to hotpatch kernel
 and module code
References: <1382109602-27432-1-git-send-email-liuj97@gmail.com> <1382109602-27432-3-git-send-email-liuj97@gmail.com> <20131030001245.GB25346@mudshark.cambridge.arm.com> <527671E9.8040704@gmail.com>
In-Reply-To: <527671E9.8040704@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2013 12:55 AM, Jiang Liu wrote:
> On 10/30/2013 08:12 AM, Will Deacon wrote:
>> Hi Jinag Liu,
>>
>>> +static __always_inline u32 aarch64_insn_read(void *addr)
>>> +{
>>> +	return le32_to_cpu(*(u32 *)addr);
>>> +}
>>>
>>> +static __always_inline void aarch64_insn_write(void *addr, u32 insn)
>>> +{
>>> +	*(u32 *)addr = cpu_to_le32(insn);
>>> +}
>>
>> I wouldn't bother with these helpers. You should probably be using
>> probe_kernel_address or similar, then doing the endianness swabbing on the
>> return value in-line.
> How about keeping and refining aarch64_insn_read/write interfaces
> by using probe_kernel_address()? I think they may be used in other
> places when supporting big endian ARM64 kernel.

I prefer it (using probe_kernel_read/write) for my ftrace patch.
I would be able to replace some portion of my own function (ftrace_modify_code)
to aarch64_insn_patch_text_nosync().

See my comment here:
http://lists.infradead.org/pipermail/linux-arm-kernel/2013-October/207001.html
([PATCH 2/6])

Current implementation assumes stop_machine (via arch_ftrace_update_code()
in generic ftrace), and, given the discussion btw you and Will, I wonder
that it might be relaxed because ftrace on arm64 modifies only a single branch
or nop instruction at any time.

-Takahiro AKASHI

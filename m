Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933622Ab3EFX2Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 19:28:16 -0400
Received: from mail-da0-f53.google.com ([209.85.210.53]:44412 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933604Ab3EFX2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 19:28:10 -0400
Message-ID: <51883C87.7010501@gmail.com>
Date: Mon, 06 May 2013 16:28:07 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Sanjay Lal <sanjayl@kymasys.com>
CC: linux-mips@linux-mips.org, ralf@linux-mips.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: Re: [PATCH] mips/kvm: Fix ABI for compatibility with 64-bit guests.
References: <1367879980-2440-1-git-send-email-ddaney.cavm@gmail.com> <1069B54B-C9CD-4333-B56F-B0E1D740CADB@kymasys.com>
In-Reply-To: <1069B54B-C9CD-4333-B56F-B0E1D740CADB@kymasys.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2013 04:11 PM, Sanjay Lal wrote:
>
> On May 6, 2013, at 3:39 PM, David Daney wrote:
>
>>
>> /* for KVM_GET_REGS and KVM_SET_REGS */
>> +/*
>> + * If Config[AT] is zero (32-bit CPU), the register contents are
>> + * stored in the lower 32-bits of the struct kvm_regs fields and sign
>> + * extended to 64-bits.
>> + */
>> struct kvm_regs {
>> -	__u32 gprs[32];
>> -	__u32 hi;
>> -	__u32 lo;
>> -	__u32 pc;
>> +	/* out (KVM_GET_REGS) / in (KVM_SET_REGS) */
>> +	__u64 gpr[32];
>> +	__u64 hi, lo;
>> +	__u64 pc;
>> +};
>>
>> -	__u32 cp0reg[N_MIPS_COPROC_REGS][N_MIPS_COPROC_SEL];
>
> Hi David, I'll try out the diff with QEMU and confirm that it works as expected. Could you just leave the GPR field in kvm_regs as "gprs". Its a minor change but avoids diffs that just replace "gprs" with "gpr".
>

Well, there were two changes with respect to 'gprs' vs. 'gpr'.

The change you show above only results in a small handful of diff lines.

My argument for the change is that it will be part of a public ABI, and 
should be short and concise, so I changed it to 'gpr'.

I also changed the field with the same name in struct kvm_vcpu_arch to 
match, which causes the changes in asm-offsets.c and quite a few other 
places as well.  One could argue that this one was gratuitous, but I 
thought it would be nice for them to match.  Since it is an internal 
implementation detail, it is not that important, so I could revert this 
part if there are strong objections.

David Daney


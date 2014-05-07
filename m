Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756997AbaEGP5c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:57:32 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:36573 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756969AbaEGP5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:57:30 -0400
Message-ID: <536A57E4.10704@gmail.com>
Date: Wed, 07 May 2014 18:57:24 +0300
From: Nadav Amit <nadav.amit@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Bandan Das <bsd@redhat.com>, Nadav Amit <namit@cs.technion.ac.il>
CC: mtosatti@redhat.com, pbonzini@redhat.com, hpa@zytor.com, gleb@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] KVM: x86: Fix wrong masking on relative jump/call
References: <1399465972-4026-1-git-send-email-namit@cs.technion.ac.il>	<1399465972-4026-6-git-send-email-namit@cs.technion.ac.il> <jpgppjpejix.fsf@nelium.bos.redhat.com>
In-Reply-To: <jpgppjpejix.fsf@nelium.bos.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/7/14, 5:43 PM, Bandan Das wrote:
> Nadav Amit <namit@cs.technion.ac.il> writes:
>
>> Relative jumps and calls do the masking according to the operand size, and not
>> according to the address size as the KVM emulator does today.  In 64-bit mode,
>> the resulting RIP is always 64-bit. Otherwise it is masked according to the
>> instruction operand-size. Note that when 16-bit address size is used, bits
>> 63:32 are unmodified.
>>
>> Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
>> ---
>>   arch/x86/kvm/emulate.c | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
>> index 6833b41..e406705 100644
>> --- a/arch/x86/kvm/emulate.c
>> +++ b/arch/x86/kvm/emulate.c
>> @@ -506,7 +506,9 @@ static void rsp_increment(struct x86_emulate_ctxt *ctxt, int inc)
>>
>>   static inline void jmp_rel(struct x86_emulate_ctxt *ctxt, int rel)
>>   {
>> -	register_address_increment(ctxt, &ctxt->_eip, rel);
>> +	/* 64-bit mode relative jumps are always 64-bit; otherwise mask */
>> +	int op_bytes = ctxt->mode == X86EMUL_MODE_PROT64 ? 8 : ctxt->op_bytes;
>
> Just a nit, probably break this up for readability ?
>
I will make it more readable on the next version.

Thanks,
Nadav

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952Ab3FNNVp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 09:21:45 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:52173 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838Ab3FNNVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 09:21:43 -0400
Message-ID: <51BB18DF.1080702@cogentembedded.com>
Date: Fri, 14 Jun 2013 17:21:35 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Ralf Baechle <ralf@linux-mips.org>
CC: David Daney <ddaney.cavm@gmail.com>, linux-mips@linux-mips.org,
        kvm@vger.kernel.org, Sanjay Lal <sanjayl@kymasys.com>,
        linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: Re: [PATCH 03/31] mips/kvm: Fix 32-bitisms in kvm_locore.S
References: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com> <1370646215-6543-4-git-send-email-ddaney.cavm@gmail.com> <20130614130933.GE15775@linux-mips.org>
In-Reply-To: <20130614130933.GE15775@linux-mips.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 14-06-2013 17:09, Ralf Baechle wrote:

>> diff --git a/arch/mips/kvm/kvm_locore.S b/arch/mips/kvm/kvm_locore.S
>> index dca2aa6..e86fa2a 100644
>> --- a/arch/mips/kvm/kvm_locore.S
>> +++ b/arch/mips/kvm/kvm_locore.S
>> @@ -310,7 +310,7 @@ NESTED (MIPSX(GuestException), CALLFRAME_SIZ, ra)
>>       LONG_S  t0, VCPU_R26(k1)
>>
>>       /* Get GUEST k1 and save it in VCPU */
>> -    la      t1, ~0x2ff
>> +	PTR_LI	t1, ~0x2ff
>>       mfc0    t0, CP0_EBASE
>>       and     t0, t0, t1
>>       LONG_L  t0, 0x3000(t0)
>> @@ -384,14 +384,14 @@ NESTED (MIPSX(GuestException), CALLFRAME_SIZ, ra)
>>       mtc0        k0, CP0_DDATA_LO
>>
>>       /* Restore RDHWR access */
>> -    la      k0, 0x2000000F
>> +	PTR_LI	k0, 0x2000000F
>>       mtc0    k0,  CP0_HWRENA
>>
>>       /* Jump to handler */
>>   FEXPORT(__kvm_mips_jump_to_handler)
>>       /* XXXKYMA: not sure if this is safe, how large is the stack?? */
>>       /* Now jump to the kvm_mips_handle_exit() to see if we can deal with this in the kernel */
>> -    la          t9,kvm_mips_handle_exit
>> +	PTR_LA	t9, kvm_mips_handle_exit
>>       jalr.hb     t9
>>       addiu       sp,sp, -CALLFRAME_SIZ           /* BD Slot */
>>
>> @@ -566,7 +566,7 @@ __kvm_mips_return_to_host:
>>       mtlo    k0
>>
>>       /* Restore RDHWR access */
>> -    la      k0, 0x2000000F
>> +	PTR_LI	k0, 0x2000000F
>>       mtc0    k0,  CP0_HWRENA

> Technically ok, there's only a formatting issue because you indent the
> changed lines with tabs while the existing file uses tab characters.

    I hope you meant the space characters? :-)

> I suggest you insert an extra cleanup patch to properly re-indent the
> entire file into the series before this one?

> So with that sorted:

> Acked-by: Ralf Baechle <ralf@linux-mips.org>

>    Ralf

WBR, Sergei



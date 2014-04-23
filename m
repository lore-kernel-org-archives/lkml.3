Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932511AbaDWVBv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 17:01:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44420 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752767AbaDWVBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 17:01:49 -0400
Message-ID: <53582A26.6040408@zytor.com>
Date: Wed, 23 Apr 2014 14:01:26 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Nadav Amit <nadav.amit@gmail.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: Gleb Natapov <gleb@kernel.org>, Nadav Amit <namit@cs.technion.ac.il>,
        pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] KVM: x86: RSI/RDI/RCX are zero-extended when affected
 by string ops
References: <1397777591-6147-1-git-send-email-namit@cs.technion.ac.il> <1397794294-8414-1-git-send-email-namit@cs.technion.ac.il> <20140420092646.GB30377@minantech.com> <5356067D.40003@gmail.com> <20140423195832.GA32528@amt.cnet> <20140423201103.GA1167@amt.cnet> <53582853.30009@gmail.com>
In-Reply-To: <53582853.30009@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2014 01:53 PM, Nadav Amit wrote:
>>
>> Err, operand size is forced to 64-bits, not address size.
>>
>> "The following aspects of near branches are controlled by the effective
>> operand size:
>>   • Truncation of the size of the instruction pointer"
>>
>> Still, "67h call" should not truncate EIP (which your patch does).
>>
> Yes, I missed it.
> But if I am not mistaken again, it means that the existing
> implementation of jmp_rel is broken as well when address-size override
> prefix is used. In this case, as I see it, the existing masking would
> cause the carry from the add operation to the lower half of the rip not
> to be added to the rip higher half.
> 
> I guess another patch is needed for that as well.
> 

Yes, on x86 JMP really should be thought of as "MOV ...,IP/EIP/RIP".  On
some other architectures, e.g. m68k, JMP acts as if it was
"LEA ...,PC", which causes some serious confusion for people familiar
with that model.  However, on x86 considering JMP as a MOV to the IP
register really is very consistent and will give you the right mental model.

	-hpa



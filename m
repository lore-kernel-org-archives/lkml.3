Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270AbaEGQMF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 12:12:05 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:38112 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135AbaEGQMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 12:12:03 -0400
Message-ID: <536A5B4E.4090206@gmail.com>
Date: Wed, 07 May 2014 19:11:58 +0300
From: Nadav Amit <nadav.amit@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Bandan Das <bsd@redhat.com>, Nadav Amit <namit@cs.technion.ac.il>
CC: mtosatti@redhat.com, pbonzini@redhat.com, hpa@zytor.com, gleb@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] KVM: x86: Wrong register masking in 64-bit mode
References: <1399465972-4026-1-git-send-email-namit@cs.technion.ac.il>	<1399465972-4026-5-git-send-email-namit@cs.technion.ac.il> <jpglhudej88.fsf@nelium.bos.redhat.com>
In-Reply-To: <jpglhudej88.fsf@nelium.bos.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/7/14, 5:50 PM, Bandan Das wrote:
> Nadav Amit <namit@cs.technion.ac.il> writes:
>
>> 32-bit operations are zero extended in 64-bit mode. Currently, the code does
>> not handle them correctly and keeps the high bits. In 16-bit mode, the high
>> 32-bits are kept intact.
>>
>> In addition, although it is not well-documented, when address override prefix
>
> It would be helpful to have a pointer in the SDM especially for cases
> that are not well-documented.
>
>> is used with REP-string instruction, RCX high half is zeroed even if ECX was
>> zero on the first iteration (as if an assignment was performed to ECX).
>>
>> Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
>>

First, as for the different masking/zero-extending behavior in different 
modes, I guess this behavior is documented in SDM Volume 1, Section 
3.3.7: "Address Calculations in 64-Bit Mode". It appears (from 
experiments on bare-metal) that it also regards ESI/EDI/ECX on 
REP-prefix instructions and I presume it regards ESP on stack operations 
and ECX on loop operations. I will ensure it soon.

Second, the behavior of zero-extending RCX even if ECX is initially zero 
was experienced on native environment (Intel SandyBridge), and we found 
no erratum regarding it. I actually found no documentation that 
describes this behavior. The term "not well-documented" is probably 
misleading, and will be clarified on v2.

Thanks,
Nadav


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062AbaFRPmM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 11:42:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11938 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210AbaFRPmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 11:42:10 -0400
Message-ID: <53A1B33A.3080509@redhat.com>
Date: Wed, 18 Jun 2014 17:41:46 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Nadav Amit <namit@cs.technion.ac.il>
CC: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 9/9] KVM: vmx: vmx instructions handling does not consider
 cs.l
References: <539F059F.8050501@redhat.com> <1403101166-23616-1-git-send-email-namit@cs.technion.ac.il> <1403101166-23616-10-git-send-email-namit@cs.technion.ac.il>
In-Reply-To: <1403101166-23616-10-git-send-email-namit@cs.technion.ac.il>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 18/06/2014 16:19, Nadav Amit ha scritto:
> VMX instructions use 32-bit operands in 32-bit mode, and 64-bit operands in
> 64-bit mode.  The current implementation is broken since it does not use the
> register operands correctly, and always uses 64-bit for reads and writes.
> Moreover, write to memory in vmwrite only considers long-mode, so it ignores
> cs.l. This patch fixes this behavior.  The field of vmread/vmwrite is kept
> intentionally as 64-bit read since if bits [63:32] are not cleared the
> instruction should fail, according to Intel SDM.

This is not how I read the SDM:

"These instructions fail if given, in 64-bit mode, an operand that sets 
an encoding bit beyond bit 32." (Section 24.11.1.2)

"Outside IA-32e mode, the source operand has 32 bits, regardless of the 
value of CS.D. In 64-bit mode, the source operand has 64 bits; however, 
if bits 63:32 of the source operand are not zero, VMREAD will fail due 
to an attempt to access an unsupported VMCS component (see operation 
section)." (Description of VMREAD in Chapter 30).

I'll fix up the patch myself.

Paolo

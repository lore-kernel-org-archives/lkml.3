Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587AbaFRQxF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 12:53:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11045 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719AbaFRQxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 12:53:03 -0400
Message-ID: <53A1B921.1050108@redhat.com>
Date: Wed, 18 Jun 2014 18:06:57 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Nadav Amit <nadav.amit@gmail.com>, Nadav Amit <namit@cs.technion.ac.il>
CC: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 9/9] KVM: vmx: vmx instructions handling does not consider
 cs.l
References: <539F059F.8050501@redhat.com> <1403101166-23616-1-git-send-email-namit@cs.technion.ac.il> <1403101166-23616-10-git-send-email-namit@cs.technion.ac.il> <53A1B33A.3080509@redhat.com> <53A1B7EE.7070800@gmail.com>
In-Reply-To: <53A1B7EE.7070800@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 18/06/2014 18:01, Nadav Amit ha scritto:
>>
>
> Perhaps I am missing something, but I don't see where my mistake is.
> The VMREAD source operand is always read as 64-bits and I made no
> changes there. Therefore, if bits 63:32 are not zero, the instruction
> should fail when attempting to access the field.

In 32-bit mode, it should be read as 32 bits: "Outside IA-32e mode, the 
source operand has 32 bits, regardless of the value of CS.D" (so it's 
never 16 bits, but it's also never 64 bits).

Paolo

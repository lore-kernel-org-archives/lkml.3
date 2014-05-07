Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757020AbaEGP74 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:59:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46941 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756285AbaEGP7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:59:54 -0400
Message-ID: <536A586B.2060200@redhat.com>
Date: Wed, 07 May 2014 17:59:39 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Nadav Amit <namit@cs.technion.ac.il>, mtosatti@redhat.com, hpa@zytor.com
CC: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] KVM: x86: Fix wrong masking on relative jump/call
References: <1399465972-4026-1-git-send-email-namit@cs.technion.ac.il> <1399465972-4026-6-git-send-email-namit@cs.technion.ac.il>
In-Reply-To: <1399465972-4026-6-git-send-email-namit@cs.technion.ac.il>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 07/05/2014 14:32, Nadav Amit ha scritto:
> Relative jumps and calls do the masking according to the operand size, and not
> according to the address size as the KVM emulator does today.  In 64-bit mode,
> the resulting RIP is always 64-bit. Otherwise it is masked according to the
> instruction operand-size. Note that when 16-bit address size is used, bits
> 63:32 are unmodified.

The SDM says "If the operand-size attribute is 16, the upper two bytes 
of the EIP register are cleared, resulting in a maximum instruction 
pointer size of 16 bits".  I'm not sure whether that should also imply 
that 63:32 are _not_ unmodified (because you do a 32-bit write not a 
16-bit one), but in any case it looks like masked_increment is not the 
right function.

Paolo


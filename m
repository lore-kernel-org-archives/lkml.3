Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933927AbaEGPxL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:53:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17720 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934017AbaEGPwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:52:51 -0400
Message-ID: <536A56C3.7050907@redhat.com>
Date: Wed, 07 May 2014 17:52:35 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Nadav Amit <namit@cs.technion.ac.il>, mtosatti@redhat.com, hpa@zytor.com
CC: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] KVM: x86: Wrong register masking in 64-bit mode
References: <1399465972-4026-1-git-send-email-namit@cs.technion.ac.il> <1399465972-4026-5-git-send-email-namit@cs.technion.ac.il>
In-Reply-To: <1399465972-4026-5-git-send-email-namit@cs.technion.ac.il>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 07/05/2014 14:32, Nadav Amit ha scritto:
> 32-bit operations are zero extended in 64-bit mode. Currently, the code does
> not handle them correctly and keeps the high bits. In 16-bit mode, the high
> 32-bits are kept intact.
>
> In addition, although it is not well-documented, when address override prefix
> is used with REP-string instruction, RCX high half is zeroed even if ECX was
> zero on the first iteration (as if an assignment was performed to ECX).

Is this true even for REPZ and ZF=0 or REPNZ and ZF=1?

Paolo

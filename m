Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933707AbaJaPG7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 11:06:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39034 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932570AbaJaPG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 11:06:57 -0400
Message-ID: <5453A589.6040308@redhat.com>
Date: Fri, 31 Oct 2014 16:06:49 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        linux-kernel@vger.kernel.org
CC: kvm@vger.kernel.org, Gleb Natapov <gleb@kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH 0/3] kvm: APICv register write workaround
References: <1414678007-9377-1-git-send-email-rkrcmar@redhat.com>
In-Reply-To: <1414678007-9377-1-git-send-email-rkrcmar@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 30/10/2014 15:06, Radim Krčmář wrote:
> APICv traps register writes, so we can't retrieve previous value, but
> our code depends on detecting changes.

Applied, thanks.

Paolo

> Apart from disabling APIC register virtualization, we can detect the
> change by using extra memory.  One value history is enough, but we still
> don't want to keep it for every APIC register, for performance reasons.
> This leaves us with either a new framework, or exceptions ...
> The latter options fits KVM's path better [1,2].
> 
> And when we already mirror a part of registers, optimizing access is
> acceptable [3].  (Squashed to keep bisecters happy.)
> 
> ---
> Radim Krčmář (3):
>   KVM: x86: detect SPIV changes under APICv
>   KVM: x86: detect LVTT changes under APICv
>   KVM: x86: optimize some accesses to LVTT and SPIV
> 
>  arch/x86/kvm/lapic.c | 32 +++++++++++++++++---------------
>  arch/x86/kvm/lapic.h |  8 +++++---
>  2 files changed, 22 insertions(+), 18 deletions(-)
> 

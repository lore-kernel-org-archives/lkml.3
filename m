Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316AbaFPKTq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 06:19:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31164 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754994AbaFPKTp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 06:19:45 -0400
Message-ID: <539EC486.4040001@redhat.com>
Date: Mon, 16 Jun 2014 12:18:46 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Nadav Amit <namit@cs.technion.ac.il>
CC: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] KVM: x86: More emulator bugs
References: <1402837982-24959-1-git-send-email-namit@cs.technion.ac.il>
In-Reply-To: <1402837982-24959-1-git-send-email-namit@cs.technion.ac.il>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 15/06/2014 15:12, Nadav Amit ha scritto:
> This patch-set resolves several emulator bugs. Each fix is independent of the
> others.  The DR6/7 bug can occur during DR-access exit (regardless to
> unrestricted mode, MMIO and SPT).
>
> Thanks for reviewing the patches,
> Nadav
>
> Nadav Amit (6):
>   KVM: x86: bit-ops emulation ignores offset on 64-bit
>   KVM: x86: Wrong emulation on 'xadd X, X'
>   KVM: x86: Inter privilage level ret emulation is not implemeneted
>   KVM: x86: emulation of dword cmov on long-mode should clear [63:32]
>   KVM: x86: NOP emulation clears (incorrectly) the high 32-bits of RAX
>   KVM: x86: check DR6/7 high-bits are clear only on long-mode
>
>  arch/x86/kvm/emulate.c | 31 ++++++++++++++++++++-----------
>  arch/x86/kvm/x86.c     | 13 +++++++++++--
>  2 files changed, 31 insertions(+), 13 deletions(-)
>

I applied these locally.  Can you prepare testcases for patches 1, 2, 4 
and 5?  Perhaps patch 6 too if it's easy to reproduce.

Paolo

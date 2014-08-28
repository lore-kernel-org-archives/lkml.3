Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751373AbaH1ORP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 10:17:15 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:41517 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbaH1ORN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 10:17:13 -0400
Date: Thu, 28 Aug 2014 17:17:04 +0300
From: Gleb Natapov <gleb@kernel.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Paolo Bonzini <pbonzini@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm list <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>, X86 ML <x86@kernel.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Bandan Das <bsd@redhat.com>, Andrew Honig <ahonig@google.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Alok Kataria <akataria@vmware.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: GET_RNG_SEED hypercall ABI? (Re: [PATCH v5 0/5] random,x86,kvm:
 Rework arch RNG seeds and get some from kvm)
Message-ID: <20140828141704.GI18167@minantech.com>
References: <CALCETrV5U61C-gkikZtddd5RtZWFVRpkjVk69B+ymvy=xauLaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrV5U61C-gkikZtddd5RtZWFVRpkjVk69B+ymvy=xauLaQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 04:58:34PM -0700, Andy Lutomirski wrote:
> hpa pointed out that the ABI that I chose (an MSR from the KVM range
> and a KVM cpuid bit) is unnecessarily KVM-specific.  It would be nice
> to allocate an MSR that everyone involved can agree on and, rather
> than relying on a cpuid bit, just have the guest probe for the MSR.
> 
CPUID part allows feature to be disabled for machine compatibility purpose
during migration. Of course interface can explicitly state that one successful
use of the MSR does not mean that next use will not result in a #GP, but that
doesn't sound very elegant and is different from any other MSR out there.

--
			Gleb.

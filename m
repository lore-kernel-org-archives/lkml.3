Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751353AbaH1QXT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 12:23:19 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:39429 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbaH1QXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 12:23:16 -0400
MIME-Version: 1.0
In-Reply-To: <20140828141704.GI18167@minantech.com>
References: <CALCETrV5U61C-gkikZtddd5RtZWFVRpkjVk69B+ymvy=xauLaQ@mail.gmail.com>
 <20140828141704.GI18167@minantech.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 28 Aug 2014 09:22:54 -0700
Message-ID: <CALCETrXDygWbKwPNux=qEbqVCCk28Lu7q+gJte=6ZwpCNsbd8w@mail.gmail.com>
Subject: Re: GET_RNG_SEED hypercall ABI? (Re: [PATCH v5 0/5] random,x86,kvm:
 Rework arch RNG seeds and get some from kvm)
To: Gleb Natapov <gleb@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>, Daniel Borkmann <dborkman@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, KY Srinivasan <kys@microsoft.com>,
        Alok Kataria <akataria@vmware.com>, Andrew Honig <ahonig@google.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Haiyang Zhang <haiyangz@microsoft.com>, Bandan Das <bsd@redhat.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 28, 2014 7:17 AM, "Gleb Natapov" <gleb@kernel.org> wrote:
>
> On Tue, Aug 26, 2014 at 04:58:34PM -0700, Andy Lutomirski wrote:
> > hpa pointed out that the ABI that I chose (an MSR from the KVM range
> > and a KVM cpuid bit) is unnecessarily KVM-specific.  It would be nice
> > to allocate an MSR that everyone involved can agree on and, rather
> > than relying on a cpuid bit, just have the guest probe for the MSR.
> >
> CPUID part allows feature to be disabled for machine compatibility purpose
> during migration. Of course interface can explicitly state that one successful
> use of the MSR does not mean that next use will not result in a #GP, but that
> doesn't sound very elegant and is different from any other MSR out there.
>

Is there a non-cpuid interface between QEMU and KVM for this?

AFAICT, even turning off cpuid bits for things like async pf doesn't
actually disable the MSRs (which is arguably an attack surface issue).

--Andy

> --
>                         Gleb.

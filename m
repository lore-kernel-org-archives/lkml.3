Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860AbaH1Tqu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 15:46:50 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:49416 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbaH1Tqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 15:46:49 -0400
Message-ID: <53FF8722.6080302@redhat.com>
Date: Thu, 28 Aug 2014 21:46:42 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>, Gleb Natapov <gleb@kernel.org>
CC: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Kees Cook <keescook@chromium.org>,
        kvm list <kvm@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Bandan Das <bsd@redhat.com>, Andrew Honig <ahonig@google.com>,
        Haiyang Zhang <haiyangz@microsoft.com>, X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Alok Kataria <akataria@vmware.com>
Subject: Re: GET_RNG_SEED hypercall ABI? (Re: [PATCH v5 0/5] random,x86,kvm:
 Rework arch RNG seeds and get some from kvm)
References: <CALCETrV5U61C-gkikZtddd5RtZWFVRpkjVk69B+ymvy=xauLaQ@mail.gmail.com>	<20140828141704.GI18167@minantech.com> <CALCETrXDygWbKwPNux=qEbqVCCk28Lu7q+gJte=6ZwpCNsbd8w@mail.gmail.com>
In-Reply-To: <CALCETrXDygWbKwPNux=qEbqVCCk28Lu7q+gJte=6ZwpCNsbd8w@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 28/08/2014 18:22, Andy Lutomirski ha scritto:
> Is there a non-cpuid interface between QEMU and KVM for this?

No.

> AFAICT, even turning off cpuid bits for things like async pf doesn't
> actually disable the MSRs (which is arguably an attack surface issue).

No, it doesn't.  You cannot disable instructions even if you hide CPUID
bits, so KVM just extends this to MSRs (both native and paravirtual). It
sometimes helps too, for example with a particular guest OS that does
not necessary check CPUID for bits that are always present on Apple
hardware...

Paolo

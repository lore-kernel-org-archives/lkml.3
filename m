Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076AbaEBVB0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 17:01:26 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:37648 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976AbaEBVBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 17:01:25 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1405022222570.6261@ionos.tec.linutronix.de>
References: <210a076ea197ae384705d2c02cfff12a951a62f8.1399057218.git.luto@amacapital.net>
	<CA+55aFzfDgeFmzk18xJ+ZvCcm-qCsCtd4RrNxYi0CXdfNbZn_A@mail.gmail.com>
	<CA+55aFygkoYnJKdLas3WOq9q9pCEEk6mBOuj-zbLyLumdhStAA@mail.gmail.com>
	<alpine.DEB.2.02.1405022222570.6261@ionos.tec.linutronix.de>
Date: Fri, 2 May 2014 14:01:24 -0700
X-Google-Sender-Auth: g_YmwMkd4MZXIflSXGbYhspKzcU
Message-ID: <CA+55aFyZr3YrNm1+p4XstNx-NY71LMuP1GyTeqettSdR2CufqQ@mail.gmail.com>
Subject: Re: [RFC/HACK] x86: Fast return to kernel
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        "H. Peter Anvin" <h.peter.anvin@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>, Gleb Natapov <gleb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 2, 2014 at 1:30 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> So what about manipulating the stack so that the popf does not enable
> interrupts and do an explicit sti to get the benefit of the
> one-instruction shadow ?

That's what I already suggested in the original "I don't think popf
works" email.

It does get more complex since you now have to test things (there are
very much cases where we get page faults and other exceptions with
interrupts disabled), but it shouldn't be much worse.

Btw, Andy, why did you do "popq %rsp"? That just looks crazy. If the
stack isn't contiguous, the subsequent "popf" couldn't have worked
anyway. And I bet it screws with the stack engine. So you should just
have done something like "addq $16,%rsp" or whatever the constant ends
up being.

              Linus

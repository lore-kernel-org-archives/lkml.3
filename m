Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221AbaEBV23 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 17:28:29 -0400
Received: from www.linutronix.de ([62.245.132.108]:44512 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187AbaEBV22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 17:28:28 -0400
Date: Fri, 2 May 2014 23:28:39 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andy Lutomirski <luto@amacapital.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        "H. Peter Anvin" <h.peter.anvin@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>, Gleb Natapov <gleb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC/HACK] x86: Fast return to kernel
In-Reply-To: <CA+55aFyZr3YrNm1+p4XstNx-NY71LMuP1GyTeqettSdR2CufqQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1405022327460.6261@ionos.tec.linutronix.de>
References: <210a076ea197ae384705d2c02cfff12a951a62f8.1399057218.git.luto@amacapital.net> <CA+55aFzfDgeFmzk18xJ+ZvCcm-qCsCtd4RrNxYi0CXdfNbZn_A@mail.gmail.com> <CA+55aFygkoYnJKdLas3WOq9q9pCEEk6mBOuj-zbLyLumdhStAA@mail.gmail.com>
 <alpine.DEB.2.02.1405022222570.6261@ionos.tec.linutronix.de> <CA+55aFyZr3YrNm1+p4XstNx-NY71LMuP1GyTeqettSdR2CufqQ@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 May 2014, Linus Torvalds wrote:

> On Fri, May 2, 2014 at 1:30 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> >
> > So what about manipulating the stack so that the popf does not enable
> > interrupts and do an explicit sti to get the benefit of the
> > one-instruction shadow ?
> 
> That's what I already suggested in the original "I don't think popf
> works" email.

Missed that.
 
> It does get more complex since you now have to test things (there are
> very much cases where we get page faults and other exceptions with
> interrupts disabled), but it shouldn't be much worse.

Right. The extra conditional is probably not noticable at all.

Thanks,

	tglx

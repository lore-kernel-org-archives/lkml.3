Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806AbaEBTve (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 15:51:34 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:52937 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719AbaEBTvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 15:51:32 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzfDgeFmzk18xJ+ZvCcm-qCsCtd4RrNxYi0CXdfNbZn_A@mail.gmail.com>
References: <210a076ea197ae384705d2c02cfff12a951a62f8.1399057218.git.luto@amacapital.net>
	<CA+55aFzfDgeFmzk18xJ+ZvCcm-qCsCtd4RrNxYi0CXdfNbZn_A@mail.gmail.com>
Date: Fri, 2 May 2014 12:51:31 -0700
X-Google-Sender-Auth: SyfKYM_RsVXt54voe1_N44V2bKw
Message-ID: <CA+55aFygkoYnJKdLas3WOq9q9pCEEk6mBOuj-zbLyLumdhStAA@mail.gmail.com>
Subject: Re: [RFC/HACK] x86: Fast return to kernel
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        "H. Peter Anvin" <h.peter.anvin@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>, Gleb Natapov <gleb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 2, 2014 at 12:31 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Also, are you *really* sure that "popf" has the same one-instruction
> interrupt shadow that "sti" has? Because I'm not at all sure that is
> true, and it's not documented as far as I can tell. In contrast, the
> one-instruction shadow after "sti" very much _is_ documented.

Yeah, I'm pretty sure about this. The only instructions with an
interrupt shadow are "sti", "mov ss" and "pop ss".

There may be specific microarchitectures that do it for a "popf" that
enables interrupts too, but that is not documented _anywhere_ I could
find.

Btw, on the "really easy to get wrong in emulation" note and looking
at the kernel sources: it looks like KVM gets "pop ss" wrong, and only
does the shadow on "mov ss".

                   Linus

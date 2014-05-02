Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbaEBVm2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 17:42:28 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:35461 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbaEBVm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 17:42:26 -0400
MIME-Version: 1.0
In-Reply-To: <53641035.4040202@intel.com>
References: <210a076ea197ae384705d2c02cfff12a951a62f8.1399057218.git.luto@amacapital.net>
 <CA+55aFzfDgeFmzk18xJ+ZvCcm-qCsCtd4RrNxYi0CXdfNbZn_A@mail.gmail.com>
 <CA+55aFygkoYnJKdLas3WOq9q9pCEEk6mBOuj-zbLyLumdhStAA@mail.gmail.com>
 <alpine.DEB.2.02.1405022222570.6261@ionos.tec.linutronix.de>
 <CA+55aFyZr3YrNm1+p4XstNx-NY71LMuP1GyTeqettSdR2CufqQ@mail.gmail.com>
 <CALCETrW+vAuUq834kjo7Ot8JYqDqAdOts78oasm0vPP1wURnWg@mail.gmail.com>
 <CA+55aFzQiryYPsUTK-yS_rt=MGtzJZBBrj3waGq6Ez3GUqfMnw@mail.gmail.com> <53641035.4040202@intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 2 May 2014 14:42:05 -0700
Message-ID: <CALCETrXP7-mtpVhFmM0Cw0pxHs3JpU8uYNJzxi1Qx6=QXW_Vrg@mail.gmail.com>
Subject: Re: [RFC/HACK] x86: Fast return to kernel
To: "H. Peter Anvin" <h.peter.anvin@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Gleb Natapov <gleb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 2, 2014 at 2:37 PM, H. Peter Anvin <h.peter.anvin@intel.com> wrote:
> On 05/02/2014 02:07 PM, Linus Torvalds wrote:
>> On Fri, May 2, 2014 at 2:04 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>>
>>> Because otherwise I'd have to keep track of whether it's a zeroentry
>>> or an errorentry.  I can't stuff the offset in a register without even
>>> more stack hackery, since there are no available registers there.  I
>>> could split the whole thing into two code paths, I guess.
>>
>> Ahh. Never mind. I didn't think about the fact that the error entry
>> case had one more field on the stack. Your approach is all fine, it
>> was me not seeing the problem.
>>
>
> I have to admit to being rather partial to the idea of simply doing
> "push $0" on entry for the vectors that don't push an error code, like
> the early exception handling code does.
>

Hah -- I think I just faked both of you out :)

I don't think this has anything to do with the error code, and I think
that the errorentry code already does more or less that: it pushes -1.

The real issue here is probably the magic 16-byte stack alignment when
a non-stack-switching interrupt happens.

--Andy

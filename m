Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246AbaGPV4p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:56:45 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:51425 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbaGPV4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:56:42 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrW7UEBTprnJdca0X1Vd-bstyQi1LK9GbfUzdr8FFWze9w@mail.gmail.com>
References: <cover.1405452484.git.luto@amacapital.net>
	<4f153feea35430104d6d1a7c83805fccbffdf089.1405452484.git.luto@amacapital.net>
	<CAGXu5jK0v=dtPNY4Y2m7D01peeNoBSDq8zowgLu_rjZe41=eUg@mail.gmail.com>
	<CALCETrW7UEBTprnJdca0X1Vd-bstyQi1LK9GbfUzdr8FFWze9w@mail.gmail.com>
Date: Wed, 16 Jul 2014 14:56:42 -0700
X-Google-Sender-Auth: U47S4gL7BuqyFBaGyK2EyxVbatg
Message-ID: <CAGXu5j+1C7HnVz7WW3si_rpOw2OBMz1KQB1a9ynrncgUH_1RfQ@mail.gmail.com>
Subject: Re: [PATCH 2/7] seccomp: Refactor the filter callback and the API
From: Kees Cook <keescook@chromium.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Will Drewry <wad@chromium.org>,
        James Morris <james.l.morris@oracle.com>,
        Oleg Nesterov <oleg@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-mips@linux-mips.org, linux-arch <linux-arch@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 1:56 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Wed, Jul 16, 2014 at 1:12 PM, Kees Cook <keescook@chromium.org> wrote:
>> On Tue, Jul 15, 2014 at 12:32 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>> The reason I did this is to add a seccomp API that will be usable
>>> for an x86 fast path.  The x86 entry code needs to use a rather
>>> expensive slow path for a syscall that might be visible to things
>>> like ptrace.  By splitting seccomp into two phases, we can check
>>> whether we need the slow path and then use the fast path in if the
>>> filter allows the syscall or just returns some errno.
>>>
>>> As a side effect, I think the new code is much easier to understand
>>> than the old code.
>>
>> I'd agree. The #idefs got a little weirder, but the actual code flow
>> was much easier to read. I wonder if "phase1" and "phase2" should be
>> renamed "pretrace" and "tracing" or something more meaningful? Or
>> "fast" and "slow"?
>
> Queue the bikeshedding :)
>
> I like "phase1" and "phase2" because it makes it clear that phase1 has
> to come first.  But I'd be amenable to counterarguments.

That works. I didn't have a strong feeling about it. I was just
wondering if there was a good way to self-document that phase1 is on
the fast path, and phase2 was on the slow path for tracing. The
existing comments really should be sufficient, though.

You mentioned architectures providing "sd" directly. I wonder if that
new optional ability should be mentioned in the Kconfig help text that
defines what's needed for an arch to support SECCOMP_FILTER?

-Kees

-- 
Kees Cook
Chrome OS Security

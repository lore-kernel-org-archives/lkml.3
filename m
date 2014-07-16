Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560AbaGPV5Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:57:24 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:61740 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773AbaGPV5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:57:20 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrWuWxZANoKAR=FG55EOHtzvTHmc3euMdtf8yfibtK-QYw@mail.gmail.com>
References: <cover.1405452484.git.luto@amacapital.net>
	<bd4e2efb7cd97f2bf9d4f1e2065f16c9091d799a.1405452484.git.luto@amacapital.net>
	<CAGXu5jJornzMJjyPXVZB_eYi-FRet=bXcJWJDa1vnB_oU9ZA_Q@mail.gmail.com>
	<CALCETrWuWxZANoKAR=FG55EOHtzvTHmc3euMdtf8yfibtK-QYw@mail.gmail.com>
Date: Wed, 16 Jul 2014 14:57:20 -0700
X-Google-Sender-Auth: 9ijIB9RcfMZoIQgeduQ4ao4CJVU
Message-ID: <CAGXu5jLcbWDJiLbpejJTERbV2CkCk2dVZ7jwq7Xw_jYUicBFjQ@mail.gmail.com>
Subject: Re: [PATCH 5/7] x86: Split syscall_trace_enter into two phases
From: Kees Cook <keescook@chromium.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Will Drewry <wad@chromium.org>,
        James Morris <james.l.morris@oracle.com>,
        Oleg Nesterov <oleg@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 2:15 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Wed, Jul 16, 2014 at 1:21 PM, Kees Cook <keescook@chromium.org> wrote:
>> On Tue, Jul 15, 2014 at 12:32 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>>
>>> +
>>> +               ret = seccomp_phase1(&sd);
>>> +               if (ret == SECCOMP_PHASE1_SKIP) {
>>> +                       regs->orig_ax = -ENOSYS;
>>
>> Before, seccomp didn't touch orig_ax on a skip. I don't see any
>> problem with this, and it's probably more clear this way, but are you
>> sure there aren't unexpected side-effects from this?
>
> It's necessary to cause the syscall to be skipped -- see syscall_trace_enter.
>
> That being said, setting it to -ENOSYS is nonsense and probably
> confused you at least as much as it confused me.  It should be
> regs->orig_ax = -1.

Yes, I think that would be better.

-Kees

-- 
Kees Cook
Chrome OS Security

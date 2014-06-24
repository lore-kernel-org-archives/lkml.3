Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186AbaFXTuI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 15:50:08 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:58473 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbaFXTuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 15:50:04 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrU9x05ADgz9JToiw_BuCPz1h0xmOh=1R3eojL9far1aEA@mail.gmail.com>
References: <1403560693-21809-1-git-send-email-keescook@chromium.org>
	<1403560693-21809-5-git-send-email-keescook@chromium.org>
	<20140624191815.GA3623@redhat.com>
	<CALCETrVgpP=zOtiQafVgcic2T95TdEM5DTvHYXWTbcZ14xBqHQ@mail.gmail.com>
	<20140624193055.GA4482@redhat.com>
	<CALCETrU9x05ADgz9JToiw_BuCPz1h0xmOh=1R3eojL9far1aEA@mail.gmail.com>
Date: Tue, 24 Jun 2014 12:50:02 -0700
X-Google-Sender-Auth: Fg6ZM_azFWW4XQ6zDsbyHxkkglo
Message-ID: <CAGXu5jJjuNmf=FRzUPMChvL4D_xkg034pUbRAbaK38f37GYC0A@mail.gmail.com>
Subject: Re: [PATCH v7 4/9] seccomp: move no_new_privs into seccomp
From: Kees Cook <keescook@chromium.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Oleg Nesterov <oleg@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Borkmann <dborkman@redhat.com>, Will Drewry <wad@chromium.org>,
        Julien Tinnes <jln@chromium.org>, David Drysdale <drysdale@google.com>,
        Linux API <linux-api@vger.kernel.org>, X86 ML <x86@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-mips@linux-mips.org, linux-arch <linux-arch@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 12:34 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Tue, Jun 24, 2014 at 12:30 PM, Oleg Nesterov <oleg@redhat.com> wrote:
>> On 06/24, Andy Lutomirski wrote:
>>>
>>> On Tue, Jun 24, 2014 at 12:18 PM, Oleg Nesterov <oleg@redhat.com> wrote:
>>> >>
>>> >> -struct seccomp { };
>>> >> +struct seccomp {
>>> >> +     unsigned long flags;
>>> >> +};
>>> >
>>> > A bit messy ;)
>>> >
>>> > I am wondering if we can simply do
>>> >
>>> >         static inline bool current_no_new_privs(void)
>>> >         {
>>> >                 if (current->no_new_privs)
>>> >                         return true;
>>> >
>>> >         #ifdef CONFIG_SECCOMP
>>> >                 if (test_thread_flag(TIF_SECCOMP))
>>> >                         return true;
>>> >         #endif
>>>
>>> Nope -- privileged users can enable seccomp w/o nnp.
>>
>> Indeed, I am stupid.
>>
>> Still it would be nice to cleanup this somehow. The new member is only
>> used as a previous ->no_new_privs, just it is long to allow the concurent
>> set/get. Logically it doesn't even belong to seccomp{}.
>
> We could add an unsigned long atomic flags field to task_struct.

I thought that had gotten shot down originally, but given the current
state of the patch series, it would be effectively identical, since my
earlier attempt at keeping sizes the same (with alternate accessors)
was too messy. I will change this as well.

> Grr.  Why isn't there an unsigned *int* atomic bitmask type?  Even u64
> would be better.  unsigned long is useless.

Useless beyond 32 bits. ;)

-Kees

-- 
Kees Cook
Chrome OS Security

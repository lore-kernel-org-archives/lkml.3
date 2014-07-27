Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400AbaG0M0f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 08:26:35 -0400
Received: from mail-yh0-f45.google.com ([209.85.213.45]:41211 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172AbaG0M0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 08:26:32 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrWGvBfrX1W5XaFgJZhKHLf+oac9YrwPR3ppK=deQtu5hA@mail.gmail.com>
References: <CALCETrWGvBfrX1W5XaFgJZhKHLf+oac9YrwPR3ppK=deQtu5hA@mail.gmail.com>
From: David Drysdale <drysdale@google.com>
Date: Sun, 27 Jul 2014 13:26:11 +0100
Message-ID: <CAHse=S-UoSgLoV4nwv3rbTHZjdVWAy44AAXLVoZ7N4kynZwGJA@mail.gmail.com>
Subject: Re: General flags to turn things off (getrandom, pid lookup, etc)
To: Andy Lutomirski <luto@amacapital.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Julien Tinnes <jln@google.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Paolo Bonzini <pbonzini@redhat.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Moore <paul@paul-moore.com>,
        James Morris <james.l.morris@oracle.com>,
        Linux API <linux-api@vger.kernel.org>,
        Meredydd Luff <meredydd@senatehouse.org>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        linux-crypto@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 7:30 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> [new thread because this sort of combines two threads]
>
> There is recent interest in having a way to turn generally-available
> kernel features off.  Maybe we should add a good one so we can stop
> bikeshedding and avoid proliferating dumb interfaces.
>
> Things that might want to be turn-off-able include:
>  - getrandom with GRND_RANDOM [from the getrandom threads]
>  - Any lookup of a non-self pid [from the capsicum thread]
>  - Any lookup of a pid outside the caller thread group [capsicum]
>  - Various architectural things (personal wishlist), e.g.:
>     - RDTSC and userspace HPET access
>     - CPUID?
>     - 32-bit GDT code segments [huge attack surface]
>     - 64-bit GDT code segments [probably pointless]
>
> I would propose a new syscall for this:
>
> long restrict_userspace(int mode, int type, int value, int flags);
>
> mode is RESTRICT_SET, RESTRICT_GET, or RESTRICT_LOCK.
>
> type is RESTRICT_GRND_RANDOM, RESTRICT_PID_SCOPE, RESTRICT_X86_TIMING, etc.
>
> Value is zero if RESTRICT_GET.  Otherwise value is the desired value,
> generally 0 or 1.  For RESTRICT_PID_SCOPE, value would be
> RESTRICT_PID_SCOPE_ANY, RESTRICT_PID_SCOPE_THREADGROUP, or
> RESTRICT_PID_SCOPE_SELF.
>
> flags must be zero.  Someday, someone will propose a thread-sync flag.

Today, me: proposed :-)

> restrict_userspace requires either no_new_privs or CAP_SYS_ADMIN in
> the current user namespace.
>
> Thoughts?
>
> --Andy
>
> --
> Andy Lutomirski
> AMA Capital Management, LLC

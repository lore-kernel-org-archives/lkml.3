Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751034AbbAUF4J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 00:56:09 -0500
Received: from mail-we0-f182.google.com ([74.125.82.182]:41030 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbbAUF4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 00:56:06 -0500
X-Greylist: delayed 61522 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Jan 2015 00:56:06 EST
Message-ID: <54BF3F69.702@gmail.com>
Date: Wed, 21 Jan 2015 06:55:53 +0100
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>, Fam Zheng <famz@redhat.com>
CC: mtk.manpages@gmail.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        David Herrmann <dh.herrmann@gmail.com>,
        Alexei Starovoitov <ast@plumgrid.com>,
        Miklos Szeredi <mszeredi@suse.cz>,
        David Drysdale <drysdale@google.com>, Oleg Nesterov <oleg@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vivek Goyal <vgoyal@redhat.com>, Mike Frysinger <vapier@gentoo.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        Hugh Dickins <hughd@google.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH RFC 0/6] epoll: Introduce new syscall "epoll_mod_wait"
References: <1421747878-30744-1-git-send-email-famz@redhat.com> <CALCETrU4TeG1ShVLkQgqQ6usFm8pg_t0D8K=Mi_UJGSfxUwXtA@mail.gmail.com>
In-Reply-To: <CALCETrU4TeG1ShVLkQgqQ6usFm8pg_t0D8K=Mi_UJGSfxUwXtA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2015 11:40 PM, Andy Lutomirski wrote:
> On Tue, Jan 20, 2015 at 1:57 AM, Fam Zheng <famz@redhat.com> wrote:
>> This adds a new system call, epoll_mod_wait. It's described as below:

[...]

>>        There is no guartantee that all the commands are executed in order. Only
>>        if all the commands are successfully executed (all the error fields are
>>        set to 0), events are polled.
> 
> If this doesn't happen, what error is returned?

If I read the code correctly: the error of the first epoll_ctl op that fails.

[...]

>> RETURN VALUE
>>
>>        When any error occurs, epoll_mod_wait() returns -1 and errno is set
>>        appropriately. All the "error" fields in cmds are unchanged before they
>>        are executed, and if any cmds are executed, the "error" fields are set
>>        to a return code accordingly. See also epoll_ctl for more details of the
>>        return code.
> 
> Does this mean that callers should initialize the error fields to an
> impossible value first so they can tell which commands were executed?

Yes. (Ugly!)

[...]

>> ERRORS
>>
>>        These errors apply on either the return value of epoll_mod_wait or error
>>        status for each command, respectively.
> 
> Please clarify which errors are returned overall and which are per-command.

Yes, I think this would be valuable as well.

Thanks,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/

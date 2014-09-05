Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072AbaIEVOo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 17:14:44 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:65085 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbaIEVOm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 17:14:42 -0400
MIME-Version: 1.0
In-Reply-To: <540A2080.8050404@zytor.com>
References: <CALCETrUaZ8w92g96SmFEZDE0Jr+0Moeo+S24-TyW8crrK5reSg@mail.gmail.com>
 <540A1800.3000005@zytor.com> <540A2080.8050404@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 5 Sep 2014 14:14:20 -0700
Message-ID: <CALCETrXFD=D=W6pjQfhzzWU-ZOZzkJ=ZMxF5=sKxFx7NAg7xng@mail.gmail.com>
Subject: Re: Post-merge-window ping (Re: [PATCH v4 0/5] x86: two-phase syscall
 tracing and seccomp fastpath)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>, Will Drewry <wad@chromium.org>,
        Oleg Nesterov <oleg@redhat.com>, X86 ML <x86@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 5, 2014 at 1:43 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 09/05/2014 01:07 PM, H. Peter Anvin wrote:
>> On 08/26/2014 06:32 PM, Andy Lutomirski wrote:
>>> On Mon, Jul 28, 2014 at 8:38 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>>> This applies to:
>>>> git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git seccomp-fastpath
>>>>
>>>> Gitweb:
>>>> https://git.kernel.org/cgit/linux/kernel/git/kees/linux.git/log/?h=seccomp/fastpath
>>>
>>> Hi all-
>>>
>>> AFAIK the only thing that's changed since I submitted it is that the
>>> 3.17 merge window is closed.  Kees rebased the tree this applies to,
>>> but I think the patches all still apply.  What, if anything, do I need
>>> to do to help this along for 3.18?
>>>
>>
>> Just put this stuff in a branch and running through my personal test
>> battery now.
>>
>
> ... and they fail build testing.  Specifically, both i386 and x86-64
> allnoconfig fail with:

OK, that's embarrassing.  Also, this has been sitting on
git.kernel.org forever and kbuild never spotted it either.  Hmm.

Anyway, updates coming.

--Andy

>
> arch/x86/kernel/ptrace.c: In function ‘syscall_trace_enter_phase2’:
>   LD      fs/quota/built-in.o
> ../arch/x86/kernel/ptrace.c:1579:2: error: implicit declaration of
> function ‘seccomp_phase2’ [-Werror=implicit-function-declaration]
>   if (phase1_result > 1 && seccomp_phase2(phase1_result)) {
>   ^
> cc1: some warnings being treated as errors
>   CC      arch/x86/kernel/step.o
> make[4]: *** [arch/x86/kernel/ptrace.o] Error 1
>
>         -hpa
>
>



-- 
Andy Lutomirski
AMA Capital Management, LLC

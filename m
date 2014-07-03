Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759406AbaGCSG6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 14:06:58 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:53888 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726AbaGCSG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 14:06:57 -0400
MIME-Version: 1.0
In-Reply-To: <53B59BC9.5080205@oracle.com>
References: <20140701000913.5ea51f77@gandalf.local.home> <20140702142836.084d1ad63b049d53a2f51218@linux-foundation.org>
 <20140703175222.GA13710@konrad-lan.dumpdata.com> <53B59BC9.5080205@oracle.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 3 Jul 2014 11:06:35 -0700
Message-ID: <CALCETrUMgk9Joj8BHexv3n8bt4F7LCG+n_MAAD6WyOjBFr6SpQ@mail.gmail.com>
Subject: Re: [BUILD BUG][3.16-rc3] Error: too many copied sections (max = 13)
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 3, 2014 at 11:07 AM, Boris Ostrovsky
<boris.ostrovsky@oracle.com> wrote:
> On 07/03/2014 01:52 PM, Konrad Rzeszutek Wilk wrote:
>>
>> On Wed, Jul 02, 2014 at 02:28:36PM -0700, Andrew Morton wrote:
>>>
>>> On Tue, 1 Jul 2014 00:09:13 -0400 Steven Rostedt <rostedt@goodmis.org>
>>> wrote:
>>>
>>>> Testing the latest kernel (3.16-rc3) I hit this build bug:
>>>>
>>>>    VDSO2C  arch/x86/vdso/vdso-image-64.c
>>>> Error: too many copied sections (max = 13)
>>>> /arch/x86/vdso/Makefile:61: recipe for target
>>>> 'arch/x86/vdso/vdso-image-64.c' failed
>>>> make[3]: *** [arch/x86/vdso/vdso-image-64.c] Error 1
>>>> /scripts/Makefile.build:404: recipe for target 'arch/x86/vdso' failed
>>>> make[2]: *** [arch/x86/vdso] Error 2
>>>>
>>>> I bisected it down to this commit:
>>>>
>>>> commit 0e3727a8839c988a3c56170bc8da76d55a16acad
>>>> Author: Andy Lutomirski <luto@amacapital.net>
>>>> Date:   Wed Jun 18 15:59:49 2014 -0700
>>>>
>>>>      x86/vdso: Remove some redundant in-memory section headers
>>>>
>>>> When I revert this commit, it compiles fine.
>>>
>>> When I revert that I get
>>>
>>> Error: cannot handle memsz != filesz
>>> make[2]: *** [arch/x86/vdso/vdso-image-64.c] Error 1
>>> make[1]: *** [arch/x86/vdso] Error 2
>>> make[1]: *** Waiting for unfinished jobs....
>>> In file included from include/linux/poll.h:11,
>>>                   from include/linux/ring_buffer.h:7,
>>>                   from include/linux/ftrace_event.h:5,
>>>                   from include/trace/syscall.h:6,
>>>                   from include/linux/syscalls.h:80,
>>>                   from kernel/capability.c:17:
>>>
>>> Productivity decline...
>>
>> When I revert that mentioned commit I get
>> Error: too many copied sections (max = 16)
>>
>> But if I revert bfad381c0d1e19cae8461e105d8d4387dd2a14fe as well
>> then everything is back to normal.
>
>
>
> This is with binutils-2.20.51.0.2-15 (I assume Konrad is using the same
> environment as I do. But in any case, reverting bfad381c0d makes the build
> work for me at that version).
>

Jan Beulich just sent out patches that should fix this.

--Andy

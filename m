Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752435AbaFJOJj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 10:09:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:49643 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbaFJOJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 10:09:38 -0400
Message-ID: <5397119C.9080402@infradead.org>
Date: Tue, 10 Jun 2014 07:09:32 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: Richard Weinberger <richard.weinberger@gmail.com>,
        linux-kbuild@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH v2 3/5] kbuild: Use relative path for $(objtree)
References: <1399639944-20551-1-git-send-email-mmarek@suse.cz> <1399639944-20551-4-git-send-email-mmarek@suse.cz> <CAFLxGvyz-aX8rTveo9W3mqsQxPeg8cb7Oq59UiC1kMz4qTiYwg@mail.gmail.com> <538EEA3D.1080105@suse.cz> <538F1B41.3060904@suse.cz> <20140605155614.GA18376@sepie.suse.cz> <539625D1.2090905@infradead.org> <539631CC.9040002@suse.cz> <5396340B.6060804@infradead.org> <20140609223922.GA3409@pobox.suse.cz> <5396479F.6030809@infradead.org> <5396C98E.8050501@suse.cz>
In-Reply-To: <5396C98E.8050501@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/14 02:02, Michal Marek wrote:
> On 2014-06-10 01:47, Randy Dunlap wrote:
>> sure.  I did mkdir /tmp/O then
>> make ARCH=um SUBARCH=i386 O=/tmp/O defconfig
>> make ARCH=um SUBARCH=i386 V=1 O=/tmp/O
> 
> So I tried with the exact same paths and it worked for me:
> $ mkdir -p /local/lnx/next/linux-next-20140606
> $ git archive d4bc590f8716f7dde6b7bca319097ac30a8cb0b4 | tar xf - -C
> /local/lnx/next/linux-next-20140606/
> $ cd /local/lnx/next/linux-next-20140606/
> $ make ARCH=um SUBARCH=i386 O=/tmp/O defconfig
> $ make ARCH=um SUBARCH=i386 V=1 O=/tmp/O
> 
> and it worked.
> 
> 
>> make KBUILD_SRC= ARCH=x86 archheaders
>> make -C /local/lnx/next/linux-next-20140606 O=/tmp/O/. archheaders
>> make -C /tmp/O \
>> KBUILD_SRC=/local/lnx/next/linux-next-20140606 \
>> KBUILD_EXTMOD="" -f /local/lnx/next/linux-next-20140606/Makefile \
>> archheaders
>> make -f /local/lnx/next/linux-next-20140606/scripts/Makefile.build obj=arch/x86/syscalls all
> 
> Here, it should do
> 
>   /bin/sh
> '/local/lnx/next/linux-next-20140606/arch/x86/syscalls/syscallhdr.sh'
> '/local/lnx/next/linux-next-20140606/arch/x86/syscalls/syscall_32.tbl'
> 'arch/x86/syscalls/../include/generated/uapi/asm/unistd_32.h' 'i386' '' ''
>   /bin/sh
> '/local/lnx/next/linux-next-20140606/arch/x86/syscalls/syscallhdr.sh'
> '/local/lnx/next/linux-next-20140606/arch/x86/syscalls/syscall_64.tbl'
> 'arch/x86/syscalls/../include/generated/uapi/asm/unistd_64.h'
> 'common,64' '' ''
>   /bin/sh
> '/local/lnx/next/linux-next-20140606/arch/x86/syscalls/syscallhdr.sh'
> '/local/lnx/next/linux-next-20140606/arch/x86/syscalls/syscall_64.tbl'
> 'arch/x86/syscalls/../include/generated/uapi/asm/unistd_x32.h'
> 'common,x32' '' '__X32_SYSCALL_BIT'
>   /bin/sh
> '/local/lnx/next/linux-next-20140606/arch/x86/syscalls/syscalltbl.sh'
> /local/lnx/next/linux-next-20140606/arch/x86/syscalls/syscall_32.tbl
> arch/x86/syscalls/../include/generated/asm/syscalls_32.h
> 
> which is not happening in your case for some reason. Can you please
> check if you have some stale files in include/generated in the *source*
> tree?
> 
>     git ls-file -o --directory

I'm not using git, just tarballs.  I don't have an include/generated
subdirectory at all in my source tree.

However, today's linux-next builds OK for me (both i386 and x86_64),
so let's go with your patch.

> It could be that there is some include/generated directory from a
> previous in-tree build.


-- 
~Randy

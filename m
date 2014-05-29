Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933165AbaE2Rfc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 13:35:32 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:33443 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932513AbaE2Rfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 13:35:30 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <29026.1401383705@warthog.procyon.org.uk>
References: <1400838223-30844-1-git-send-email-miklos@szeredi.hu>
	<28592.1401382081@warthog.procyon.org.uk>
	<CA+icZUXfzPsqZt6=o5evcQ2xO9XGKcMVYBO1zco0aEmGn_x0rA@mail.gmail.com>
	<29026.1401383705@warthog.procyon.org.uk>
Date: Thu, 29 May 2014 19:35:29 +0200
Message-ID: <CA+icZUWeyh3GEUr9+naecGVECUp4mXNQuOuj--r78f2f5UdgdA@mail.gmail.com>
Subject: Re: Unionmount and overlayfs testsuite
From: Sedat Dilek <sedat.dilek@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, apw@canonical.com,
        Felix Fietkau <nbd@openwrt.org>, neilb@suse.de, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, "J. R. Okajima" <hooanon05@yahoo.co.jp>,
        mszeredi@suse.cz
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 7:15 PM, David Howells <dhowells@redhat.com> wrote:
> Sedat Dilek <sedat.dilek@gmail.com> wrote:
>
>> # grep LOCKDEP /boot/config-3.15.0-rc7-58.1-iniza-small
>> CONFIG_LOCKDEP_SUPPORT=y
>
> That's not LOCKDEP, merely support for it.  What I see:
>
>         warthog>grep LOCKDEP build/.config
>         CONFIG_LOCKDEP_SUPPORT=y
>         CONFIG_LOCKDEP=y
>

I cannot set CONFIG_LOCKDEP=y ...

[ lib/Kconfig.debug ]
...
config LOCKDEP
        bool
        depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT &&
STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
        select STACKTRACE
        select FRAME_POINTER if !MIPS && !PPC && !ARM_UNWIND && !S390
&& !MICROBLAZE && !ARC
        select KALLSYMS
        select KALLSYMS_ALL

...where I have all depends and selects...

$ egrep 'DEBUG_KERNEL|TRACE_IRQFLAGS_SUPPORT|STACKTRACE_SUPPORT|LOCKDEP_SUPPORT'
/boot/config-3.15.0-rc7-58.1-iniza-small | sort
CONFIG_DEBUG_KERNEL=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_USER_STACKTRACE_SUPPORT=y

$ egrep 'STACKTRACE|FRAME_POINTER|KALLSYMS|KALLSYMS_ALL'
/boot/config-3.15.0-rc7-58.1-iniza-small | sort
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS=y
CONFIG_SCHED_OMIT_FRAME_POINTER=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_STACKTRACE=y
CONFIG_USER_STACKTRACE_SUPPORT=y

- Sedat -

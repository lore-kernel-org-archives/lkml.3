Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934402AbaE2R6v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 13:58:51 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:32775 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933049AbaE2R6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 13:58:50 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <31514.1401385803@warthog.procyon.org.uk>
References: <1400838223-30844-1-git-send-email-miklos@szeredi.hu>
	<28592.1401382081@warthog.procyon.org.uk>
	<CA+icZUXfzPsqZt6=o5evcQ2xO9XGKcMVYBO1zco0aEmGn_x0rA@mail.gmail.com>
	<29026.1401383705@warthog.procyon.org.uk>
	<CA+icZUWeyh3GEUr9+naecGVECUp4mXNQuOuj--r78f2f5UdgdA@mail.gmail.com>
	<31514.1401385803@warthog.procyon.org.uk>
Date: Thu, 29 May 2014 19:58:48 +0200
Message-ID: <CA+icZUUYhvxYFyvy79_J9QC29RNA8YuWpapgNFepdJNNH5Of7w@mail.gmail.com>
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

On Thu, May 29, 2014 at 7:50 PM, David Howells <dhowells@redhat.com> wrote:
> Sedat Dilek <sedat.dilek@gmail.com> wrote:
>
>> config LOCKDEP
>>         bool
>
> It has no name, so you can't turn it on manually.  You have to enable
> something the depends on or selects it.
>
> Turn on:
>
>         CONFIG_DEBUG_ATOMIC_SLEEP=y
>         CONFIG_DEBUG_LOCK_ALLOC=y
>         CONFIG_DEBUG_MUTEXES=y
>         CONFIG_DEBUG_RT_MUTEXES=y
>         CONFIG_DEBUG_SPINLOCK=y
>

Thanks, that worked.

# for i in CONFIG_DEBUG_ATOMIC_SLEEP CONFIG_DEBUG_LOCK_ALLOC
CONFIG_DEBUG_MUTEXES CONFIG_DEBUG_RT_MUTEXES CONFIG_DEBUG_SPINLOCK ;
do echo "${i}=y" >> .config ; done

# yes "" | make oldconfig && make silentoldconfig </dev/null

# egrep 'LOCKDEP|DEBUG_ATOMIC_SLEEP|DEBUG_LOCK_ALLOC|DEBUG_MUTEXES|DEBUG_RT_MUTEXES|DEBUG_SPINLOCK'
.config | sort
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCK_ALLOC=y
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_LOCKDEP=y

- Sedat -

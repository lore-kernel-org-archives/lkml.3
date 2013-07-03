Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123Ab3GCAyd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 20:54:33 -0400
Received: from mail-vb0-f54.google.com ([209.85.212.54]:54743 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102Ab3GCAyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 20:54:31 -0400
MIME-Version: 1.0
In-Reply-To: <20130701082221.GA14112@gmail.com>
References: <20130701082221.GA14112@gmail.com>
Date: Tue, 2 Jul 2013 17:54:30 -0700
X-Google-Sender-Auth: pmTa-1KYiW6V8VCwcAwYO-F5W4Y
Message-ID: <CA+55aFwfsz6e5oQAdZw-YyYzwJXCPjKJKiLEXxn7ujU7KWX97Q@mail.gmail.com>
Subject: Re: [GIT PULL] core/mutexes changes for v3.11: W/W mutex support
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Dave Airlie <airlied@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 1, 2013 at 1:22 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> Please pull the latest core-mutexes-for-linus git tree from:
>
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-mutexes-for-linus
>
>    HEAD: 166989e366ffa66108b2f37b870e66b85b2185ad locking-selftests: Handle unexpected failures more strictly
>
> This tree adds support for wound/wait style locks, which the graphics guys
> would like to make use of in the TTM graphics subsystem.

So I pulled this, but I'm not particularly happy with how this (very
unusual) lock pollutes <linux/mutex.h> that pretty much every single
file ends up including.

So I'd really prefer to see the ww_mutex() support split up into
<linux/ww_mutex.h>, rather than making the compiler have to parse and
remember that stuff when 99.99% of all files do not care about it or
need it.

Hmm?

                   Linus

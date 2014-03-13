Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603AbaCMWDo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 18:03:44 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:33797 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538AbaCMWDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 18:03:42 -0400
MIME-Version: 1.0
In-Reply-To: <5321CBDA.1060705@oracle.com>
References: <1393114777-21588-1-git-send-email-sasha.levin@oracle.com>
	<CA+55aFxPL9dWAK-y0tDFj5r6ikKytqnxL3A+9KH55GpmCQFf9Q@mail.gmail.com>
	<5321CBDA.1060705@oracle.com>
Date: Thu, 13 Mar 2014 15:03:41 -0700
X-Google-Sender-Auth: ohAH8nT8xx5iIfSS_PJFqNVD7t4
Message-ID: <CA+55aFwDKSKyxC4rTBiFMRVr6xYtL96ZYCQqNSVLJV0-=FLTUg@mail.gmail.com>
Subject: Re: [RFC] improve_stack: make stack dump output useful again
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2014 at 8:16 AM, Sasha Levin <sasha.levin@oracle.com> wrote:
>
> I've looked into doing it in the kernel, but it seems that it would require
> a rather
> large code addition just to deal with getting pretty line numbers.

No no no. The *kernel* will never do line numbers, especially since
only people who don't care about build performance compile with debug
info, and even if you do do that, the kernel won't load it anyway.

You missed the point.

The kernel is going to *remove* all the hex numbers that your script
relies on, because those hex numbers are completely worthless. They
are worthless and annoying now, but they are *doubly* worthless if the
kernel is compiled with base address randomization, since nobody will
know what the hex numbers mean.

> Unless I'm missing something big, is it really worth it?

You're missing something big. The patch I sent earlier *is* going to
happen one of these days, possible for 3.15. So your script that looks
at hex numbers is broken.

You need to look at the *symbol* number. In this output:

     [<ffffffff810020c2>] do_one_initcall+0xc2/0x1e0

that "ffffffff810020c2" is crap, and is going away. The address that
is meaningful and valid is the "do_one_initcall+0xc2" part.

*That* is the part you'd use to parse in user space.

Try it today with the CONFIG_RANDOMIZE_BASE option to see. Using the
hex number doesn't *work*.

          Linus

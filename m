Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863AbaFJRqY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 13:46:24 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:42320 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509AbaFJRqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 13:46:23 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1406101517300.9378@pobox.suse.cz>
References: <alpine.LNX.2.00.1406101517300.9378@pobox.suse.cz>
Date: Tue, 10 Jun 2014 10:46:22 -0700
X-Google-Sender-Auth: anoxhw8yRWJUiDh3-CHust6iPI8
Message-ID: <CA+55aFyY7_=3xt-0KE=-fmb+kLurxkBmh8TZWgDZMi_RVpKBpg@mail.gmail.com>
Subject: Re: [PATCH] tell gcc optimizer to never introduce new data races
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Martin Jambor <mjambor@suse.cz>, Petr Mladek <pmladek@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 6:23 AM, Jiri Kosina <jkosina@suse.cz> wrote:
> We have been chasing a memory corruption bug, which turned out to be
> caused by very old gcc (4.3.4), which happily turned conditional load into
> a non-conditional one, and that broke correctness (the condition was met
> only if lock was held) and corrupted memory.

Just out of interest, can you point to the particular kernel code that
caused this? I think that's more interesting than the example program
you show - which I'm sure is really nice for gcc developers as an
example, but from a kernel standpoint I think it's more important to
show the particular problems this caused for the kernel?

            Linus

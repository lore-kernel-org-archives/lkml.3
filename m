Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526Ab3ICPl3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 11:41:29 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:43924 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754304Ab3ICPl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 11:41:27 -0400
MIME-Version: 1.0
In-Reply-To: <20130903101522.GA22369@gmail.com>
References: <CA+55aFwU054C+zC+G+JrF4ngWvVmvD9WPGWaT_2=nF2j7bpHxA@mail.gmail.com>
	<CA+55aFyc17miqwhncAKsanPQ9fHX_czQx+g-a9At_S1-XNpyKA@mail.gmail.com>
	<20130901212355.GU13318@ZenIV.linux.org.uk>
	<CA+55aFzkZi6Q1bwSZUJxyfqUgLS05icjrObdCxC+4S-3Tup9Ew@mail.gmail.com>
	<CA+55aFzsXwFkYsWY45ZNTaVFC+-1Yh9nxx=NLhv+NxGmQAKHTg@mail.gmail.com>
	<20130901233005.GX13318@ZenIV.linux.org.uk>
	<CA+55aFyzas75yYP+AiwOxsAg5sG3KU+KEmO+ny=dn0-jxqUt5Q@mail.gmail.com>
	<CA+55aFyodR650Y8yXXenH1XHo-__5avng1WSK=AiSJx4mYy25g@mail.gmail.com>
	<20130902070538.GA31639@gmail.com>
	<CA+55aFyCBoeqceQcxA3JZ-k8a4uLbHf3N4rNmTZ4oh9XA7akEA@mail.gmail.com>
	<20130903101522.GA22369@gmail.com>
Date: Tue, 3 Sep 2013 08:41:26 -0700
X-Google-Sender-Auth: VMf3bl3qp-QhUnONEmeUbglAscg
Message-ID: <CA+55aFzhbhYK27n9C7WOgf=0NcmewpE+J6giKQhjAgare52gFg@mail.gmail.com>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Sedat Dilek <sedat.dilek@gmail.com>,
        Waiman Long <waiman.long@hp.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 3, 2013 at 3:15 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> One more thing to try would be a regular '-e cycles' non-PEBS run and see
> whether there's still largish overhead visible around that instruction.

I've done that, and it matches the PEBS runs, except obviously with
the instruction skew (so then depending on run it's 95% the
instruction after the xadd). So the PEBS profiles are entirely
consistent with other data.

              Linus

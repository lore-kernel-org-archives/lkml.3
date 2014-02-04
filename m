Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897AbaBDUS6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 15:18:58 -0500
Received: from mail-vb0-f50.google.com ([209.85.212.50]:35912 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502AbaBDUSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 15:18:54 -0500
MIME-Version: 1.0
In-Reply-To: <20140204120500.041b5175@gandalf.local.home>
References: <20140204120500.041b5175@gandalf.local.home>
Date: Tue, 4 Feb 2014 12:18:53 -0800
X-Google-Sender-Auth: Pr7A-NWhP4sRb6tcaPUdDQ19Z9U
Message-ID: <CA+55aFyObrVGXqncNboMzybeevPBOtAUcn-zur_B26VHJ1CEcg@mail.gmail.com>
Subject: Re: [RFC][PATCH] exec: Fix use after free of tracepoint trace_sched_process_exec
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        David Smith <dsmith@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Igor Zhbanov <i.zhbanov@samsung.com>,
        Christoph Hellwig <hch@infradead.org>, Paul Menage <menage@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 4, 2014 at 9:05 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> This works, but is rather ugly.

Oh, please, that's a British-level understatement. It's like calling
WWII "a small bother".

That's too ugly to live.

> Looking for any other suggestions here.

Do we actually have to use "filename" at all?

We do have bprm->file, and we could get a path from that. It would be
more expensive, but for tracing execve that might be fine. Yes/no?

Or maybe we could just push the "putname(path)" into free_bprm() and
remove it from the callers. That's where we free bprm->interp anyway,
so it would kind of match.

          Linus

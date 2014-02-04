Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755042AbaBDUbe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 15:31:34 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:27421 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754393AbaBDUbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 15:31:32 -0500
Date: Tue, 4 Feb 2014 15:31:28 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        David Smith <dsmith@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Igor Zhbanov <i.zhbanov@samsung.com>,
        Christoph Hellwig <hch@infradead.org>, Paul Menage <menage@google.com>
Subject: Re: [RFC][PATCH] exec: Fix use after free of tracepoint
 trace_sched_process_exec
Message-ID: <20140204153128.4eb52cbc@gandalf.local.home>
In-Reply-To: <CA+55aFyObrVGXqncNboMzybeevPBOtAUcn-zur_B26VHJ1CEcg@mail.gmail.com>
References: <20140204120500.041b5175@gandalf.local.home>
	<CA+55aFyObrVGXqncNboMzybeevPBOtAUcn-zur_B26VHJ1CEcg@mail.gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Feb 2014 12:18:53 -0800
Linus Torvalds <torvalds@linux-foundation.org> wrote:


> We do have bprm->file, and we could get a path from that. It would be
> more expensive, but for tracing execve that might be fine. Yes/no?

I actually looked at that. But it may duplicate a bit of code. I was
thinking perhaps of making helper functions to extract the path string
from the file pointer (if there isn't one already that I'm unaware of)
and using that. Also it might be used for places like proc.

-- Steve

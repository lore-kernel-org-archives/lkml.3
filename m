Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758238AbaD2QTi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 12:19:38 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:55517 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758212AbaD2QTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 12:19:36 -0400
Date: Tue, 29 Apr 2014 12:19:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Salman Qazi <sqazi@google.com>, Ingo Molnar <mingo@elte.hu>,
        Michal Hocko <mhocko@suse.cz>, Borislav Petkov <bp@alien8.de>,
        Vojtech Pavlik <vojtech@suse.cz>, Petr Tesarik <ptesarik@suse.cz>,
        Petr Mladek <pmladek@suse.cz>
Subject: Re: 64bit x86: NMI nesting still buggy?
Message-ID: <20140429121934.00ea4a2f@gandalf.local.home>
In-Reply-To: <20140429120908.61ee947f@gandalf.local.home>
References: <alpine.LNX.2.00.1404291150200.8903@pobox.suse.cz>
	<20140429100345.3f76a5bd@gandalf.local.home>
	<alpine.LNX.2.00.1404291720440.16783@pobox.suse.cz>
	<20140429120908.61ee947f@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2014 12:09:08 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> Can you reproduce your problem on different platforms, or is this just
> one box that exhibits this behavior? If it's only one box, I'm betting
> it has a BIOS doing nasty things.

This box probably crashes on all kernels too. My NMI nesting changes
did not fix a bug (well, it did as a side effect, see below). It was
done to allow NMIs to use IRET so that we could remove stopmachine from
ftrace, and instead have it use breakpoints (which return with IRET).

The bug that was fixed by this was the ability to do stack traces
(sysrq-t) from NMI context. Stack traces can page fault, and when I was
debugging hard lock ups and having the NMI do a stack dump of all
tasks, another NMI would trigger and corrupt the stack of the NMI doing
the dumps. But that was something that would only be seen while
debugging, and not something seen in normal operation.

I don't see a bug to fix in the kernel. I see a bug to fix in the
vendor's BIOS.

-- Steve

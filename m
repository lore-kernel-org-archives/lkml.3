Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307AbaKEUmL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 15:42:11 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:25512 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751077AbaKEUmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 15:42:06 -0500
Date: Wed, 5 Nov 2014 15:42:03 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Petr Mladek <pmladek@suse.cz>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Junio C Hamano <gitster@pobox.com>
Subject: Re: [RFC][PATCH 10/12 v3] seq-buf: Make seq_buf_bprintf()
 conditional on CONFIG_BINARY_PRINTF
Message-ID: <20141105154203.126119d8@gandalf.local.home>
In-Reply-To: <20141105153355.22167d0a@gandalf.local.home>
References: <20141104155237.228431433@goodmis.org>
	<20141104160222.969013383@goodmis.org>
	<20141105170605.GL4570@pathway.suse.cz>
	<20141105153355.22167d0a@gandalf.local.home>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Nov 2014 15:33:55 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Wed, 5 Nov 2014 18:06:05 +0100
> Petr Mladek <pmladek@suse.cz> wrote:
> 
> > On Tue 2014-11-04 10:52:47, Steven Rostedt wrote:
> > > From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> > > 
> > > The function bstr_printf() from lib/vsprnintf.c is only available if
> > > CONFIG_BINARY_PRINTF is defined. This is due to the only user currently
> > > being the tracing infrastructure, which needs to select this config
> > > when tracing is configured. Until there is another user of the binary
> > > printf formats, this will continue to be the case.
> > > 
> > > Since seq_buf.c is now lives in lib/ and is compiled even without
> > > tracing, it must encompass its use of bstr_printf() which is used
> > > by seq_buf_printf(). This too is only used by the tracing infrastructure
> > > and is still encapsulated by the CONFIG_BINARY_PRINTF.
> > > 
> > > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > 
> > Please switch the order and do this change before moving to lib/.
> > IMHO, the current order would break bisecting when tracing is
> > disabled.
> 
> I agree. I was being lazy and when my test broke, I added the update to
> test again. But to move this change to before the move, I need to
> monkey with the patch file.
> 
> I'll move it before the move regardless.
> 

OK, 'git rebase' is SUPER AWESOME!!!

I just did a git rebase, moved this change to before the file move, and
git somehow knew that the change was for the old file, and updated it
without any modification from me. The rebase simply succeeded!

I checked, the change still changed seq_buf.c, but in the
old kernel/trace directory.

-- Steve

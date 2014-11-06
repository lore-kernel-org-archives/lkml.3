Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169AbaKFOjq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 09:39:46 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52767 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751523AbaKFOjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 09:39:44 -0500
Date: Thu, 6 Nov 2014 15:39:38 +0100
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Junio C Hamano <gitster@pobox.com>
Subject: Re: [RFC][PATCH 10/12 v3] seq-buf: Make seq_buf_bprintf()
 conditional on CONFIG_BINARY_PRINTF
Message-ID: <20141106143935.GE2001@dhcp128.suse.cz>
References: <20141104155237.228431433@goodmis.org>
 <20141104160222.969013383@goodmis.org>
 <20141105170605.GL4570@pathway.suse.cz>
 <20141105153355.22167d0a@gandalf.local.home>
 <20141105154203.126119d8@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141105154203.126119d8@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2014-11-05 15:42:03, Steven Rostedt wrote:
> On Wed, 5 Nov 2014 15:33:55 -0500
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > On Wed, 5 Nov 2014 18:06:05 +0100
> > Petr Mladek <pmladek@suse.cz> wrote:
> > 
> > > On Tue 2014-11-04 10:52:47, Steven Rostedt wrote:
> > > > From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> > > > 
> > > > The function bstr_printf() from lib/vsprnintf.c is only available if
> > > > CONFIG_BINARY_PRINTF is defined. This is due to the only user currently
> > > > being the tracing infrastructure, which needs to select this config
> > > > when tracing is configured. Until there is another user of the binary
> > > > printf formats, this will continue to be the case.
> > > > 
> > > > Since seq_buf.c is now lives in lib/ and is compiled even without
> > > > tracing, it must encompass its use of bstr_printf() which is used
> > > > by seq_buf_printf(). This too is only used by the tracing infrastructure
> > > > and is still encapsulated by the CONFIG_BINARY_PRINTF.
> > > > 
> > > > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > > 
> > > Please switch the order and do this change before moving to lib/.
> > > IMHO, the current order would break bisecting when tracing is
> > > disabled.
> > 
> > I agree. I was being lazy and when my test broke, I added the update to
> > test again. But to move this change to before the move, I need to
> > monkey with the patch file.
> > 
> > I'll move it before the move regardless.
> > 
> 
> OK, 'git rebase' is SUPER AWESOME!!!
> 
> I just did a git rebase, moved this change to before the file move, and
> git somehow knew that the change was for the old file, and updated it
> without any modification from me. The rebase simply succeeded!
> 
> I checked, the change still changed seq_buf.c, but in the
> old kernel/trace directory.

That is really awesome! Dreams become reality.

Best Regards,
Petr

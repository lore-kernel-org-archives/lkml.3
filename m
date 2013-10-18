Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab3JRNNc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 09:13:32 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:35190 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab3JRNNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 09:13:30 -0400
Date: Fri, 18 Oct 2013 15:13:26 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: peterz@infradead.org, maarten.lankhorst@canonical.com,
        imirkin@alum.mit.edu, linux-kernel@vger.kernel.org,
        daniel.vetter@ffwll.ch, robdclark@gmail.com
Subject: Re: [PATCH for 3.12] mutex: Avoid gcc version
 dependent__builtin_constant_p() usage.
Message-ID: <20131018131326.GA24572@gmail.com>
References: <201310171945.AGB17114.FSQVtHOJFOOFML@I-love.SAKURA.ne.jp>
 <20131017105243.GM2675@laptop.programming.kicks-ass.net>
 <525FC1DD.4030205@canonical.com>
 <20131017110215.GN2675@laptop.programming.kicks-ass.net>
 <201310182151.AGF16889.SQOFJOtVLFFMHO@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201310182151.AGF16889.SQOFJOtVLFFMHO@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> wrote:

> Peter Zijlstra wrote:
> > On Thu, Oct 17, 2013 at 12:54:21PM +0200, Maarten Lankhorst wrote:
> > > op 17-10-13 12:52, Peter Zijlstra schreef:
> > > > On Thu, Oct 17, 2013 at 07:45:29PM +0900, Tetsuo Handa wrote:
> > > >> Commit 040a0a37 "mutex: Add support for wound/wait style locks" used
> > > >> "!__builtin_constant_p(p == NULL)" but gcc 3.x cannot handle such expression
> > > >> correctly, leading to boot failure when built with CONFIG_DEBUG_MUTEXES=y.
> > > > So I completely forgot all about this, but wouldn't something like:
> > > >
> > > >  !(__builtin_constant_p(p) && p == NULL)
> > > >
> > > > Not also work and generate the same code?
> > > >
> > > See earlier discussion. It was already answered why that was undesirable. ;)
> > 
> > OK; I forgot if we covered that particular option.. I so hate this
> > patch; but I'm afraid we'll have to take it :-/
> > 
> 
> I see. Ingo, would you send this patch via your tree?
> Then, I'll post a patch for 3.11-stable which differs white spaces.

If it has Maarten's and PeterZ's Acked-by then sure.

Thanks,

	Ingo

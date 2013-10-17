Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990Ab3JQLC2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 07:02:28 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49121 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944Ab3JQLC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 07:02:26 -0400
Date: Thu, 17 Oct 2013 13:02:15 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, mingo@kernel.org,
        imirkin@alum.mit.edu, linux-kernel@vger.kernel.org,
        daniel.vetter@ffwll.ch, robdclark@gmail.com
Subject: Re: [PATCH for 3.12] mutex: Avoid gcc version dependent
 __builtin_constant_p() usage.
Message-ID: <20131017110215.GN2675@laptop.programming.kicks-ass.net>
References: <201310171945.AGB17114.FSQVtHOJFOOFML@I-love.SAKURA.ne.jp>
 <20131017105243.GM2675@laptop.programming.kicks-ass.net>
 <525FC1DD.4030205@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <525FC1DD.4030205@canonical.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 12:54:21PM +0200, Maarten Lankhorst wrote:
> op 17-10-13 12:52, Peter Zijlstra schreef:
> > On Thu, Oct 17, 2013 at 07:45:29PM +0900, Tetsuo Handa wrote:
> >> Commit 040a0a37 "mutex: Add support for wound/wait style locks" used
> >> "!__builtin_constant_p(p == NULL)" but gcc 3.x cannot handle such expression
> >> correctly, leading to boot failure when built with CONFIG_DEBUG_MUTEXES=y.
> > So I completely forgot all about this, but wouldn't something like:
> >
> >  !(__builtin_constant_p(p) && p == NULL)
> >
> > Not also work and generate the same code?
> >
> See earlier discussion. It was already answered why that was undesirable. ;)

OK; I forgot if we covered that particular option.. I so hate this
patch; but I'm afraid we'll have to take it :-/

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115Ab3JQKwx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 06:52:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48948 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557Ab3JQKww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 06:52:52 -0400
Date: Thu, 17 Oct 2013 12:52:43 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: mingo@kernel.org, maarten.lankhorst@canonical.com, imirkin@alum.mit.edu,
        linux-kernel@vger.kernel.org, daniel.vetter@ffwll.ch,
        robdclark@gmail.com
Subject: Re: [PATCH for 3.12] mutex: Avoid gcc version dependent
 __builtin_constant_p() usage.
Message-ID: <20131017105243.GM2675@laptop.programming.kicks-ass.net>
References: <201310171945.AGB17114.FSQVtHOJFOOFML@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201310171945.AGB17114.FSQVtHOJFOOFML@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 07:45:29PM +0900, Tetsuo Handa wrote:
> Commit 040a0a37 "mutex: Add support for wound/wait style locks" used
> "!__builtin_constant_p(p == NULL)" but gcc 3.x cannot handle such expression
> correctly, leading to boot failure when built with CONFIG_DEBUG_MUTEXES=y.

So I completely forgot all about this, but wouldn't something like:

 !(__builtin_constant_p(p) && p == NULL)

Not also work and generate the same code?

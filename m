Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799Ab3KRVJn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 16:09:43 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:63951 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751626Ab3KRVJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 16:09:40 -0500
Date: Mon, 18 Nov 2013 16:09:38 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext4: Use trace condition for ext4_mballoc tracepoints
Message-ID: <20131118160938.39f37e80@gandalf.local.home>
In-Reply-To: <20131114230811.257ad6cc@gandalf.local.home>
References: <20131114230811.257ad6cc@gandalf.local.home>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ug,

Please ignore this for now. It wasn't suppose to go out yet, because we
didn't finish testing. I only wrote this up and put it in my claws-mail
"send-later" folder.

Well, what did I learn about claws mail today?

I learned that there's a "send" button next to the "compose" button
that when you hit it, it sends out all your "send later" messages :-p

Which I now have to look through and think about all the crap I wrote
about people just to feel good, and hit "send later" on, never
expecting it to ever go out.

Oh well, now everyone knows how much of an asshole I think they are ;-)

-- Steve


On Thu, 14 Nov 2013 23:08:11 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> Doing an if statement to test some condition to know if we should
> trigger a tracepoint is pointless when tracing is disabled. This just
> adds overhead and wastes a branch prediction. This is why the
> TRACE_EVENT_CONDITION() was created. It places the check inside the jump
> label so that the branch does not happen unless tracing is enabled.
> 
> That is, instead of doing:
> 
> 	if (em)
> 		trace_btrfs_get_extent(root, em);
> 
> Which is basically this:
> 
> 	if (em)
> 		if (static_key(trace_btrfs_get_extent)) {
> 
> 
> Using a TRACE_EVENT_CONDITION() we can just do:
> 
> 	trace_btrfs_get_extent(root, em);
> 
> And the condition trace event will do:
> 
> 	if (static_key(trace_btrfs_get_extent)) {
> 		if (em) {
> 			...
> 
> The static key is a non conditional jump (or nop) that is faster than
> having to check if em is NULL or not.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>


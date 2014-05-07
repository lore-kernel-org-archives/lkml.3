Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019AbaEGUG6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 16:06:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56985 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbaEGUG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 16:06:57 -0400
Date: Wed, 7 May 2014 13:06:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Borislav Petkov <bp@alien8.de>
Cc: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mike Galbraith <mgalbraith@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH] CPU hotplug: Slow down hotplug operations
Message-Id: <20140507130655.9f7c46de8cb39726079458fb@linux-foundation.org>
In-Reply-To: <1399492661-891-1-git-send-email-bp@alien8.de>
References: <1399492661-891-1-git-send-email-bp@alien8.de>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  7 May 2014 21:57:41 +0200 Borislav Petkov <bp@alien8.de> wrote:

> We have all those eager tester dudes which scratch up a dirty script to
> pound on CPU hotplug senselessly and then report bugs they've managed to
> trigger.
> 
> Well, first of all, most, if not all, bugs they trigger are CPU hotplug
> related anyway. But we know hotplug is full of duct tape and brown
> paper bags. So we end up clearly wasting too much time dealing with a
> mechanism we know it is b0rked in the first place.
> 
> Oh, and I would understand if that pounding were close to some real
> usage patterns but I've yet to receive a justification for toggling
> cores on- and offline senselessly.
> 
> In any case, before this gets rewritten properly (I'm being told we
> might get lucky after all) let's slow down hotplugging on purpose and
> thus make it uninteresting, as a temporary brown paper bag solution
> until the real thing gets done.
> 
> This way we'll save us a lot of time and efforts in chasing the wrong
> bugs.

Well, I only yesterday merged Srivatsa's `CPU hotplug, stop-machine:
plug race-window that leads to "IPI-to-offline-CPU"' bugfix.  That bug
presumably wouldn't have been fixed if this patch was in place.

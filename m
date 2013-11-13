Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757817Ab3KMDVI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 22:21:08 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:58393 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755778Ab3KMDVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 22:21:00 -0500
Date: Wed, 13 Nov 2013 12:20:53 +0900
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        David Rientjes <rientjes@google.com>,
        David Laight <David.Laight@ACULAB.COM>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Ingo Molnar <mingo@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: oom-kill && frozen()
Message-ID: <20131113032053.GA19394@mtj.dyndns.org>
References: <1384264396-14550-1-git-send-email-geert@linux-m68k.org>
 <20131112141314.GQ5056@laptop.programming.kicks-ass.net>
 <AE90C24D6B3A694183C094C60CF0A2F6026B7405@saturn3.aculab.com>
 <20131112145243.GU5056@laptop.programming.kicks-ass.net>
 <20131112162136.GA29065@redhat.com>
 <20131112165643.GA31278@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131112165643.GA31278@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Nov 12, 2013 at 05:56:43PM +0100, Oleg Nesterov wrote:
> On 11/12, Oleg Nesterov wrote:
> > I am also wondering if it makes any sense to turn PF_FROZEN into
> > TASK_FROZEN, something like (incomplete, probably racy) patch below.
> > Note that it actually adds the new state, not the the qualifier.
> 
> As for the current usage of PF_FROZEN... David, it seems that
> oom_scan_process_thread()->__thaw_task() is dead? Probably this
> was fine before, when __thaw_task() cleared the "need to freeze"
> condition, iirc it was PF_FROZEN.
> 
> But today __thaw_task() can't help, no? the task will simply
> schedule() in D state again.

Yeah, it'll have to be actively excluded using e.g. PF_FREEZER_SKIP,
which, BTW, can usually only be manipulated by the task itself.  I've
been saying this multiple times but this is yet another cost of having
"frozen" as a separate completely alien task state, which is
essentially close to being undefined when viewed from userland.  We're
spreading broken behaviors and complexity throughout the kernel by
making this half broken state visible.  :(

Thanks.

-- 
tejun

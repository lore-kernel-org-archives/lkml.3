Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161744AbaKNRaR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 12:30:17 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:21113 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1161282AbaKNRaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 12:30:13 -0500
Date: Fri, 14 Nov 2014 12:30:01 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Petr Mladek <pmladek@suse.cz>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [RFC][PATCH 17/23 v4] tracing: Have seq_buf use full buffer
Message-ID: <20141114123001.4d19721d@gandalf.local.home>
In-Reply-To: <20141114170716.GC14538@dhcp128.suse.cz>
References: <20141114011244.256115061@goodmis.org>
	<20141114011412.811957882@goodmis.org>
	<20141114170716.GC14538@dhcp128.suse.cz>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov 2014 18:07:16 +0100
Petr Mladek <pmladek@suse.cz> wrote:

> On Thu 2014-11-13 20:13:01, Steven Rostedt wrote:
> > From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> > 
> > Currently seq_buf is full when all but one byte of the buffer is
> > filled. Change it so that the seq_buf is full when all of the
> > buffer is filled.
> > 
> > Some of the functions would fill the buffer completely and report
> > everything was fine. This was inconsistent with the max of size - 1.
> > Changing this to be max of size makes all functions consistent.
> > 
> > Link: http://lkml.kernel.org/r/20141104160222.502133196@goodmis.org
> > 
> > Tested-by: Jiri Kosina <jkosina@suse.cz>
> > Acked-by: Jiri Kosina <jkosina@suse.cz>
> > Reviewed-by: Petr Mladek <pmladek@suse.cz>
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> Hmm, we should not apply this patch before we fix all other locations
> accessing seq.len. We need to make sure that they do not access
> outside of the buffer when seq.len = seq.size  + 1.
> 
> See my comments for "[RFC][PATCH 13/23 v4] tracing: Create seq_buf
> layer in trace_seq"

I agree. As I replied there, I'll add a patch before this gets applied
(right after seq_buf_left() is introduced), that will fix those issues.

> 
> BTW: Are these patches applied in some public branch, please? The
> patch series is getting long. I would like to see it applied but I do
> not want to copy all the patches and apply manually :-)

I'll start pushing them up to my repo under rfc/seq-buf

git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git

That branch will always be rebasing. I have it applied on top of my
ftrace/core branch that will become my next for-next soon (after it
passes all my tests).


> 
> Best Regards,
> Petr
> 
> PS: I will need to go in a while. I am not sure that I will be able to
> review the whole patchset before the weekend. I do the review in the
> order of patches. I sent reply only when I had something to add. The
> non-commented other patches (< 17) looks fine to me.

Thanks, I'll add your Reviewed-by tags on them.

To ease the pain of review, I'll reply to your email comments with the
patches as I fix them up (as I've already done). I'll keep the commit
ids as well so that you can verify them. I'll try to remember to
constantly update my rfc/seq-buf branch.

Thanks a lot for your reviews. I really do appreciate it.

-- Steve

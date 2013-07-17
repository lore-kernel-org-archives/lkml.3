Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850Ab3GQO5X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 10:57:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48331 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755301Ab3GQO5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 10:57:22 -0400
Date: Wed, 17 Jul 2013 16:51:48 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Andrew Morton <akpm@linux-foundation.org>, jovi.zhangwei@huawei.com,
        Jiri Olsa <jolsa@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH V2] tracing: Check f_dentry before accessing
	event_file/call in inode->i_private
Message-ID: <20130717145148.GB7358@redhat.com>
References: <20130705003223.GA4981@redhat.com> <20130709075519.2583.96462.stgit@mhiramat-M0-7522> <20130715181659.GA18505@redhat.com> <51E5FD33.4040604@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E5FD33.4040604@hitachi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17, Masami Hiramatsu wrote:
>
> (2013/07/16 3:16), Oleg Nesterov wrote:
> > On 07/09, Masami Hiramatsu wrote:
> >>
> >> To avoid this, when opening events/*/*/enable, we have to ensure
> >> the dentry of the file is not unlinked yet, under event_mutex
> >> is locked.
> >
> > Probably this can work, but I am starting to think that this ref
> > count becomes toooooo complex....
>
> Oleg, I agree that is a bit complex way to fix but it can fix.
>
> However, I think we should fix bugs first, because there are bugs.
> I don't like to leave a bug in the kernel as it is, while we re-
> start discussing new approach...

And I am trying to fix the same problems, just _I think_ there is
another and simpler approach.

> So, I'd like to suggest you getting these fixes into ftrace as
> first-aid treatment, and discuss your new series.

Well, perhaps you are right... But this TRACE_EVENT_FL_REF_MASK code
is new too, it is not that we only need a small fixlets to finish it.

So I think that it makes sense to discuss the alternatives before we
decide what exactly we should do.

Oleg.


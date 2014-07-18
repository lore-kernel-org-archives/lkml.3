Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965275AbaGRMEd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 08:04:33 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:8244 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S964944AbaGRMEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 08:04:30 -0400
Date: Fri, 18 Jul 2014 08:04:19 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Wang Nan <wangnan0@huawei.com>
Cc: Ingo Molnar <mingo@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ftrace: Do not copy old hash when resetting.
Message-ID: <20140718080419.2bac2909@gandalf.local.home>
In-Reply-To: <53C8A622.4090902@huawei.com>
References: <1405311000-75943-1-git-send-email-wangnan0@huawei.com>
	<53C8A622.4090902@huawei.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jul 2014 12:44:18 +0800
Wang Nan <wangnan0@huawei.com> wrote:

> Hi Steve,
> 
> What's your opinion on my v2 patch ( https://lkml.org/lkml/2014/7/14/839 )?
> 
> I have swapped if consitions following your suggestion.
> 

Bah I didn't see it.

Damn Claws mail, I need to figure out why the f*ck it randomly marks
all my email as read. This has caused me to miss a few important emails
recently :-(

It looks fine, I've now marked it as todo that way I'll see it to pull
it in for 3.17. Thanks,

-- Steve


> On 2014/7/14 12:10, Wang Nan wrote:
> > If we are going to reset hash, we don't need to duplicate old hash
> > and remove every entries right after allocation.
> > 
> > Signed-off-by: Wang Nan <wangnan0@huawei.com>
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > ---
> >  kernel/trace/ftrace.c | 8 +++++---
> >  1 file changed, 5 insertions(+), 3 deletions(-)
> > 
> > diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> > index 5b372e3..52d6931 100644
> > --- a/kernel/trace/ftrace.c
> > +++ b/kernel/trace/ftrace.c
> > @@ -3471,14 +3471,16 @@ ftrace_set_hash(struct ftrace_ops *ops, unsigned char *buf, int len,
> >  	else
> >  		orig_hash = &ops->notrace_hash;
> >  
> > -	hash = alloc_and_copy_ftrace_hash(FTRACE_HASH_DEFAULT_BITS, *orig_hash);
> > +	if (!reset)
> > +		hash = alloc_and_copy_ftrace_hash(FTRACE_HASH_DEFAULT_BITS, *orig_hash);
> > +	else
> > +		hash = alloc_ftrace_hash(FTRACE_HASH_DEFAULT_BITS);
> > +
> >  	if (!hash) {
> >  		ret = -ENOMEM;
> >  		goto out_regex_unlock;
> >  	}
> >  
> > -	if (reset)
> > -		ftrace_filter_reset(hash);
> >  	if (buf && !ftrace_match_records(hash, buf, len)) {
> >  		ret = -EINVAL;
> >  		goto out_regex_unlock;
> > 
> 


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758940Ab3KMSKz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 13:10:55 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:10517 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754138Ab3KMSKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 13:10:48 -0500
Date: Wed, 13 Nov 2013 13:10:44 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] rcu: Make struct rcu_head searchable
Message-ID: <20131113131044.677cdc74@gandalf.local.home>
In-Reply-To: <20131113171205.GG4138@linux.vnet.ibm.com>
References: <20131113120225.3aacae13@gandalf.local.home>
	<20131113171205.GG4138@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Nov 2013 09:12:05 -0800
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

> On Wed, Nov 13, 2013 at 12:02:25PM -0500, Steven Rostedt wrote:
> > After wasting too much time trying to see where struct rcu_head was
> > declared, I finally found it in include/linux/types.h as a define for
> > callback_head!
> > 
> > To prevent other developers from wasting their precious time in
> > searching for this structure, add a comment to help them find it!
> > 
> > Cc: Al Viro <viro@ZenIV.linux.org.uk>
> > Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > Signed-off-by: Steven "frustrated" Rostedt <rostedt@goodmis.org>
> 
> The cscope tool is your friend in this case, but nevertheless:

I use emacs, and the latest version of etags (or emacs) brings you to
each use case before it gets you to the define (which is really
annoying). Back in 2006 it use to work properly. I need to figure out
what changed :-/


> 
> Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> > diff --git a/include/linux/types.h b/include/linux/types.h
> > index 4d118ba..073e9a8 100644
> > --- a/include/linux/types.h
> > +++ b/include/linux/types.h
> > @@ -210,6 +210,9 @@ struct callback_head {
> >  	struct callback_head *next;
> >  	void (*func)(struct callback_head *head);
> >  };
> > +/*
> > + * Make "struct rcu_head {" seachable with this comment.

I've been told s/seachable/searchable/

Frustration fails me ;-)

-- Steve

> > + */
> >  #define rcu_head callback_head
> > 
> >  #endif /*  __ASSEMBLY__ */
> > 


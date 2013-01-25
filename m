Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620Ab3AYOi5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 09:38:57 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.182]:39715 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751896Ab3AYOiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 09:38:54 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtkGAG6Zu0/O+Ip3/2dsb2JhbABEgXuyFoEIghUBAQUnExsBIxALGAklDwUlJBOIDroJj2JiA4hCjFiOGYFYgwc
X-IronPort-AV: E=Sophos;i="4.75,637,1330923600"; 
   d="scan'208";a="213654485"
Date: Fri, 25 Jan 2013 09:38:51 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [tracepoint] cargo-culting considered harmful...
Message-ID: <20130125143850.GA20597@Krystal>
References: <20130123225523.GY4939@ZenIV.linux.org.uk>
 <20130123230235.GC5434@home.goodmis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20130123230235.GC5434@home.goodmis.org>
X-Editor: vi
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Wed, Jan 23, 2013 at 10:55:24PM +0000, Al Viro wrote:
> > In samples/tracepoints/tracepoint-probe-sample.c:
> > /*
> >  * Here the caller only guarantees locking for struct file and struct inode.
> >  * Locking must therefore be done in the probe to use the dentry.
> >  */
> > static void probe_subsys_event(void *ignore,   
> >                                struct inode *inode, struct file *file)
> > {
> >         path_get(&file->f_path);
> >         dget(file->f_path.dentry);
> >         printk(KERN_INFO "Event is encountered with filename %s\n",
> >                 file->f_path.dentry->d_name.name);
> >         dput(file->f_path.dentry);
> >         path_put(&file->f_path);
> > }
> > 
> > note that
> > 	* file->f_path is already pinned down by open(), path_get() does not
> > provide anything extra.
> > 	* file->f_path.dentry is already pinned by open() *and* path_get()
> > just above that dget().
> > 	* ->d_name.name *IS* *NOT* *PROTECTED* by pinning dentry down,
> > whether it's done once or thrice.
> > 
> > I do realize that it's just an example, but perhaps we should rename that
> > file to match the contents?  The only question is whether it should be
> > git mv samples/tracepoints/{tracepoint-probe-sample,cargo-cult}.c
> > or git mv samples cargo-cult...
> 
> I wonder if we should just remove the samples/tracepoints/ all together.
> The tracepoint code is now only used internally by the trace_event code,
> and there should not be any users of tracepoints directly.

Yep, I'd be OK with removing this example, since now all users are
expected to user TRACE_EVENT(), which is built on top of tracepoints.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

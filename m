Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401AbaKMALH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 19:11:07 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:48807 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752894AbaKMALE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 19:11:04 -0500
X-Sasl-enc: X5VxyPAIn13ebj+8u6lkNuuUwFH+Yv3VnQVuaZZpht1z 1415837462
Message-ID: <1415837458.2631.13.camel@perseus.themaw.net>
Subject: Re: [PATCH 1/3] autofs - fix log print messages
From: Ian Kent <raven@themaw.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        autofs mailing list <autofs@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 13 Nov 2014 08:10:58 +0800
In-Reply-To: <20141112150700.bbb0d82dad1b133fccc1a0ec@linux-foundation.org>
References: <20141111012954.25773.4002.stgit@perseus.themaw.net>
	 <1415676341.16070.0.camel@perches.com>
	 <1415684245.2486.9.camel@perseus.themaw.net>
	 <1415684989.16070.2.camel@perches.com>
	 <1415685712.2486.17.camel@perseus.themaw.net>
	 <20141112150700.bbb0d82dad1b133fccc1a0ec@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-11-12 at 15:07 -0800, Andrew Morton wrote:
> On Tue, 11 Nov 2014 14:01:52 +0800 Ian Kent <raven@themaw.net> wrote:
> 
> > I guess I could make a kernel.org tree but, apart from this recent
> > rename autofs4 -> autofs, the number of autofs changes hasn't warranted
> > maintaining a separate tree for quite a while.
> > 
> > It looks like the place holder under /pub/scm/linux/kernel/git/raven is
> > no longer present so I expect I'd need to request that be setup.
> > 
> > That's why I just send my patches to Andrew to include them in -next.
> > 
> > Andrew, thoughts?
> 
> Various options.
> 
> a) redo these patches against mainline and I merge them into
>    3.19-rc1.  Shortly after that you send me the big rename as plain
>    old patches or, preferably, you send Linus a git pull request.  For
>    -rc2.

Given that something has gone missing along the way I'll fold these
latest patches into my original rename (and cleanup) series and resend
or whatever I end up doing.

> 
> b) You run a git tree for a while.

So that would mean doing what Joe recommended and asking Stephen
Rothwell to accept pull requests for my tree, and then send the pull
request to Linus after some reasonable soak time, correct?

> 
> The tree which these patches were based on seem to have more than a
> plain rename.  For example I get

Right, looks like something has gone missing along the way. 
The tree the patches are against is just a local clone of the Linus tree
with the patches I'd sent previously applied.

Folding these recent patches into the original series and sending one
series only that applies on the current Linus tree should sort out the
problem.

> 
> --- fs/autofs4/autofs_i.h
> +++ fs/autofs4/autofs_i.h
> @@ -37,15 +37,15 @@
>  /* #define DEBUG */
>  
>  #define DPRINTK(fmt, ...)				\
> -	pr_debug("pid %d: %s: " fmt "\n",		\
> +	pr_debug(KBUILD_MODNAME ":pid:%d:%s: " fmt "\n",\
>  		current->pid, __func__, ##__VA_ARGS__)
>  
>  #define AUTOFS_WARN(fmt, ...)				\
> -	pr_warn("pid %d: %s: " fmt "\n",	\
> +	pr_warn(KBUILD_MODNAME ":pid:%d:%s: " fmt "\n",	\
>  		current->pid, __func__, ##__VA_ARGS__)
>  
>  #define AUTOFS_ERROR(fmt, ...)				\
> -	pr_err("pid %d: %s: " fmt "\n",	\
> +	pr_err(KBUILD_MODNAME ":pid:%d:%s: " fmt "\n",	\
>  		current->pid, __func__, ##__VA_ARGS__)
>  
>  /*
> 
> 
> But I'm seeing
> 
> #define DPRINTK(fmt, ...)				\
> 	pr_debug("pid %d: %s: " fmt "\n",		\
> 		current->pid, __func__, ##__VA_ARGS__)
> 
> #define AUTOFS_WARN(fmt, ...)				\
> 	printk(KERN_WARNING "pid %d: %s: " fmt "\n",	\
> 		current->pid, __func__, ##__VA_ARGS__)
> 
> #define AUTOFS_ERROR(fmt, ...)				\
> 	printk(KERN_ERR "pid %d: %s: " fmt "\n",	\
> 		current->pid, __func__, ##__VA_ARGS__)
> 
> /* Unified info structure.  This is pointed to by both the dentry and
> 
> ie: the comment layout was changed.



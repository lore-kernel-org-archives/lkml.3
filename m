Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932437Ab3IOQdS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 12:33:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16779 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757130Ab3IOQdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 12:33:00 -0400
Date: Sun, 15 Sep 2013 18:26:41 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: viro@zeniv.linux.org.uk, rostedt@goodmis.org, fweisbec@gmail.com,
        mingo@redhat.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] argv_split: Return NULL if argument contains
	nonon-whitespace.
Message-ID: <20130915162641.GA13344@redhat.com>
References: <201309141632.GHD86439.VLOOOFQFJtSMFH@I-love.SAKURA.ne.jp> <20130914154144.GA7884@redhat.com> <201309150910.CCE73459.VMOFtJFLSHOQFO@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201309150910.CCE73459.VMOFtJFLSHOQFO@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15, Tetsuo Handa wrote:
>
> Oleg Nesterov wrote:
> > > upon core dump because helper_argv[0] == NULL at
> > >
> > >   helper_argv = argv_split(GFP_KERNEL, cn.corename, NULL);
> > >   call_usermodehelper_setup(helper_argv[0], ...);
> >
> > Are you sure? See above.
> >
>
> Yes, I'm sure.

I thougt you meant that call_usermodehelper_setup() crashes. "See above"
means that afaics it should crash in do_filp_open().

> execve(NULL) from user space is safe,

because it never does do_execve(NULL),

> but
> do_execve(NULL) from kernel space is not safe.

Yes, this is clear.

> > Perhaps
> >
> > 	--- x/kernel/kmod.c
> > 	+++ x/kernel/kmod.c
> > 	@@ -571,6 +571,9 @@ int call_usermodehelper_exec(struct subp
> > 		DECLARE_COMPLETION_ONSTACK(done);
> > 		int retval = 0;
> >
> > 	+	if (!sub_info->path)
> > 	+		return -EXXX;
> > 	+
> > 		helper_lock();
> > 		if (!khelper_wq || usermodehelper_disabled) {
> > 			retval = -EBUSY;
> >
> > ?
> >
>
> I'm OK with that.

OK,

Oleg.


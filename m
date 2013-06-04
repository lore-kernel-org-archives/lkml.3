Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373Ab3FDRSd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 13:18:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53314 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752332Ab3FDRS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 13:18:29 -0400
Date: Tue, 4 Jun 2013 19:14:35 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        Sergey Dyasly <dserrg@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] proc: avoid ->f_pos overflows in
	proc_task_readdir() paths
Message-ID: <20130604171435.GA20416@redhat.com>
References: <20130603190705.GA11517@redhat.com> <877giarg81.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877giarg81.fsf@xmission.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03, Eric W. Biederman wrote:
>
> Oleg Nesterov <oleg@redhat.com> writes:
>
> > 1. proc_task_readdir() truncates f_pos to long, this can lead
> >    to wrong result on 32bit.
> >
> This won't compile on some 32bit architectures like x86-32.
>
> switch(unsigned long long) requires helpers that the kernel does not
> included.  Or at least the kernel has not included because such code
> is a problem.  In fact that is the reason Linus put the case to
> unsigned long in there.

Hmm, ee568b25, suprise... I am wondering if the kernel still supports
the compilers which needs __cmpdi2 in this case...

But this doesn't matter. The patch should not blindly revert ee568b25,
thanks!

> There is another bug in here as well that we may return really crazy
> things in the case of seek simultaneous with readdir.

i_mutex? both vfs_readdir() and default_llseek() take it... Anyway, this
is another issue.

> I think we really need to put f_pos
> in a local variable.

Heh. I swear, this is what I did initially. But I was afraid you will
blame this change as "overcomplicated" ;)

OK, I'll redo/resend this one later.

Oleg.


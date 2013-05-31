Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831Ab3EaSiV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 14:38:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35076 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754036Ab3EaSiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 14:38:13 -0400
Date: Fri, 31 May 2013 20:34:20 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Sergey Dyasly <dserrg@gmail.com>,
        Sha Zhengju <handai.szj@taobao.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] proc: simplify proc_task_readdir/first_tid paths
Message-ID: <20130531183419.GA4493@redhat.com>
References: <20130527202822.GA19288@redhat.com> <87ppwa1jn0.fsf@xmission.com> <20130529133930.GB5741@redhat.com> <878v2xzfl7.fsf@xmission.com> <20130531163834.GA31086@redhat.com> <87a9nbt3w3.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a9nbt3w3.fsf@xmission.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31, Eric W. Biederman wrote:
>
> Oleg Nesterov <oleg@redhat.com> writes:
>
> > OK. But this means that even 1/3 is not 100% right, exactly because
> > leader can be unhashed right before first_tid() takes rcu lock. Easy
> > to fix, we should simply factor out the "nr != 0" check.
> >
> > And this also means that 3/3 is not right by the same reason. I'll
> > make a simpler patch which only avoids the unnecessary get/put in
> > proc_task_readdir().
> >
> > Unless we can tolerate this very unlikely rase when the leader goes
> > away after initial ENOENT check at the start, of course... Or unless
> > we add canceldir() which resets getdents_callback->previous so that
> > we could return ENOENT after filldir() was already called ;)
>
> A small race is fine and is fundamental to the process of readdir.
>
> The guarantee of open+readdir+close is that all directory entries that
> exited before open and after close are returned.  Directory entries that
> are added or removed during the open+readir+close are returned at most
> once.
>
> The important case to handle is when someone has opened the directory a
> very long time ago or has chdir'd to the directory.  With the result
> the directory was removed before we start the readdir process entirely.
>
> If the tasks die in the narrow window while we are inside of readdir
> races are impossible to avoid.

Ah OK. This means that v2 only needs the simple update.

Thanks again Eric.

Oleg.


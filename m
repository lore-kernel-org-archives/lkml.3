Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751333Ab3FDUA5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 16:00:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16771 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017Ab3FDUAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 16:00:55 -0400
Date: Tue, 4 Jun 2013 21:57:00 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, Sergey Dyasly <dserrg@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] proc: avoid ->f_pos overflows in
	proc_task_readdir() paths
Message-ID: <20130604195700.GA31933@redhat.com>
References: <20130603190705.GA11517@redhat.com> <877giarg81.fsf@xmission.com> <20130604171435.GA20416@redhat.com> <20130604173917.GB13110@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130604173917.GB13110@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04, Al Viro wrote:
>
> On Tue, Jun 04, 2013 at 07:14:35PM +0200, Oleg Nesterov wrote:
> > > There is another bug in here as well that we may return really crazy
> > > things in the case of seek simultaneous with readdir.
> >
> > i_mutex? both vfs_readdir() and default_llseek() take it... Anyway, this
> > is another issue.
>
> That's part of the reasons for the series I've mentioned (vfs.git#experimental);
> seriously, check that up.

Will do... but so far I am confused.

I do not see how they could race (I mean /proc/pid/task only). OK, OK,
the usage of ->f_pos in sys_getdents() looks "obviously wrong", but this
is another story? And "put f_pos in a local variable" can't help.

But if you meant other problems with readdir in general, then I seem
to understand, thanks.

Oleg.


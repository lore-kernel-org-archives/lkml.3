Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166Ab3KFTb7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 14:31:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49323 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932141Ab3KFTbz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 14:31:55 -0500
Date: Wed, 6 Nov 2013 20:33:11 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Serge Hallyn <serge.hallyn@ubuntu.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Brad Spengler <spender@grsecurity.net>
Cc: Christian Seiler <christian@iwakd.de>, lkml <linux-kernel@vger.kernel.org>,
        Andy Whitcroft <apw@canonical.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Lxc development list <lxc-devel@lists.sourceforge.net>
Subject: Re: CLONE_PARENT after setns(CLONE_NEWPID)
Message-ID: <20131106193311.GA18720@redhat.com>
References: <20131106180232.GA8980@ac100>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131106180232.GA8980@ac100>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Serge,

On 11/06, Serge Hallyn wrote:
>
> Hi Oleg,
>
> commit 40a0d32d1eaffe6aac7324ca92604b6b3977eb0e :
> "fork: unify and tighten up CLONE_NEWUSER/CLONE_NEWPID checks"
> breaks lxc-attach in 3.12.  That code forks a child which does
> setns() and then does a clone(CLONE_PARENT).  That way the
> grandchild can be in the right namespaces (which the child was
> not) and be a child of the original task, which is the monitor.

Thanks...

Yes, this is what 40a0d32d1ea explicitly tries to disallow.

> Is there a real danger in allowing CLONE_PARENT
> when current->nsproxy->pidns_for_children is not our pidns,
> or was this done out of an "over-abundance of caution"?

I am not sure... This all was based on the long discussion, and
it was decided that the CLONE_PARENT check should be consistent
wrt CLONE_NEWPID and pidns_for_children != task_active_pid_ns().

> Can we
> safely revert that new extra check?

Well, usually we do not break user-space, but I am not sure about
this case...

Eric, Andy, what do you think?

And if we allow CLONE_PARENT when ->pidns_for_children was changed,
should we also allow, say, CLONE_NEWPID && CLONE_PARENT ?

Oleg.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012Ab3KFWxD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 17:53:03 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:55068 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053Ab3KFWxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 17:53:01 -0500
Date: Wed, 6 Nov 2013 16:53:37 -0600
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Brad Spengler <spender@grsecurity.net>,
        Christian Seiler <christian@iwakd.de>,
        lkml <linux-kernel@vger.kernel.org>,
        Andy Whitcroft <apw@canonical.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Lxc development list <lxc-devel@lists.sourceforge.net>
Subject: Re: CLONE_PARENT after setns(CLONE_NEWPID)
Message-ID: <20131106225337.GB11611@ac100>
References: <20131106180232.GA8980@ac100>
 <20131106193311.GA18720@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131106193311.GA18720@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oleg Nesterov (oleg@redhat.com):
> Hi Serge,
> 
> On 11/06, Serge Hallyn wrote:
> >
> > Hi Oleg,
> >
> > commit 40a0d32d1eaffe6aac7324ca92604b6b3977eb0e :
> > "fork: unify and tighten up CLONE_NEWUSER/CLONE_NEWPID checks"
> > breaks lxc-attach in 3.12.  That code forks a child which does
> > setns() and then does a clone(CLONE_PARENT).  That way the
> > grandchild can be in the right namespaces (which the child was
> > not) and be a child of the original task, which is the monitor.
> 
> Thanks...
> 
> Yes, this is what 40a0d32d1ea explicitly tries to disallow.
> 
> > Is there a real danger in allowing CLONE_PARENT
> > when current->nsproxy->pidns_for_children is not our pidns,
> > or was this done out of an "over-abundance of caution"?
> 
> I am not sure... This all was based on the long discussion, and
> it was decided that the CLONE_PARENT check should be consistent
> wrt CLONE_NEWPID and pidns_for_children != task_active_pid_ns().

So apart from peers seeing the new task as having pid 0, and
sigchild going to the grandparent, are there any other side
effects?  Is ptrace an issue?  (I took a quick look but it
doesn't seem like it)

If not, then I very much think we should continue to allow this.

-serge

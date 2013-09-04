Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935032Ab3IDO6n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 10:58:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63853 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934731Ab3IDO6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 10:58:41 -0400
Date: Wed, 4 Sep 2013 10:58:30 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Jan Kaluza <jkaluza@redhat.com>, davem@davemloft.net,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        eparis@redhat.com, tj@kernel.org, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        viro@zeniv.linux.org.uk
Subject: Re: [PATCH v3 0/3] Send audit/procinfo/cgroup data in socket-level
 control message
Message-ID: <20130904145830.GC28517@madcap2.tricolour.ca>
References: <1377614400-27122-1-git-send-email-jkaluza@redhat.com>
 <1378275261-4553-1-git-send-email-jkaluza@redhat.com>
 <878uzdf2xp.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878uzdf2xp.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 04, 2013 at 12:42:26AM -0700, Eric W. Biederman wrote:
> Jan Kaluza <jkaluza@redhat.com> writes:
> > Hi,
> >
> > this patchset against net-next (applies also to linux-next) adds 3 new types
> > of "Socket"-level control message (SCM_AUDIT, SCM_PROCINFO and SCM_CGROUP).
> >
> > Server-like processes in many cases need credentials and other
> > metadata of the peer, to decide if the calling process is allowed to
> > request a specific action, or the server just wants to log away this
> > type of information for auditing tasks.
> >
> > The current practice to retrieve such process metadata is to look that
> > information up in procfs with the $PID received over SCM_CREDENTIALS.
> > This is sufficient for long-running tasks, but introduces a race which
> > cannot be worked around for short-living processes; the calling
> > process and all the information in /proc/$PID/ is gone before the
> > receiver of the socket message can look it up.
> 
> > Changes introduced in this patchset can also increase performance
> > of such server-like processes, because current way of opening and
> > parsing /proc/$PID/* files is much more expensive than receiving these
> > metadata using SCM.
> 
> Can I just say ick, blech, barf, gag.

/me hands ebiederman an air sickness bag.

> You don't require this information to be passed.  You are asking people
> to suport a lot of new code for the forseeable future.  The only advantage
> appears to be for short lived racy processes that don't even bother to
> make certain their message was acknowleged before exiting.
> 
> You sent this during the merge window which is the time for code
> integration and testing not new code.

This is an RFC.  How is this important?

> By my count you have overflowed cb in struct sk_buff and are stomping on
> _skb_refdest.

For patch1/3 I count 56/48, then for patch3 I get 48/48.  Jan, you might
do the conversion to a pointer in patch1/3 to avoid bisect breakage.

> If you are going to go crazy and pass things is there a reason you do
> not add a patch to pass the bsd SCM_CREDS?  That information seems more
> relevant in a security context and for making security decisions than
> about half the information you are passing.
> 
> Eric

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer
Kernel Security
AMER ENG Base Operating Systems
Remote, Ottawa, Canada
Voice: +1.647.777.2635
Internal: (81) 32635
Alt: +1.613.693.0684x3545

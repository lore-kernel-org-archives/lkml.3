Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936127Ab3DJQUg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 12:20:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53933 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933387Ab3DJQUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 12:20:33 -0400
Date: Wed, 10 Apr 2013 12:20:18 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Steve Grubb <sgrubb@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] [BZ905179] audit: omit check for uid and gid validity in
 audit rules and data
Message-ID: <20130410162018.GE28504@madcap2.tricolour.ca>
References: <1363807097-13073-1-git-send-email-rgb@redhat.com>
 <20130408164622.284f48c65341396aa8dbd220@linux-foundation.org>
 <87ip3w59gr.fsf@xmission.com>
 <1790080.52kjZ1ec4G@x2>
 <87vc7v1k2h.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87vc7v1k2h.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 09, 2013 at 02:16:22PM -0700, Eric W. Biederman wrote:
> Steve Grubb <sgrubb@redhat.com> writes:
> 
> > On Tuesday, April 09, 2013 02:39:32 AM Eric W. Biederman wrote:
> >> Andrew Morton <akpm@linux-foundation.org> writes:
> >> > On Wed, 20 Mar 2013 15:18:17 -0400 Richard Guy Briggs <rgb@redhat.com> 
> > wrote:
> >> >> audit rule additions containing "-F auid!=4294967295" were failing with
> >> >> EINVAL.
> >> >> 
> >> >> UID_INVALID (and GID_INVALID) is actually a valid uid (gid) for setting
> >> >> and
> >> >> testing against audit rules.  Remove the check for invalid uid and gid
> >> >> when
> >> >> parsing rules and data for logging.
> >> 
> >> In general testing against invalid uid appears completely bogus, and
> >> should always return true.  As it is and essentially always has been
> >> incorrect to explicitly set any kernel uid to that value.
> >
> > This is the unset value that daemons would have. 
> 
> As their uid, or gid, or euid, or fsuid.  Not in the least.

Point taken that only a value of UID_INVALID should be accepted for
auid.

> > When a real person logs in, 
> > pam_loginuid writes the loginuid that was authenticated to. So, any time the 
> > value is -1, we are dealing with a daemon or system process. When it comes to 
> > auditing, people usually make an exception so that daemon and normal system 
> > activity is not recorded. So, you would make a rule something like
> 
> > -a always,exit -S open -F exit=-EPERM -F auid>=500 -F auid!=-1
> 
> My point is that -1 is a special case that applies only to loginuid, and
> that when testing for -1 is not testing for a specific loginuid value
> but instead it is testing to see if loginuid has been set.  Semantically
> the last is very different.
> 
> >> The only case where this appears to make the least little bit of sense
> >> is if the goal of the test is to test to see if an audit logloginuid
> >> has been set at all.  In which case depending on a test against
> >> 4294967295 is bogus because you are depending on an intimate internal
> >> kernel implementation detail.
> >
> > Its been this way and documented since at least 9 years ago. The audit system 
> > has been broken for all intents and purposes since the 3.7 kernel was 
> > released.
> 
> I certainly haven't seen the documentation.

It is in the audit manpages.

> And no one has much cared
> about the audit subsystem this "breakage" of the audit
> subsystem. Despite things failing with a clear error code.  So there are
> two choices.  We mark the audit subsystem as broken moving it to staging
> and then delete it because no one cares enough to look after it and
> maintain it.  Or we have a constructive conversation about what to do
> with it.

Ok, politics aside...

> I have proposed a patch that will preserve the existing behavior while
> adding maintainable semantics.  Will someone who cares please test my
> proposed fix?

I'll test it.

> Eric

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer
AMER ENG Base Operating Systems
Remote, Canada, Ottawa
Voice: 1.647.777.2635
Internal: (81) 32635

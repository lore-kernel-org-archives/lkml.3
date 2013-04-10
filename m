Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936815Ab3DJRfc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 13:35:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24909 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935720Ab3DJRfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 13:35:31 -0400
Date: Wed, 10 Apr 2013 13:35:26 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, linux-audit@redhat.com
Subject: Re: [PATCH] [BZ905179] audit: omit check for uid and gid validity in
 audit rules and data
Message-ID: <20130410173526.GF28504@madcap2.tricolour.ca>
References: <1363807097-13073-1-git-send-email-rgb@redhat.com>
 <20130408164622.284f48c65341396aa8dbd220@linux-foundation.org>
 <87ip3w59gr.fsf@xmission.com>
 <1790080.52kjZ1ec4G@x2>
 <87vc7v1k2h.fsf@xmission.com>
 <20130410162018.GE28504@madcap2.tricolour.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130410162018.GE28504@madcap2.tricolour.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 12:20:18PM -0400, Richard Guy Briggs wrote:
> On Tue, Apr 09, 2013 at 02:16:22PM -0700, Eric W. Biederman wrote:
> > Steve Grubb <sgrubb@redhat.com> writes:
> > > On Tuesday, April 09, 2013 02:39:32 AM Eric W. Biederman wrote:
> > >> Andrew Morton <akpm@linux-foundation.org> writes:
> > >> > On Wed, 20 Mar 2013 15:18:17 -0400 Richard Guy Briggs <rgb@redhat.com> wrote:
> > >> >> audit rule additions containing "-F auid!=4294967295" were failing with
> > >> >> EINVAL.
> > >> >> 
> > >> >> UID_INVALID (and GID_INVALID) is actually a valid uid (gid) for setting
> > >> >> and
> > >> >> testing against audit rules.  Remove the check for invalid uid and gid
> > >> >> when
> > >> >> parsing rules and data for logging.
> > >> 
> > >> In general testing against invalid uid appears completely bogus, and
> > >> should always return true.  As it is and essentially always has been
> > >> incorrect to explicitly set any kernel uid to that value.
> > >
> > > This is the unset value that daemons would have. 
> > 
> > As their uid, or gid, or euid, or fsuid.  Not in the least.
> 
> Point taken that only a value of UID_INVALID should be accepted for
> auid.

> > And no one has much cared
> > about the audit subsystem this "breakage" of the audit
> > subsystem. Despite things failing with a clear error code.  So there are
> > two choices.  We mark the audit subsystem as broken moving it to staging
> > and then delete it because no one cares enough to look after it and
> > maintain it.  Or we have a constructive conversation about what to do
> > with it.
> 
> Ok, politics aside...
> 
> > I have proposed a patch that will preserve the existing behavior while
> > adding maintainable semantics.  Will someone who cares please test my
> > proposed fix?
> 
> I'll test it.

Meanwhile, could you please respond to my other comments interlaced in my
previous reply earlier in the thread?  In particular the question about
f->val == 1.

> > Eric
> 
> - RGB

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer
AMER ENG Base Operating Systems
Remote, Canada, Ottawa
Voice: 1.647.777.2635
Internal: (81) 32635

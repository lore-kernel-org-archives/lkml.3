Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731Ab3DJSqP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 14:46:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62480 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676Ab3DJSqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 14:46:14 -0400
Date: Wed, 10 Apr 2013 14:46:09 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-audit@redhat.com, Eric Paris <eparis@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] [BZ905179] audit: omit check for uid and gid validity in
 audit rules and data
Message-ID: <20130410184609.GG28504@madcap2.tricolour.ca>
References: <1363807097-13073-1-git-send-email-rgb@redhat.com>
 <20130408164622.284f48c65341396aa8dbd220@linux-foundation.org>
 <87ip3w59gr.fsf@xmission.com>
 <20130409201558.GE31242@madcap2.tricolour.ca>
 <871uaiz2kc.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871uaiz2kc.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 11:02:43AM -0700, Eric W. Biederman wrote:
> Richard Guy Briggs <rgb@redhat.com> writes:
> > On Tue, Apr 09, 2013 at 02:39:32AM -0700, Eric W. Biederman wrote:
> >> @@ -377,6 +383,12 @@ static struct audit_entry *audit_rule_to_entry(struct audit_rule *rule)
> >>  			if (!gid_valid(f->gid))
> >>  				goto exit_free;
> >>  			break;
> >> +		case AUDIT_LOGINUID_SET:
> >> +			if ((f->op != Audit_not_equal) && (f->op != Audit_equal))
> >> +				goto exit_free;
> >> +			if ((f->val != 0) && (f->val != 1))
> >
> > Why the extra comparison to "1"?
> >
> > Are you anticipating already a userspace process making a call using the
> > newof type AUDIT_LOGINUID_SET with a value of 1?
> 
> Sorry I missed this question the first time.  I am anticipating
> AUDIT_LOGINUID_SET to return a value of 0 or 1 (a boolean) and so I
> allow the operations and constants that are valid for a boolean.
> 
> In particuluar I allow the opeartions == !=  and the boolean constants 0 and 1.

Duh, of course...  sorry for being thick.

> >> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> >> index 3a11d34..27d0a50 100644
> >> --- a/kernel/auditsc.c
> >> +++ b/kernel/auditsc.c
> >> @@ -750,6 +750,9 @@ static int audit_filter_rules(struct task_struct *tsk,
> >>  			if (ctx)
> >>  				result = audit_uid_comparator(tsk->loginuid, f->op, f->uid);
> >>  			break;
> >
> > (OT: I assume the "if (ctx)" is wrong in the AUDIT_LOGINUID case
> > above.)
> 
> Good question.  I didn't see that when I was preparing my patch.
> 
> ctx is not necessary but I think ctx is set when a task is being audited
> so it may serve a useful function.  But I have to admit it that if(ctx)
> looks like a bug.

Thanks...

> Eric

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer
AMER ENG Base Operating Systems
Remote, Canada, Ottawa
Voice: 1.647.777.2635
Internal: (81) 32635

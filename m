Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975Ab3LKRT5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 12:19:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26233 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751933Ab3LKRTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 12:19:54 -0500
Date: Wed, 11 Dec 2013 12:19:12 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: John Johansen <john.johansen@canonical.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        Ingo Molnar <mingo@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH 03/12] pid: get ppid pid_t of task in init_pid_ns safely
Message-ID: <20131211171912.GA10002@madcap2.tricolour.ca>
References: <cover.1377032086.git.rgb@redhat.com>
 <a411b87ba4c4af251166ee5877cb8c646cf7826c.1377032086.git.rgb@redhat.com>
 <20130827172155.GC29147@redhat.com>
 <20130830195646.GJ21110@madcap2.tricolour.ca>
 <52210275.8040601@canonical.com>
 <20130903183159.GA28517@madcap2.tricolour.ca>
 <20131211144758.GA1160@madcap2.tricolour.ca>
 <52A8966A.9080306@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52A8966A.9080306@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/12/11, John Johansen wrote:
> On 12/11/2013 06:47 AM, Richard Guy Briggs wrote:
> > On Tue, Sep 03, 2013 at 02:31:59PM -0400, Richard Guy Briggs wrote:
> >> On Fri, Aug 30, 2013 at 01:37:09PM -0700, John Johansen wrote:
> >>> On 08/30/2013 12:56 PM, Richard Guy Briggs wrote:
> >>>> On Tue, Aug 27, 2013 at 07:21:55PM +0200, Oleg Nesterov wrote:
> >>>>> On 08/20, Richard Guy Briggs wrote:
> >>>> Most of the instances are current, but the one called from apparmour is
> >>>> stored.  I've just learned that this is bad and someone else just chimed
> >>>> in that they have a patch to remove it...
> >>>
> >>> the apparmor case isn't actually stored long term. The stored task will be
> >>> a parameter that was passed into an lsm hook and the buffer that it is
> >>> stored in dies before the hook is done. Its temporarily stored in the
> >>> struct so that it can be passed into the lsm_audit fn, and printed into an
> >>> allocated audit buffer. The text version in the audit buffer is what will
> >>> exist beyond the hook.
> >>>
> >>> There are three patches, I'll reply them below once I have finished rebasing
> >>> them to apply to the current tree instead of my dev tree.
> >>
> >> John, thanks for this context and fix.  That helps simplify things.
> > 
> > John, What's the status of this set of 3 patches?  I don't see them
> > upstream.
> > 
> they are part of the security tree merge in 3.13
> 
> 51775fe apparmor: remove the "task" arg from may_change_ptraced_domain()
> 4a7fc30 apparmor: remove parent task info from audit logging
> 61e3fb8 apparmor: remove tsk field from the apparmor_audit_struct
> dd0c6e8 apparmor: fix capability to not use the current task, during reporting

Ok, cool, so they will be upstream by the time I'll need them.  Thanks!

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545

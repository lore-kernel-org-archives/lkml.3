Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056AbbASP0D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 10:26:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45274 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751726AbbASP0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 10:26:00 -0500
Date: Mon, 19 Jan 2015 10:25:50 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-audit@redhat.com
Subject: Re: [PATCH] TaskTracker : Simplified thread information tracker.
Message-ID: <20150119152550.GR29998@madcap2.tricolour.ca>
References: <20140927091440.6fe54f43@ivy-bridge>
 <201409280012.FGE05239.VtFOSMOJFOFQLH@I-love.SAKURA.ne.jp>
 <20141007213054.GJ26201@madcap2.tricolour.ca>
 <201410102140.HHB30768.tFVJSFQOMLOOFH@I-love.SAKURA.ne.jp>
 <20141010124923.GD2966@madcap2.tricolour.ca>
 <201501042050.EEH30201.FJVtFHMQOLSFOO@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201501042050.EEH30201.FJVtFHMQOLSFOO@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/01/04, Tetsuo Handa wrote:
> Hello.
> 
> Richard Guy Briggs wrote:
> > > Richard Guy Briggs wrote:
> > > > On 14/09/28, Tetsuo Handa wrote:
> > > > > (Q2) Does auxiliary record work with only type=SYSCALL case?
> > > > 
> > > > Auxiliary records don't work with AUDIT_LOGIN because that record has a
> > > > NULL context.  Similarly for core dumps (AUDIT_ANOM_ABEND), AUDIT_SECCOMP,
> > > > configuration changes (AUDIT_CONFIG_CHANGE, AUDIT_FEATURE_CHANGE), most
> > > > (all?) AUDIT_USER_* messages.
> > > > 
> > > I see, thank you.
> > > 
> > > Although I feel that, from the point of view of troubleshooting, emitting
> > > history of thread's comm name into NULL-context records would help sysadmin
> > > to map login session and operations a user did from that login session,
> > > I'm OK with starting history of thread's comm name as auxiliary records
> > > (i.e. not emitted into NULL-context records).
> > > 
> > > Adding LKML for reviewers. What else can I do for merging this patch?
> > 
> > I'm willing to take it with some reflection and no significant
> > objections, in particular from userspace audit.  I'll have a closer look
> > at it.
> 
> Any comments on this patch?

It also occurs to me that the pid_t of that process in init PID
namespace would be useful for each entry.

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545

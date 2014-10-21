Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933289AbaJUQlQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 12:41:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60891 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932644AbaJUQlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 12:41:15 -0400
Date: Tue, 21 Oct 2014 12:41:09 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: Steve Grubb <sgrubb@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        ebiederm@xmission.com, serge@hallyn.com,
        Eric Paris <eparis@redhat.com>
Subject: Re: [RFC][PATCH] audit: log join and part events to the read-only
 multicast log socket
Message-ID: <20141021164109.GL26201@madcap2.tricolour.ca>
References: <30ef5c1ba42b52953e5684a0322975c3f0fadc77.1412706089.git.rgb@redhat.com>
 <1412708594.3333.94.camel@localhost>
 <20141007193951.GZ1992@madcap2.tricolour.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141007193951.GZ1992@madcap2.tricolour.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/10/07, Richard Guy Briggs wrote:
> On 14/10/07, Eric Paris wrote:
> > On Tue, 2014-10-07 at 14:23 -0400, Richard Guy Briggs wrote:
> > > Log the event when a client attempts to connect to the netlink audit multicast
> > > socket, requiring CAP_AUDIT_READ capability, binding to the AUDIT_NLGRP_READLOG
> > > group.  Log the disconnect too.

> > super crazy yuck.  audit_log_task_info() ??
> 
> I agree.  I already suggested that a while ago.  I'd love to.  sgrubb
> thinks it dumps way too much info.  We still haven't got a definitive
> answer about what is enough and what is too much info for any given type
> of record.
> 
> I also thought of moving audit_log_task() from auditsc.c to audit.c
> and using that.  For that matter, both audit_log_task() and
> audit_log_task_info() could use audit_log_session_info(), but they are
> in slightly different order of keywords which will upset sgrubb's
> parser.
> 
> What to do?
> 
> Another paragraph I'd like to see added to
> 	http://people.redhat.com/sgrubb/audit/audit-parse.txt
> would be a "canonical order" of keywords.  However, that discussion went
> nowhere.  Would it be reasonable to suggest only two possible orders
> instead of the almost infinite iterations possible and declare a
> standard order of keywords and gradually move to it?

Steve,

Can we agree to *two* orders (instead of the full set of iterations) for
these keywords so that we can start to sort things in a canonical order?
This random order per type of audit log message is chaos.

> - RGB

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640Ab3EPVz3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 17:55:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40754 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868Ab3EPVz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 17:55:27 -0400
Date: Thu, 16 May 2013 17:54:59 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Robert Richter <rric@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, x86@kernel.org,
        linux-kernel@vger.kernel.org, gleb@redhat.com
Subject: Re: Drop WARN on AMD lack of perfctrs
Message-ID: <20130516215459.GD18325@hansolo.jdub.homelinux.org>
References: <20130516151026.GB18325@hansolo.jdub.homelinux.org>
 <20130516175117.GK19669@dyad.programming.kicks-ass.net>
 <20130516175557.GC18325@hansolo.jdub.homelinux.org>
 <20130516181018.GO19669@dyad.programming.kicks-ass.net>
 <20130516205558.GE8356@rric.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130516205558.GE8356@rric.localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 16, 2013 at 10:55:58PM +0200, Robert Richter wrote:
> On 16.05.13 20:10:18, Peter Zijlstra wrote:
> > On Thu, May 16, 2013 at 01:55:57PM -0400, Josh Boyer wrote:
> > > Maybe.  But do you really need to dump a stack trace here?  What is a
> > > user supposed to do with that information?  Can they fix the kernel?
> > > Can the fix the CPU?  As far as I can tell, they can't do either.
> > 
> > Send their CPU back to AMD is I suppose the best they can do ;-)
> >  
> > > Is using pr_err with the same message really somehow worse than using
> > > WARN?
> > 
> > I would make it a FW_BUG as well. But yeah, I suppose that is a better option
> > than the WARN_ON. Unless Robert had a different reason...
> 
> iirc the reason was the different msr range that is switched on fam15h
> with a different counter to counter msr offset of 2 instead of 1. The
> code relies on the assumption that the msrs exist on that cpu. Thus
> the warning if not. Also note that code may have changed in 3.10 in
> that area.

Again, what is someone supposed to do with a backtrace from the WARN?
As far as I can see, a user can't really do anything other than report
it and then there's nothing to fix.

The code might have moved in 3.10, but the WARN is still there.

Would you like me to send a patch to get it reduced to pr_err?

josh

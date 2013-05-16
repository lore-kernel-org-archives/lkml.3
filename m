Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878Ab3EPU4I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 16:56:08 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33476 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884Ab3EPU4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 16:56:05 -0400
Date: Thu, 16 May 2013 22:55:58 +0200
From: Robert Richter <rric@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Josh Boyer <jwboyer@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, x86@kernel.org,
        linux-kernel@vger.kernel.org, gleb@redhat.com
Subject: Re: Drop WARN on AMD lack of perfctrs
Message-ID: <20130516205558.GE8356@rric.localhost>
References: <20130516151026.GB18325@hansolo.jdub.homelinux.org>
 <20130516175117.GK19669@dyad.programming.kicks-ass.net>
 <20130516175557.GC18325@hansolo.jdub.homelinux.org>
 <20130516181018.GO19669@dyad.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130516181018.GO19669@dyad.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.05.13 20:10:18, Peter Zijlstra wrote:
> On Thu, May 16, 2013 at 01:55:57PM -0400, Josh Boyer wrote:
> > Maybe.  But do you really need to dump a stack trace here?  What is a
> > user supposed to do with that information?  Can they fix the kernel?
> > Can the fix the CPU?  As far as I can tell, they can't do either.
> 
> Send their CPU back to AMD is I suppose the best they can do ;-)
>  
> > Is using pr_err with the same message really somehow worse than using
> > WARN?
> 
> I would make it a FW_BUG as well. But yeah, I suppose that is a better option
> than the WARN_ON. Unless Robert had a different reason...

iirc the reason was the different msr range that is switched on fam15h
with a different counter to counter msr offset of 2 instead of 1. The
code relies on the assumption that the msrs exist on that cpu. Thus
the warning if not. Also note that code may have changed in 3.10 in
that area.

-Robert

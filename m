Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991Ab3EPWdx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 18:33:53 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:36434 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640Ab3EPWdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 18:33:52 -0400
Date: Fri, 17 May 2013 00:33:45 +0200
From: Robert Richter <rric@kernel.org>
To: Josh Boyer <jwboyer@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, x86@kernel.org,
        linux-kernel@vger.kernel.org, gleb@redhat.com
Subject: Re: Drop WARN on AMD lack of perfctrs
Message-ID: <20130516223345.GF8356@rric.localhost>
References: <20130516151026.GB18325@hansolo.jdub.homelinux.org>
 <20130516175117.GK19669@dyad.programming.kicks-ass.net>
 <20130516175557.GC18325@hansolo.jdub.homelinux.org>
 <20130516181018.GO19669@dyad.programming.kicks-ass.net>
 <20130516205558.GE8356@rric.localhost>
 <20130516215459.GD18325@hansolo.jdub.homelinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130516215459.GD18325@hansolo.jdub.homelinux.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.05.13 17:54:59, Josh Boyer wrote:
> On Thu, May 16, 2013 at 10:55:58PM +0200, Robert Richter wrote:
> > On 16.05.13 20:10:18, Peter Zijlstra wrote:
> > > I would make it a FW_BUG as well. But yeah, I suppose that is a better option
> > > than the WARN_ON. Unless Robert had a different reason...
> > 
> > iirc the reason was the different msr range that is switched on fam15h
> > with a different counter to counter msr offset of 2 instead of 1. The
> > code relies on the assumption that the msrs exist on that cpu. Thus
> > the warning if not. Also note that code may have changed in 3.10 in
> > that area.
> 
> Again, what is someone supposed to do with a backtrace from the WARN?
> As far as I can see, a user can't really do anything other than report
> it and then there's nothing to fix.
> 
> The code might have moved in 3.10, but the WARN is still there.
> 
> Would you like me to send a patch to get it reduced to pr_err?

I wrote the code with the assumption of a certain system layout which
was the check for. Now, in a vm this assumption is no longer valid.
Will change the code in a way this is handled properly.

-Robert

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834Ab3LEJac (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 04:30:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49228 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351Ab3LEJa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 04:30:28 -0500
Date: Thu, 5 Dec 2013 10:29:37 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC 0/6] perf tools: Add perf_evlist errno
Message-ID: <20131205092937.GB1265@krava.brq.redhat.com>
References: <1385725510-20118-1-git-send-email-jolsa@redhat.com>
 <87wqjnoebd.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wqjnoebd.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 02, 2013 at 05:19:18PM +0900, Namhyung Kim wrote:
> Hi Jiri,
> 
> On Fri, 29 Nov 2013 12:45:04 +0100, Jiri Olsa wrote:
> > hi,
> > Andi reported wrong error message for :S modifier
> > on kernel without event ID ioctl support.
> >
> > The reason was that the ioctl failed, but the error was
> > printed like the mmap would:
> >
> >     $ perf.old record -e '{cycles,cache-misses}:S' ls
> >     failed to mmap with 25 (Inappropriate ioctl for device)
> >     ls: Terminated
> 
> I see same confusing error message..
> 
> >
> > I experimentally added sort of 'libc errno' interface for
> > perf_evlist to be able to get proper error message, like:
> >
> >     $ perf record -e '{cycles,cache-misses}:S' ls
> >     Cannot read event group on this kernel.
> >     Please consider kernel update (v3.12+).
> >     ls: Terminated
> >
> > I'm not sure about this approach. Maybe it'd be better be more
> > global..? So before throwing this out, sending it as RFC ;-)
> 
> I like it. :)  We still need to improve this user-visible error handling.
> 
> But what you mean by 'more global'?  I think the evlist APIs are pretty
> global alreay.  And we have same error handling in perf_target code too.

aah, missed the target object has that already.. I meant
to keep the same way of error handling globaly

> 
> But I think it'd be better making it thread-safe even though it's not
> needed for now.  The code is growing really fast.. ;-)

ok, will repost 

thanks,
jirka

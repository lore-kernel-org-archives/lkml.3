Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087AbbATSNi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 13:13:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34147 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317AbbATSNg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 13:13:36 -0500
Date: Tue, 20 Jan 2015 19:13:16 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>
Subject: Re: perf: behavior of poll() changed in 3.18
Message-ID: <20150120181316.GA12860@krava.brq.redhat.com>
References: <alpine.DEB.2.11.1501201155380.18043@vincent-weaver-1.umelst.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1501201155380.18043@vincent-weaver-1.umelst.maine.edu>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 12:03:19PM -0500, Vince Weaver wrote:
> Hello
> 
> Some of my code that used poll() on a perf_event fd broke sometime between 
> 3.17 and current.  (My perf_event_test validation testsuite caught this
> too but I haven't been running it as regularly as I should).
> 
> I bisected this to:
> 
> 	commit 179033b3e064d2cd3f5f9945e76b0a0f0fbf4883
> 	Author: Jiri Olsa <jolsa@kernel.org>
> 	Date:   Thu Aug 7 11:48:26 2014 -0400
> 
> 	perf: Add PERF_EVENT_STATE_EXIT state for events with exited task
> 
> 
> Before, when polling, my code would get a
> 	result=0/WIFEXITED()
> return when a child with events being polled exited.
> 
> Now instead I get a 
> 	result=1/POLLHUP
> return.
> 
> Needless to say this broke my code.  Is there a reason this change was 
> made?

hi,
I made this change to get notification that monitored
process exited.  We use it in 'perf record' to find out
that we have nothing more to monitor and quit.

The logic is to return POLLHUP (via poll syscall) when
the monitored process exits for the event.

Could you please share your test code?

thanks,
jirka

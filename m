Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108AbaILNtQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 09:49:16 -0400
Received: from mail.kernel.org ([198.145.19.201]:46466 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753277AbaILNtP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 09:49:15 -0400
Date: Fri, 12 Sep 2014 10:49:10 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Pawel Moll <pawel.moll@arm.com>
Cc: Christopher Covington <cov@codeaurora.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>,
        John Stultz <john.stultz@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Subject: Re: [RFC 2/2] perf: Marker software event and ioctl
Message-ID: <20140912134910.GG1801@kernel.org>
References: <1410522513-1045-1-git-send-email-pawel.moll@arm.com>
 <1410522513-1045-3-git-send-email-pawel.moll@arm.com>
 <5412EA7A.9020807@codeaurora.org>
 <1410526672.16936.52.camel@hornet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410526672.16936.52.camel@hornet>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Sep 12, 2014 at 01:57:52PM +0100, Pawel Moll escreveu:
> On Fri, 2014-09-12 at 13:43 +0100, Christopher Covington wrote:
> > Just to ask the dumb questions in case the answers I've come up with are
> > wrong: What is PAGE_SIZE on an arm64 kernel? 
 
> It's either 4 or 64k, depending on CONFIG_ARM64_64K_PAGES.
 
> > How does userspace know?

> #include <unistd.h>
> #include <stdio.h>
 
> int main(void)
> {
> 	printf("%ld\n", sysconf(_SC_PAGESIZE));
> 	return 0;
> }
 
> Now a word of explanation. The PAGE_SIZE limitation was shamelessly
> stolen from perf_event_set_filter() (so PERF_EVENT_IOC_SET_FILTER) as an
> attempt to address a problem of passing a zero-terminated string from
> userspace. Simply speaking - there must be some limitation, and a page
> size seem as good as any other. I have strong doubts about this myself,
> so all alternative ideas are more than welcome.
 
> As I mentioned in the cover letter, maybe this simply shouldn't be a
> string? I made it like this to mimic trace_marker, but maybe an integer
> value + some kind of a dictionary in userspace is a better approach? I
> belive that ftrace's maker is taking a string, because it's: 1. natural
> for its interface and 2. anyone (sort of) can write to it, so it's hard
> to assume anything. In this case the user "owns" the perf data, so he
> could handle int<->whatever-else relation table...

Perhaps both? I.e. an u64 followed from a string, if the u64 is zero,
then there is a string right after it?

- Arnaldo

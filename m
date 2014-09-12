Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505AbaILM6B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 08:58:01 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:32880 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882AbaILM6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 08:58:00 -0400
Message-ID: <1410526672.16936.52.camel@hornet>
Subject: Re: [RFC 2/2] perf: Marker software event and ioctl
From: Pawel Moll <pawel.moll@arm.com>
To: Christopher Covington <cov@codeaurora.org>
Cc: Richard Cochran <richardcochran@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Date: Fri, 12 Sep 2014 13:57:52 +0100
In-Reply-To: <5412EA7A.9020807@codeaurora.org>
References: <1410522513-1045-1-git-send-email-pawel.moll@arm.com>
	 <1410522513-1045-3-git-send-email-pawel.moll@arm.com>
	 <5412EA7A.9020807@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-09-12 at 13:43 +0100, Christopher Covington wrote:
> Just to ask the dumb questions in case the answers I've come up with are
> wrong: What is PAGE_SIZE on an arm64 kernel? 

It's either 4 or 64k, depending on CONFIG_ARM64_64K_PAGES.

> How does userspace know?
> 
#include <unistd.h>
#include <stdio.h>

int main(void)
{
	printf("%ld\n", sysconf(_SC_PAGESIZE));
	return 0;
}

Now a word of explanation. The PAGE_SIZE limitation was shamelessly
stolen from perf_event_set_filter() (so PERF_EVENT_IOC_SET_FILTER) as an
attempt to address a problem of passing a zero-terminated string from
userspace. Simply speaking - there must be some limitation, and a page
size seem as good as any other. I have strong doubts about this myself,
so all alternative ideas are more than welcome.

As I mentioned in the cover letter, maybe this simply shouldn't be a
string? I made it like this to mimic trace_marker, but maybe an integer
value + some kind of a dictionary in userspace is a better approach? I
belive that ftrace's maker is taking a string, because it's: 1. natural
for its interface and 2. anyone (sort of) can write to it, so it's hard
to assume anything. In this case the user "owns" the perf data, so he
could handle int<->whatever-else relation table...

Pawel
> 


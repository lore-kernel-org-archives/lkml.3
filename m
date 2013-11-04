Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900Ab3KDPiI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 10:38:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4957 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791Ab3KDPiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 10:38:07 -0500
Date: Mon, 4 Nov 2013 16:32:16 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 3/3] perf tools: Check maximum frequency rate for
 record/top
Message-ID: <20131104153216.GC2805@krava.brq.redhat.com>
References: <1383563173-17466-1-git-send-email-jolsa@redhat.com>
 <1383563173-17466-4-git-send-email-jolsa@redhat.com>
 <5277BA84.1090208@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5277BA84.1090208@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 04, 2013 at 08:17:24AM -0700, David Ahern wrote:
> On 11/4/13, 4:06 AM, Jiri Olsa wrote:
> >Adding the check for maximum allowed frequency rate
> >defined in following file:
> >   /proc/sys/kernel/perf_event_max_sample_rate
> >
> >When we cross the maximum value we fail and display
> >detailed error message with advise.
> 
> perf commands should automatically adjust the default frequency too.
> If the user did not specify a frequency then this message is going
> to be confusing.

ok, I'll add that check and probably some warning
if we are force to go below the default rate.

> 
> Though the algorithm that keeps lowering the rate should be tweaked as well.

yea.. I was thinking putting the max rate back up after
some sane period

or/plus having 'echo 0 > /proc/sys/kernel/perf_event_max_sample_rate' to
disable it completely

jirka

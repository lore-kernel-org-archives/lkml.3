Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506Ab3IBIiG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 04:38:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12100 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757229Ab3IBIiC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 04:38:02 -0400
Date: Mon, 2 Sep 2013 10:37:37 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 24/25] perf tools: Add multi file '-M' option for record
 command
Message-ID: <20130902083737.GA1067@krava.brq.redhat.com>
References: <1378031796-17892-1-git-send-email-jolsa@redhat.com>
 <1378031796-17892-25-git-send-email-jolsa@redhat.com>
 <522443CE.5030703@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <522443CE.5030703@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 02, 2013 at 10:52:46AM +0300, Adrian Hunter wrote:
> On 01/09/13 13:36, Jiri Olsa wrote:
> > split event data into multiple files based on the file
> > size or time delta specified as an argument to the option.
> > 
> > Adding multi file '-M' option for record command to store
> > output perf.data into multiple files based on the size
> > threshold.
> > 
> > The threshold is specified either as size (B/K/M/G) or time
> > (s/m/h) by appending the size with appropriate unit, like:
> >   -M 5M for 5 megabytes threshold
> >   -M 1h for 1 hour threshold
> > The generated name for each data file is appended with sequential
> > number (prepended by 5 zeros).For default output file name it
> > will be:
> >   perf.data-00000
> >   perf.data-00001
> >   perf.data-00002
> >   ...
> > 
> > Also watermark/wakeup_watermark is set accordingly to get
> > wake ups more often so we could get close enough to the
> > file size promise.
> > 
> > Example:
> >   $ perf record -M 5M yes > /dev/null
> >   ^C[ perf record: Woken up 228 times to write data ]
> >   [ perf record: Captured and wrote 20.246 MB perf.data-[0-4](~884542 samples) ]
> >   yes: Interrupt
> >   $ ls -l perf.data-0*
> >   -rw------- 1 jolsa jolsa 5289856 Aug 16 16:07 perf.data-00000
> >   -rw------- 1 jolsa jolsa 5296008 Aug 16 16:08 perf.data-00001
> >   -rw------- 1 jolsa jolsa 5344968 Aug 16 16:09 perf.data-00002
> >   -rw------- 1 jolsa jolsa 5309144 Aug 16 16:09 perf.data-00003
> >   -rw------- 1 jolsa jolsa 2358268 Aug 16 16:09 perf.data-00004
> 
> Did you consider doing this with "perf inject" instead of "perf record"?
> That way you could get the split exactly right, and you could split the same
> file different ways.

right, this could be added into inject command as well

jirka

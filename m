Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786Ab3IILh3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 07:37:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30145 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934Ab3IILh2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 07:37:28 -0400
Date: Mon, 9 Sep 2013 13:36:41 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCHv2 00/25] perf tool: Add support for multiple data file
 storage
Message-ID: <20130909113640.GA16401@krava.redhat.com>
References: <1378031796-17892-1-git-send-email-jolsa@redhat.com>
 <20130909111749.GP31370@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130909111749.GP31370@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 01:17:49PM +0200, Peter Zijlstra wrote:
> On Sun, Sep 01, 2013 at 12:36:11PM +0200, Jiri Olsa wrote:
> > hi,
> > sending the support for multiple file storage. Initial
> > RFC is here:
> > http://marc.info/?l=linux-kernel&m=137408381902423&w=2
> > 
> > v2 changes:
> >   - reworked perf mmap size setup to be able to get
> >     the mmap size value easily later
> >   - added perf.data read/write test for v2 and v3
> >     for both endianity
> >   - added record '-M time' support
> 
> So this 0/n post seems to have forgotten to list the rationale for doing
> all this.. 

here it is:

This patchset is actually doing 3 essential things:
  1) adds new perf data format version (v3)
  2) adds class/object to handle perf data file
  3) adds record '-M size' option

ad 1) Along the way I realized it'd be much easier to have the
      format simplified. I ended up with just 'DATA' and 'FEATURES'
      sections making the file format more generic.

      The easier/generic format will be for example useful for the
      cpu hotplug notification (and maybe even for ftrace data files
      features?)

      The version 2 should be still readable by perf, while it
      produces data in version 3 from this patchset onwards.

ad 2) I needed to unify perf data file handling to make the -M
      implementation clear.

> 
> The only reason I wanted this is so that each thread can write its own
> data. The current one file thing is an immense bottle-neck for big
> machines.
> 

I haven't considered the thread based storage yet, but I
think having the simplified format and centralized file
handling will only help.

jirka

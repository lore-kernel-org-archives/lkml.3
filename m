Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757180AbaIKPxc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 11:53:32 -0400
Received: from mail.kernel.org ([198.145.19.201]:35399 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757164AbaIKPxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 11:53:31 -0400
Date: Thu, 11 Sep 2014 12:53:25 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Borislav Petkov <bp@suse.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] tools lib fd array: Do not set fd as non blocking evlist
Message-ID: <20140911155325.GL10158@kernel.org>
References: <1410358129-9965-1-git-send-email-acme@kernel.org>
 <1410358129-9965-12-git-send-email-acme@kernel.org>
 <20140911150943.GD32722@krava.brq.redhat.com>
 <20140911152726.GJ10158@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140911152726.GJ10158@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Sep 11, 2014 at 12:27:26PM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Thu, Sep 11, 2014 at 05:09:43PM +0200, Jiri Olsa escreveu:
> > > +	fcntl(fd, F_SETFL, O_NONBLOCK);
> > 
> > also I spot this one and couldn't think of reason for it, attached
> > patch makes no behaviour difference for me..
> 
> Have to look why it is there, perhaps there is some changeset
> specifically made for this, will do some research...
>  
> > I might be missing something, but I dont see any blocking operation
> > in perf related data reads. The git log history says it was there
> > since early days.
> 
> Oops, you did that research already, have you followed the history all
> the way to when this code lived in Documentation/ ?

Since day one, found using:

$ git log -p --follow tools/perf/builtin-top.c

commit e0143bad9dbf2a8fad4c5430562bceba196b66ea
Author: Ingo Molnar <mingo@elte.hu>
Date:   Mon Mar 23 21:29:59 2009 +0100

    perf_counter: add sample user-space to Documentation/perf_counter/
    
    Initial version of kerneltop.c and perfstat.c.
    
    Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Cc: Paul Mackerras <paulus@samba.org>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/Documentation/perf_counter/kerneltop.c b/Documentation/perf_counter/kerneltop.c


Ingo, do we really need that O_NONBLOCK thing there?

- Arnaldo

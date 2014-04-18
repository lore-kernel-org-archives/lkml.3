Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045AbaDRJfh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 05:35:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48639 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163AbaDRJfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 05:35:24 -0400
Date: Fri, 18 Apr 2014 11:35:07 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jean Pihet <jean.pihet@linaro.org>
Subject: Re: [PATCH 0/3] perf tools: Speedup DWARF unwind
Message-ID: <20140418093506.GA1914@krava.brq.redhat.com>
References: <1397756352-26694-1-git-send-email-jolsa@redhat.com>
 <20140418075148.GA13793@gmail.com>
 <20140418075525.GA14243@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140418075525.GA14243@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2014 at 09:55:25AM +0200, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@kernel.org> wrote:
> 
> > 
> > * Jiri Olsa <jolsa@redhat.com> wrote:
> > 
> > > hi,
> > > trying to speedup DWARF unwind report code by factoring
> > > related code:
> > >   - caching sample's registers access
> > >   - keep dso data file descriptor open for the
> > >     life of the dso object
> > >   - replace dso cache code by mapping dso data file
> > >     directly for the life of the dso object
> > > 
> > > The speedup is mainly for libunwind unwind. The libdw will benefit
> > > mainly from cached registers access, because it handles dso data
> > > accesses by itself.. and anyway it's still faster ;-).
> > 
> > Just curious: do you have any numbers about how much faster it got in 
> > practice?
> 
> Oh, the numbers are all in the changelogs, never mind!
> 
> So in your test workload it went from 54.6 seconds to 36.7, a 48% 
> speedup :-)
> 

yep, I should have put it in here as well.. also the current
libdw unwind time on this workload is 26 seconds.. 10 more
seconds to go ;-)

jirka

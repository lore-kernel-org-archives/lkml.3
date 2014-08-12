Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550AbaHLHdh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 03:33:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17040 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981AbaHLHdg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 03:33:36 -0400
Date: Tue, 12 Aug 2014 09:33:20 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC 00/20] perf: Finish sampling commands when events are closed
Message-ID: <20140812073319.GB1128@krava.brq.redhat.com>
References: <1407747014-18394-1-git-send-email-jolsa@kernel.org>
 <20140811201249.GA4148@kernel.org>
 <20140811202812.GB4148@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140811202812.GB4148@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 05:28:12PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Mon, Aug 11, 2014 at 05:12:49PM -0300, Arnaldo Carvalho de Melo escreveu:
> > Em Mon, Aug 11, 2014 at 10:49:54AM +0200, Jiri Olsa escreveu:
> > > hi,
> > > adding support to quit sampling commands:
> > >   record,top,trace,kvm stat live
> > > 
> > > when all the monitored events are closed, like following perf
> > > command will now exit when monitored process (pid 1234) exits:
> > > 
> > >   $ perf record -p 1234
> > > 
> > > I added independent poller object to handle basic polling
> > > tasks. I had to factor some parts, so sending this as RFC,
> > 
> > Why? I'm trying to figure out why this poller class is needed, just from
> > reading the changelog entries, no luck so far.
> 
> So this is all about accounting for when all events are closed? I.e. as
> we receive the ERR and HUP we go on closing the entries in the pollfd?
> Then, when none are closed, then we exit, is that the case?
> 
> Why not just mark them -1 and decrement evlist->nr_open_fds (new field)?
> 
> struct pollfds {
> 	struct pollfd *pollfds;
> 	int    nr_fds;
> 	int    nr_open_fds;
> };
> 
> Don't use callbacks and then that poller_item doesn't need to exist :-\

I think callbacks are convenient when having different kind
of events combined in polling, as described in my reply to
your first email

> 
> I'll try to cook a patch with those ideas later today, if for anything,
> to validate your patches :-)

ok ;-) thanks

jirka

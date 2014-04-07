Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892AbaDGSRA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 14:17:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57735 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755819AbaDGSQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 14:16:56 -0400
Date: Mon, 7 Apr 2014 14:16:18 -0400
From: Don Zickus <dzickus@redhat.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        jmario@redhat.com, fowles@inreach.com, peterz@infradead.org,
        eranian@google.com, andi.kleen@intel.com
Subject: Re: [PATCH 06/15 V3] perf, c2c: Add in new options to configure
 latency and stores
Message-ID: <20140407181618.GD5328@redhat.com>
References: <1395689826-215033-1-git-send-email-dzickus@redhat.com>
 <1395689826-215033-7-git-send-email-dzickus@redhat.com>
 <20140329171138.GF2022@krava.redhat.com>
 <20140401025535.GT25953@redhat.com>
 <20140406131422.GL1164@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140406131422.GL1164@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 06, 2014 at 03:14:22PM +0200, Jiri Olsa wrote:
> On Mon, Mar 31, 2014 at 10:55:35PM -0400, Don Zickus wrote:
> > On Sat, Mar 29, 2014 at 06:11:38PM +0100, Jiri Olsa wrote:
> > > On Mon, Mar 24, 2014 at 03:36:57PM -0400, Don Zickus wrote:
> > > > Modified the code to allow latency settings to be tweaked on the command line
> > > > and also the ability to dynamically profile stores (or disable using stores).
> > > > 
> > > > This allows the tool to be used on older Intel platforms like Westmere.
> > > > 
> > > > Signed-off-by: Don Zickus <dzickus@redhat.com>
> > > > ---
> > > 
> > > SNIP
> > > 
> > > > @@ -316,6 +369,12 @@ int cmd_c2c(int argc, const char **argv, const char *prefix __maybe_unused)
> > > >  	};
> > > >  	const struct option c2c_options[] = {
> > > >  	OPT_BOOLEAN('r', "raw_records", &c2c.raw_records, "dump raw events"),
> > > > +	OPT_INTEGER('l', "latency-level", &lat_level,
> > > > +		 "specify the latency threshold for loads [default=30]"),
> > > > +	OPT_INTEGER('p', "precision-level", &prec_level,
> > > > +		 "specify the precision level of events (0,1,2,3) [default=1]"),
> > > 
> > > could we get also option for user space modifier?
> > 
> > You mean the 'u' modifier, ie cpu/mem-loads/u ?  If so, then I can do that
> > but will that work with the -a option (which is hardcoded in the c2c
> > tool [system-wide mode])?
> 
> right, forgot about that.. could the -a option be optional as well?
> probably the same way as for record would be the best:
> 
>   perf c2c record ./foo       # workload specific
>   perf c2c record -a sleep 3  # system wide

I understand what you are saying, but our tool was written to find cache
contention across the system, so -a is usually implied.  Most of our
profiling is done system-wide.  I would rather implement the opposite
option --no-system-wide, if that is ok.

Cheers,
Don

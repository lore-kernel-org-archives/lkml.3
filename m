Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266AbaIAPvs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 11:51:48 -0400
Received: from mail.kernel.org ([198.145.19.201]:45489 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753739AbaIAPvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 11:51:47 -0400
Date: Mon, 1 Sep 2014 12:51:42 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 20/41] perf tools: Let a user specify a PMU event without
 any config terms
Message-ID: <20140901155142.GA2997@kernel.org>
References: <1405332185-4050-1-git-send-email-adrian.hunter@intel.com>
 <1405332185-4050-21-git-send-email-adrian.hunter@intel.com>
 <20140716142510.GE9441@krava.redhat.com>
 <53C6948C.2080103@intel.com>
 <20140716182214.GB32716@krava.redhat.com>
 <5400CB13.4040004@intel.com>
 <20140830085310.GA14358@krava.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140830085310.GA14358@krava.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, Aug 30, 2014 at 10:53:10AM +0200, Jiri Olsa escreveu:
> On Fri, Aug 29, 2014 at 09:48:51PM +0300, Adrian Hunter wrote:
> > On 16/07/2014 9:22 p.m., Jiri Olsa wrote:
> > >On Wed, Jul 16, 2014 at 06:04:44PM +0300, Adrian Hunter wrote:
> > >>On 16/07/2014 5:25 p.m., Jiri Olsa wrote:
> > >>>On Mon, Jul 14, 2014 at 01:02:44PM +0300, Adrian Hunter wrote:
> > >>>>This enables a PMU event to be specified in the form:

> > >>>>	pmu//

> > >>>>which is effectively the same as:

> > >>>>	pmu/config=0/

> > >>>>This patch is a precursor to defining
> > >>>>default config for a PMU.

> > >>>I understand the need for default config, but could you please elaborate
> > >>>why do we want to parse 'pmu//' as an event string string?

> > >>Currently the parser requires the slashes to identify a PMU event
> > >>as opposed to a hardware or other kind of event.

> > >right, so why do we want to parse 'pmu//' as an event string? ;-)

> > I am not sure what you mean.  Here I am using 'pmu' as a placeholder
> > for a real PMU name.  So actual event strings are 'intel_bts//' or
> > 'intel_pt//' or 'intel_pt/tsc=0,noretcomp=1/'

> so the consequence of default arguments is that you can
> specify event just by the pmu name, like:
>   -e intel_pt//

> which means (with default attributes):
>   -e intel_pt/tsc=1,noretcomp=0/
 
> I guess I wanted to hear more elaboration why is this better
> than the current way we have by defining an alias, like:
 
>   krava alias: "tsc=1,noretcomp=0"
 
>   -e intel_pt/krava/
 
> which gives the same result

So you propose that we start maintaining some table of aliases that
would be installed by default, etc? "krava" would not be a good name, I
think (:-)), so in this case we would have something like:

	defaults_intel_pt: "tsc=1,noretcomp=0"

	-e intel_pt/defaults_intel_pt/

Which of course gets redundant/long, so, using what Adrian suggests, we
would instead not pass anything between the slashes, and that would mean
"default_" concatenated with the name of the PMU used, so it would
become:

	-e intel_pt//

that would be equivalent to:

	-e intel_pt/defaults_intel_pt/

and also to:

	-e intel_pt/tsc=1,noretcomp=0/

?

I have not looked at the implementation, this is all just from the
information I skimmed in this thread.

- Arnaldo

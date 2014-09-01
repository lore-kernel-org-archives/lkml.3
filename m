Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743AbaIATQL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 15:16:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18327 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752705AbaIATQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 15:16:09 -0400
Date: Mon, 1 Sep 2014 21:15:35 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 20/41] perf tools: Let a user specify a PMU event without
 any config terms
Message-ID: <20140901191535.GF1900@krava.redhat.com>
References: <1405332185-4050-1-git-send-email-adrian.hunter@intel.com>
 <1405332185-4050-21-git-send-email-adrian.hunter@intel.com>
 <20140716142510.GE9441@krava.redhat.com>
 <53C6948C.2080103@intel.com>
 <20140716182214.GB32716@krava.redhat.com>
 <5400CB13.4040004@intel.com>
 <20140830085310.GA14358@krava.redhat.com>
 <20140901155142.GA2997@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140901155142.GA2997@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2014 at 12:51:42PM -0300, Arnaldo Carvalho de Melo wrote:

SNIP

> >   krava alias: "tsc=1,noretcomp=0"
>  
> >   -e intel_pt/krava/
>  
> > which gives the same result
> 
> So you propose that we start maintaining some table of aliases that
> would be installed by default, etc? "krava" would not be a good name, I
> think (:-)), so in this case we would have something like:
> 
> 	defaults_intel_pt: "tsc=1,noretcomp=0"
> 
> 	-e intel_pt/defaults_intel_pt/
> 
> Which of course gets redundant/long, so, using what Adrian suggests, we
> would instead not pass anything between the slashes, and that would mean
> "default_" concatenated with the name of the PMU used, so it would
> become:
> 
> 	-e intel_pt//
> 
> that would be equivalent to:
> 
> 	-e intel_pt/defaults_intel_pt/
> 
> and also to:
> 
> 	-e intel_pt/tsc=1,noretcomp=0/
> 
> ?
> 
> I have not looked at the implementation, this is all just from the
> information I skimmed in this thread.

well I meant that we already have following directory:
  /sys/devices/cpu/events

for aliases.. files with format definitions (even partial)
I can imagine 'default' file there doing the same job
for the default format set

but I just could be missing something which is not apparent
from changelog ;-)

jirka

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619AbbAHOqm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 09:46:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44368 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754100AbbAHOqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 09:46:39 -0500
Date: Thu, 8 Jan 2015 15:45:54 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Alexis Berlemont <alexis.berlemont@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 07/30] perf build: Add libperf objects building
Message-ID: <20150108144554.GF16094@krava.brq.redhat.com>
References: <1420212972-21595-1-git-send-email-jolsa@kernel.org>
 <1420212972-21595-8-git-send-email-jolsa@kernel.org>
 <20150108061509.GC7268@sejong>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150108061509.GC7268@sejong>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2015 at 03:15:09PM +0900, Namhyung Kim wrote:
> On Fri, Jan 02, 2015 at 04:35:49PM +0100, Jiri Olsa wrote:
> > Move the util objects building under build framework.
> > 
> > Add new libperf build object so it's separated from
> > the rest of the perf code and could be librarized.
> >
> 
> 
> [SNIP]
> > +$(OUTPUT)util/parse-events-flex.c: util/parse-events.l $(OUTPUT)util/parse-events-bison.c
> > +	@$(call echo-cmd,bison)$(FLEX) -o $@ --header-file=$(OUTPUT)util/parse-events-flex.h $(PARSER_DEBUG_FLEX) util/parse-events.l
>                          ^^^^^
> s/bison/flex/ ?

yes

> 
> 
> > +
> > +$(OUTPUT)util/parse-events-bison.c: util/parse-events.y
> > +	@$(call echo-cmd,bison)$(BISON) -v util/parse-events.y -d $(PARSER_DEBUG_BISON) -o $(OUTPUT)util/parse-events-bison.c -p parse_events_
> 
> I guess we can simply use "-o $@" here.

yes

> 
> 
> > +
> > +$(OUTPUT)util/pmu-flex.c: util/pmu.l $(OUTPUT)util/pmu-bison.c
> > +	@$(call echo-cmd,flex)$(FLEX) -o $@ --header-file=$(OUTPUT)util/pmu-flex.h util/pmu.l
> > +
> > +$(OUTPUT)util/pmu-bison.c: util/pmu.y
> > +	@$(call echo-cmd,bison)$(BISON) -v util/pmu.y -d -o $(OUTPUT)util/pmu-bison.c -p perf_pmu_
> 
> Ditto.

and yes ;-)

thanks,
jirka

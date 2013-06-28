Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969Ab3F1ODM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 10:03:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53577 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754505Ab3F1ODK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 10:03:10 -0400
Date: Fri, 28 Jun 2013 15:57:36 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH V2 06/15] perf tools: fix parse_events_terms() freeing
 local variable on error path
Message-ID: <20130628135736.GA29993@krava.brq.redhat.com>
References: <1372319707-13892-1-git-send-email-adrian.hunter@intel.com>
 <1372319707-13892-7-git-send-email-adrian.hunter@intel.com>
 <51CC64A7.6040305@gmail.com>
 <51CD2DFE.6070704@intel.com>
 <51CD92A3.5000202@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51CD92A3.5000202@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28, 2013 at 07:41:55AM -0600, David Ahern wrote:
> On 6/28/13 12:32 AM, Adrian Hunter wrote:
> 
> >>Seems like you can just fix parse_events__free_terms to do the right thing
> >>and not call free(terms) -- ie., no need for a separate "only" function.
> >> From there only test_term() needs to do the free(terms) and since it mallocs
> >>the memory there it is nicely symmetrical.
> >
> >There are 2 more calls to parse_events__free_terms in util/parse-events.y
> >
> 
> Right and both look like stack case uses. I don't see the need for
> __free_terms to free the list so no need for an _only version.

there's also another one in pmu_alias_terms function
which uses on stack list_head

jirka

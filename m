Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755646AbaBRN5z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 08:57:55 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:48528 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755276AbaBRNtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 08:49:53 -0500
Date: Tue, 18 Feb 2014 10:49:44 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Don Zickus <dzickus@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        jmario@redhat.com, fowles@inreach.com, eranian@google.com,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Richard Fowles <rfowles@redhat.com>
Subject: Re: [PATCH 02/21] perf c2c: Dump raw records, decode data_src bits
Message-ID: <20140218134944.GB2350@infradead.org>
References: <1392053356-23024-1-git-send-email-dzickus@redhat.com>
 <1392053356-23024-3-git-send-email-dzickus@redhat.com>
 <20140218125335.GF4343@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140218125335.GF4343@krava.brq.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Feb 18, 2014 at 01:53:35PM +0100, Jiri Olsa escreveu:
> On Mon, Feb 10, 2014 at 12:28:57PM -0500, Don Zickus wrote:
> > From: Arnaldo Carvalho de Melo <acme@redhat.com>
<SNIP>
> > +static int perf_c2c__process_load_store(struct perf_c2c *c2c,
> > +					struct perf_sample *sample,
> > +					struct addr_location *al)
> > +{
> > +	if (c2c->raw_records)
> > +		perf_sample__fprintf(sample, ' ', "raw input", al, stdout);
> > +
> >  	return 0;
> >  }

> >  static const struct perf_evsel_str_handler handlers[] = {
> > -	{ "cpu/mem-loads,ldlat=30/pp", perf_c2c__process_load, },
> > -	{ "cpu/mem-stores/pp",	       perf_c2c__process_store, },
> > +	{ "cpu/mem-loads,ldlat=30/pp", perf_c2c__process_load_store, },
> > +	{ "cpu/mem-stores/pp",	       perf_c2c__process_load_store, },
 
> hm.. so it's only one function for both handlers.. no need
> to use handlers at all then, right?

This was just an skeleton from where to continue, so no, the idea isn't
to have just one function for both.

- Arnaldo

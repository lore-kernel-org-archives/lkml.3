Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbbAQMih (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 07:38:37 -0500
Received: from mail.kernel.org ([198.145.29.136]:43821 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751909AbbAQMif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 07:38:35 -0500
Date: Sat, 17 Jan 2015 09:38:34 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [PATCH v2 1/4] perf tools: Fix segfault for symbol annotation on
 TUI
Message-ID: <20150117123834.GD18698@kernel.org>
References: <1421234288-22758-1-git-send-email-namhyung@kernel.org>
 <54B683ED.2060105@gmail.com>
 <20150114210852.GD3691@kernel.org>
 <20150115002021.GA2096@sejong>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150115002021.GA2096@sejong>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jan 15, 2015 at 09:20:21AM +0900, Namhyung Kim escreveu:
> On Wed, Jan 14, 2015 at 06:08:52PM -0300, Arnaldo Carvalho de Melo wrote:
> > Em Wed, Jan 14, 2015 at 07:57:49AM -0700, David Ahern escreveu:
> > > On 1/14/15 4:18 AM, Namhyung Kim wrote:
> > > >  static inline struct annotation *symbol__annotation(struct symbol *sym)
> > > >  {
> > > >-	struct sannotation *a = container_of(sym, struct sannotation, symbol);
> > > >-	return &a->annotation;
> > > >+	return (void *)sym - symbol_conf.priv_size;
 
> > > symbol__priv(sym);

> > Amended, thanks.
 
> Oh, I missed that.  Thanks to both of you!

I thought I had, probably did, but in just one of my devel machines,
ended up going as Namhyung did, no biggie, I'll fix it up later, on the
next perf/core devel cycle.

- Arnaldo

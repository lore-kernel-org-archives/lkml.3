Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838AbaGNOvz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 10:51:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27606 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755622AbaGNOvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 10:51:48 -0400
Date: Mon, 14 Jul 2014 16:51:30 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 4/4] perf tools: Add --debug optionto set debug variable
Message-ID: <20140714145130.GG17761@krava.redhat.com>
References: <1405202188-5029-1-git-send-email-jolsa@kernel.org>
 <1405202188-5029-5-git-send-email-jolsa@kernel.org>
 <87egxo2xat.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87egxo2xat.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 04:51:06PM +0900, Namhyung Kim wrote:
> Hi Jiri,
> 
> On Sat, 12 Jul 2014 23:56:28 +0200, Jiri Olsa wrote:
> > Adding --debug option as a way to setup debug variables.
> > Starting with support for verbose, more will come.
> >
> > It's possible to use it now with report command:
> >   $ perf report --debug verbose
> >   $ perf report --debug verbose=2
> >
> > I'll need this support to add separated debug variable
> > for ordered events change in order to separate debug
> > output out of standard verbose stream.
> 
> Hmm.. okay.  I think there'll be more users for this.
> 
> 
> >
> > Also removing unneeded getopt.h includes.
> 
> I guess Arnaldo wants to see it as a separate change ;-)

maybe ;-) I hit an issue with this by adding #include "parse-options.h"
into debug.h ... we have a some name clashes with getopt.h

> 
> 
> > +static struct variables_t {
> > +	const char *name;
> > +	int *ptr;
> > +} variables[] = {
> 
> This is a too general name.  How about debug_variable or debug_domain?

debug_variable sounds good to me, will change

thanks,
jirka

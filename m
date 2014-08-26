Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994AbaHZNIb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 09:08:31 -0400
Received: from mail.kernel.org ([198.145.19.201]:46557 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754387AbaHZNIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 09:08:30 -0400
Date: Tue, 26 Aug 2014 10:08:20 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>, Borislav Petkov <bp@suse.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Jiri Olsa <jolsa@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 10/10] tools lib api: Adopt fdarray class from perf's
 evlist
Message-ID: <20140826130820.GA3330@kernel.org>
References: <1408741190-5123-1-git-send-email-acme@kernel.org>
 <1408741190-5123-11-git-send-email-acme@kernel.org>
 <87k35vbsmt.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k35vbsmt.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Aug 26, 2014 at 04:46:18PM +0900, Namhyung Kim escreveu:
> Hi Arnaldo,
> 
> On Fri, 22 Aug 2014 17:59:50 -0300, Arnaldo Carvalho de Melo wrote:
> > +int fdarray__add(struct fdarray *fda, int fd)
> > +{
> > +	/*
> > +	 * XXX: 64 is arbitrary, just not to call realloc at each fd.
> > +	 *	Find a better autogrowing heuristic
> > +	 */
> > +	if (fda->nr == fda->nr_alloc &&
> > +	    fdarray__grow(fda, 64) < 0)
> > +		return -ENOMEM;
> > +
> > +	fcntl(fd, F_SETFL, O_NONBLOCK);
> > +	fda->entries[fda->nr].fd = fd;
> > +	fda->entries[fda->nr].events = POLLIN | POLLERR | POLLHUP;
> > +	fda->nr++;
> > +	return 0;
> > +}
> 
> To be more generic api, I think it'd be better receiving events from
> user rather than hard-coding.  Also it might be useful to let user

Agreed, will do.

> sets a grow hint (during init?) as well.

Sure, that can be done as well, and with that, ditch that hard coded
value.

Thanks,

- Arnaldo

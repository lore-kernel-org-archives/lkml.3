Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176AbaILOQx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 10:16:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45586 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754498AbaILOQw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 10:16:52 -0400
Date: Fri, 12 Sep 2014 16:16:32 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Borislav Petkov <bp@suse.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 11/14] tools lib api: Adopt fdarray class from perf's
 evlist
Message-ID: <20140912141631.GA22187@krava.brq.redhat.com>
References: <1410358129-9965-1-git-send-email-acme@kernel.org>
 <1410358129-9965-12-git-send-email-acme@kernel.org>
 <20140912125822.GA23205@krava.brq.redhat.com>
 <20140912134429.GF1801@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140912134429.GF1801@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 10:44:29AM -0300, Arnaldo Carvalho de Melo wrote:
> Em Fri, Sep 12, 2014 at 02:58:22PM +0200, Jiri Olsa escreveu:
> > On Wed, Sep 10, 2014 at 11:08:46AM -0300, Arnaldo Carvalho de Melo wrote:
>  
> > SNIP
>  
> > > +struct fdarray *fdarray__new(int nr_alloc, int nr_autogrow)
> > > +{
> > > +	struct fdarray *fda = calloc(1, sizeof(*fda));
> 
> > > +	if (fda != NULL) {
> > > +		if (fdarray__grow(fda, nr_alloc)) {
> > > +			free(fda);
> > > +			fda = NULL;
> > 
> > you could use zfree
> 
> Yeah, we could, if zfree had moved from tools/perf/util/ to tools/lib/,
> which is has not yet.
> 
> I thought about doing it now, but when doing some grepping in the kernel
> sources I realized that zfree is already taken by... zlib, so I'll leave
> this for later, when we figure out how to properly export this, perhaps
> renaming it to freez()?

aargh.. haven't realized it's not in libs ;-) freez sounds ok

jirka

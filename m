Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760336AbaGYOOT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 10:14:19 -0400
Received: from mail.kernel.org ([198.145.19.201]:58794 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751877AbaGYOOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 10:14:18 -0400
Date: Fri, 25 Jul 2014 11:14:13 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 17/19] perf tools: Always force
 PERF_RECORD_FINISHED_ROUND event
Message-ID: <20140725141413.GK7831@kernel.org>
References: <1405893363-21967-1-git-send-email-jolsa@kernel.org>
 <1405893363-21967-18-git-send-email-jolsa@kernel.org>
 <20140724213451.GH7831@kernel.org>
 <20140725113426.GC1214@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140725113426.GC1214@krava.brq.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jul 25, 2014 at 01:34:26PM +0200, Jiri Olsa escreveu:
> On Thu, Jul 24, 2014 at 06:34:51PM -0300, Arnaldo Carvalho de Melo wrote:
> > I think both changes are OK, but should be split in different patches,
 
> right, I'll split it

Thanks!
 
> > [root@zoo /]# perf stat -r 5 perf report --no-ordered-samples > /dev/null
> >    101,171,572,553      instructions              #    1.10  insns per cycle        
> >       30.249514999 seconds time elapsed                                          ( +-  0.48% )

> > [root@zoo /]# perf stat -r 5 perf report --ordered-samples > /dev/null
> >    105,982,144,263      instructions              #    1.04  insns per cycle        
> >       32.636483981 seconds time elapsed                                          ( +-  0.41% )

> so those 2 extra seconds is the ordering time, right? sounds ok

Yeah, but I think its worth investigating if using it is a strict
requirement in all cases, i.e. is it possible to receive out of order
events when sampling on a single CPU? Or a single CPU socket with a
coherent time source? etc.

Providing a way to disable this ordering to be used in corner cases
where it is not a strict requirement and the volume of samples is so
high that reducing processing time like shown above seems to be a
sensible thing to do.

We're in the business of optimizing stuff, huh? :-)
 
- Arnaldo

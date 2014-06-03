Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460AbaFCNmA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 09:42:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39509 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751796AbaFCNl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 09:41:59 -0400
Date: Tue, 3 Jun 2014 15:41:45 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 06/13] perf tools: Cache dso data file descriptor
Message-ID: <20140603134145.GD2864@krava.brq.redhat.com>
References: <1401743927-398-1-git-send-email-jolsa@kernel.org>
 <1401743927-398-7-git-send-email-jolsa@kernel.org>
 <538DCF59.6000808@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538DCF59.6000808@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 07:36:25AM -0600, David Ahern wrote:
> On 6/2/14, 3:18 PM, Jiri Olsa wrote:
> >We keep dsos data file descriptors open until their count reaches
> >the half of the current fd open limit (RLIMIT_NOFILE). In this case
> >we close file descriptor of the first opened dso object.
> >
> >We've got overall speedup (24% for my workload) of report:
> >  'perf report --stdio -i perf-test.data' (3 runs)
> >   (perf-test.data size was around 12GB)
> >
> >   current code:
> >    446,826,474,217      cycles                     ( +-  0.23% )
> >    669,435,100,846      instructions               ( +-  0.03% )
> >
> >      266.380674551 seconds time elapsed            ( +-  0.37% )
> >
> >   change:
> >    558,345,509,819      cycles                     ( +-  0.55% )
> >    817,283,647,637      instructions               ( +-  0.03% )
> >
> >      351.564209617 seconds time elapsed            ( +-  0.89% )
> 
> message is confusing. Looks like time went up.

aaargh.. right ;-) it should bethe other way around

thanks,
jirka

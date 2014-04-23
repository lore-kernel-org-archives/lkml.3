Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892AbaDWQb4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 12:31:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51294 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752956AbaDWQbz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 12:31:55 -0400
Date: Wed, 23 Apr 2014 18:31:18 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 3/5] perf tools: Reference count map_groups objects
Message-ID: <20140423163117.GA5048@krava.brq.redhat.com>
References: <1397490723-1992-1-git-send-email-jolsa@redhat.com>
 <1397490723-1992-4-git-send-email-jolsa@redhat.com>
 <534C193A.2000806@gmail.com>
 <20140415095657.GC1700@krava.brq.redhat.com>
 <534D77B2.1070404@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <534D77B2.1070404@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 12:17:22PM -0600, David Ahern wrote:
> On 4/15/14, 3:56 AM, Jiri Olsa wrote:
> >
> >hum.. I think using atomic type is not enough, we'd need
> >to make map_groups__put/get atomic as well
> >
> >not sure what's the support in user space for that.. will check
> >
> >also not to be negative, but libperf is not thread safe anyway, right? ;-)
> 
> should be. pretty certain there have been bug reports (e.g,
> perf-top) that stumble onto problems and they get fixed.

I checked and there's no problem with this in perf top, because
all thread allocations and frees (included map_groups) are done
within the main (one) thread

You could get in trouble if you'd call map_groups__get and
map_groups__put over same map_groups object from different
threads, but this never happens in perf

Thats the same sort of issue you would get if you called
machine__findnew_thread over same machine from 2 threads

I think that potential libperf users should be aware of the
proper usage or they should ask for change

thoughts? ;-) thanks,
jirka

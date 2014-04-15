Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107AbaDOJ5h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 05:57:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23017 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750938AbaDOJ5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 05:57:35 -0400
Date: Tue, 15 Apr 2014 11:56:58 +0200
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
Message-ID: <20140415095657.GC1700@krava.brq.redhat.com>
References: <1397490723-1992-1-git-send-email-jolsa@redhat.com>
 <1397490723-1992-4-git-send-email-jolsa@redhat.com>
 <534C193A.2000806@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <534C193A.2000806@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 11:22:02AM -0600, David Ahern wrote:
> On 4/14/14, 9:52 AM, Jiri Olsa wrote:

SNIP

> >
> >+void map_groups__put(struct map_groups *mg)
> >+{
> >+	if (--mg->refcnt == 0)
> >+		map_groups__delete(mg);
> >+}
> >+
> >  void map_groups__flush(struct map_groups *mg)
> >  {
> >  	int type;
> >diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
> >index 1073e2d..d6445b2 100644
> >--- a/tools/perf/util/map.h
> >+++ b/tools/perf/util/map.h
> >@@ -59,11 +59,20 @@ struct map_groups {
> >  	struct rb_root	 maps[MAP__NR_TYPES];
> >  	struct list_head removed_maps[MAP__NR_TYPES];
> >  	struct machine	 *machine;
> >+	int		 refcnt;
> >  };
> 
> 
> atomic for refcnt? This is part of a libperf; would be good to
> support multithreaded users.

hum.. I think using atomic type is not enough, we'd need
to make map_groups__put/get atomic as well

not sure what's the support in user space for that.. will check

also not to be negative, but libperf is not thread safe anyway, right? ;-)

thanks,
jirka

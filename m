Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447AbaGWNJz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 09:09:55 -0400
Received: from mail.kernel.org ([198.145.19.201]:41592 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347AbaGWNJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 09:09:54 -0400
Date: Wed, 23 Jul 2014 10:09:49 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 52/52] perf tools: Add support for 32-bit compatibility
 VDSOs
Message-ID: <20140723130949.GH20303@kernel.org>
References: <1406035081-14301-1-git-send-email-adrian.hunter@intel.com>
 <1406035081-14301-53-git-send-email-adrian.hunter@intel.com>
 <20140723130525.GA17252@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140723130525.GA17252@krava.brq.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jul 23, 2014 at 03:05:25PM +0200, Jiri Olsa escreveu:
> On Tue, Jul 22, 2014 at 04:18:01PM +0300, Adrian Hunter wrote:
> > 'perf record' post-processes the event stream  to create
> > a list of build-ids for object files for which sample
> > events have been recorded.  That results in those object
> > files being recorded in the build-id cache.
> > 
> > In the case of VDSO, perf tools reads it from memory
> > and copies it into a temporary file, which as decribed
> > above, gets added to the build-id cache.
> > 
> > Then when the perf.data file is processed by other
> > tools, the build-id of VDSO is listed in the perf.data
> > file and the VDSO can be read from the build-id cache.
> > In that case the name of the map, the short name of the
> > DSO, and the entry in the build-id cache are all
> > "[vdso]".
> > 
> 
> heya,
> I reviewed vdso changes:
> 
> perf tools: Pass machine to vdso__dso_findnew()
> perf tools: Group VDSO global variables into a structure
> perf tools: Fix the lifetime of the VDSO temporary file
> perf tools: Add vdso__new()
> perf tools: Separate the VDSO map name from the VDSO dso name
> perf tools: Build programs to copy 32-bit compatibility VDSOs
> perf tools: Add dso__type()
> perf tools: Add thread parameter to vdso__dso_findnew()
> perf tools: Add support for 32-bit compatibility VDSOs
> 
> apart from small comments for above patches:
> 
> Acked-by: Jiri Olsa <jolsa@redhat.com>
> 
> Arnaldo,
> I can handle those if needed, please let me know

I can take those after I go thru them, will add your acked-by. But since
you sayd "I reviewed", wouldn't it be better to s/Acked-by/Reviewed-by/g
?

- Arnaldo

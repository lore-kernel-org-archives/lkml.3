Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897Ab3HZNxO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 09:53:14 -0400
Received: from mail-yh0-f51.google.com ([209.85.213.51]:47415 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895Ab3HZNxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 09:53:13 -0400
Date: Mon, 26 Aug 2013 10:53:05 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 1/3] perf: add a dummy software event to keep tracking
Message-ID: <20130826135305.GA1885@ghostprotocols.net>
References: <1375882231-18339-1-git-send-email-adrian.hunter@intel.com>
 <1375882231-18339-2-git-send-email-adrian.hunter@intel.com>
 <521B54F6.5060304@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <521B54F6.5060304@intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Aug 26, 2013 at 04:15:34PM +0300, Adrian Hunter escreveu:
> On 07/08/13 16:30, Adrian Hunter wrote:
> > When an event is disabled the "tracking" events
> > selected by the 'mmap', 'comm' and 'task' bits of
> > struct perf_event_attr, are also disabled.  However,
> > the information those events provide is necessary to
> > resolve symbols for when the main event is re-enabled.
> > 
> > The "tracking" events can be kept enabled by putting
> > them on another event, but that requires an event
> > that otherwise does nothing.  A new software event
> > PERF_COUNT_SW_DUMMY is added for that purpose.
> > 
> > Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> 
> Any comments?

Ok with me, Peter?

- Arnaldo
 
> > ---
> >  include/uapi/linux/perf_event.h | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
> > index 62c25a2..9e28422 100644
> > --- a/include/uapi/linux/perf_event.h
> > +++ b/include/uapi/linux/perf_event.h
> > @@ -109,6 +109,7 @@ enum perf_sw_ids {
> >  	PERF_COUNT_SW_PAGE_FAULTS_MAJ		= 6,
> >  	PERF_COUNT_SW_ALIGNMENT_FAULTS		= 7,
> >  	PERF_COUNT_SW_EMULATION_FAULTS		= 8,
> > +	PERF_COUNT_SW_DUMMY			= 9,
> >  
> >  	PERF_COUNT_SW_MAX,			/* non-ABI */
> >  };
> > 

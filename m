Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244Ab3KWJ1f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 04:27:35 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:10718 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750719Ab3KWJ1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 04:27:32 -0500
Date: Sat, 23 Nov 2013 04:27:30 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 13/22] tools lib traceevent: Add cfg80211 plugin
Message-ID: <20131123042730.024c4049@gandalf.local.home>
In-Reply-To: <1385133374.1747.83.camel@leonhard>
References: <1385031680-9014-1-git-send-email-jolsa@redhat.com>
	<1385031680-9014-14-git-send-email-jolsa@redhat.com>
	<1385133374.1747.83.camel@leonhard>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Nov 2013 00:16:14 +0900
Namhyung Kim <namhyung@kernel.org> wrote:

 
> [SNIP]
> > +unsigned long long process___le16_to_cpup(struct trace_seq *s,
> > +					  unsigned long long *args)
> > +{
> > +	uint16_t *val = (uint16_t *) args[0];
> > +	return val ? (long long) le16toh(*val) : 0;
> > +}
> > +
> > +int PEVENT_PLUGIN_LOADER(struct pevent *pevent)
> > +{
> > +	pevent_register_print_function(pevent,
> > +				       process___le16_to_cpup,
> > +				       PEVENT_FUNC_ARG_INT,
> 
> Just a nitpick.  The function should return int or the return type
> should be _LONG for consistency.

As stated in another reply, the return type is not for the callback, but
instead for the function it is representing.

-- Steve

> 
> Thanks,
> Namhyung
> 
> > +				       "__le16_to_cpup",
> > +				       PEVENT_FUNC_ARG_PTR,
> > +				       PEVENT_FUNC_ARG_VOID);
> > +	return 0;
> > +}
> 
> 


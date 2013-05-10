Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987Ab3EJJOU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 05:14:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54502 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536Ab3EJJOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 05:14:18 -0400
Date: Fri, 10 May 2013 11:12:19 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 5/9] perf tools: Set maximum precise value for event 'p'
 modifier
Message-ID: <20130510091219.GD1040@krava.brq.redhat.com>
References: <1368106344-23383-1-git-send-email-jolsa@redhat.com>
 <1368106344-23383-6-git-send-email-jolsa@redhat.com>
 <518BFC78.2000308@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <518BFC78.2000308@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 09, 2013 at 01:43:52PM -0600, David Ahern wrote:
> On 5/9/13 7:32 AM, Jiri Olsa wrote:
> >+static int precise_default(void)
> >+{
> >+	int precise = perf_precise__get();
> >+	static int warned;
> >+
> >+	/*
> >+	 * Precise info not supported by by this kernel,
> >+	 * set 1 as the precise value.
> >+	 */
> >+	if (precise == -1)
> >+		precise = 1;
> >+
> >+	/* PEBS is not supported here, display warning. */
> >+	if (precise == 0 && !warned++)
> >+		pr_warning("warning: no precise support, "
> >+			   "using non-precise event(s)\n");
> 
> WARN_ONCE().

ah, forgot we have this one ;) thanks

jirka

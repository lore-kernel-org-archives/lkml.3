Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335AbaF2Ql6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 12:41:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59980 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753204AbaF2Ql5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 12:41:57 -0400
Date: Sun, 29 Jun 2014 18:41:42 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 08/18] perf tools: Flush ordered events in case of
 allocation failure
Message-ID: <20140629164142.GB1407@krava.redhat.com>
References: <1403103539-16807-1-git-send-email-jolsa@kernel.org>
 <1403103539-16807-9-git-send-email-jolsa@kernel.org>
 <53ADF948.2070300@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53ADF948.2070300@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 05:07:52PM -0600, David Ahern wrote:
> On 6/18/14, 8:58 AM, Jiri Olsa wrote:
> >+	case OEQ_FLUSH__HALF:
> >+	{
> >+		struct ordered_event *first, *last;
> >+		struct list_head *head = &q->events;
> >+
> >+		first = list_entry(head->next, struct ordered_event, list);
> >+		last = q->last;
> >+
> >+		if (WARN_ONCE(!last || list_empty(head), "empty queue"))
> >+			return 0;
> 
> Maybe a comment that the WARN_ONCE can only happen if perf can't allocate an
> ordered event the first time through?

ok, will do..

thanks,
jirka

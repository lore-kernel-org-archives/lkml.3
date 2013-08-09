Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030699Ab3HIOtY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 10:49:24 -0400
Received: from smtpauth12.mfg.siteprotect.com ([64.26.60.150]:45175 "EHLO
	smtpauth02.mfg.siteprotect.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030310Ab3HIOtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 10:49:23 -0400
Date: Fri, 9 Aug 2013 10:50:27 -0400 (EDT)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Arnaldo Carvalho de Melo <acme@infradead.org>
cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 01/47] perf: Add PERF_EVENT_IOC_ID ioctl to return event
 ID
In-Reply-To: <1375909874-22073-2-git-send-email-acme@infradead.org>
Message-ID: <alpine.DEB.2.02.1308091046040.17774@pianoman.cluster.toy>
References: <1375909874-22073-1-git-send-email-acme@infradead.org> <1375909874-22073-2-git-send-email-acme@infradead.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020206.52050172.0197,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Aug 2013, Arnaldo Carvalho de Melo wrote:

> From: Jiri Olsa <jolsa@redhat.com>
> 
> The only way to get the event ID is by reading the event fd,
> followed by parsing the ID value out of the returned data.
> 
> While this is ok for current read format used by perf tool,
> it is not ok when we use PERF_FORMAT_GROUP format.
> 
> With this format the data are returned for the whole group
> and there's no way to find out what ID belongs to our fd
> (if we are not group leader event).

I'm a little confused by this.

If you have an event group (with PERF_FORMAT_GROUP) and you specify
PERF_FORMAT_ID in read_format, then when you read you get the id
values for each sibling event along with their values, right?

This is how PAPI does things.  So I wouldn't say it's impossible to get 
the event IDs with PERF_FORMAT_GROUP events.

Though maybe you're saying it's hard to map sibling fds to id values if 
you don't have the list of all fds in an event group in the order they 
were added.  Which I guess may be true, but I'd think your analysis tool 
would have other problems if you didn't have that mapping.

Vince

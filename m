Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758529Ab3HJMMD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 08:12:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2291 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758248Ab3HJMMA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 08:12:00 -0400
Date: Sat, 10 Aug 2013 14:11:17 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Vince Weaver <vince@deater.net>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 01/47] perf: Add PERF_EVENT_IOC_ID ioctl to return event
 ID
Message-ID: <20130810121117.GA1056@krava.brq.redhat.com>
References: <1375909874-22073-1-git-send-email-acme@infradead.org>
 <1375909874-22073-2-git-send-email-acme@infradead.org>
 <alpine.DEB.2.02.1308091046040.17774@pianoman.cluster.toy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1308091046040.17774@pianoman.cluster.toy>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 09, 2013 at 10:50:27AM -0400, Vince Weaver wrote:
> On Wed, 7 Aug 2013, Arnaldo Carvalho de Melo wrote:
> 
> > From: Jiri Olsa <jolsa@redhat.com>
> > 
> > The only way to get the event ID is by reading the event fd,
> > followed by parsing the ID value out of the returned data.
> > 
> > While this is ok for current read format used by perf tool,
> > it is not ok when we use PERF_FORMAT_GROUP format.
> > 
> > With this format the data are returned for the whole group
> > and there's no way to find out what ID belongs to our fd
> > (if we are not group leader event).
> 
> I'm a little confused by this.
> 
> If you have an event group (with PERF_FORMAT_GROUP) and you specify
> PERF_FORMAT_ID in read_format, then when you read you get the id
> values for each sibling event along with their values, right?
> 
> This is how PAPI does things.  So I wouldn't say it's impossible to get 
> the event IDs with PERF_FORMAT_GROUP events.
> 
> Though maybe you're saying it's hard to map sibling fds to id values if 
> you don't have the list of all fds in an event group in the order they 
> were added.  Which I guess may be true, but I'd think your analysis tool 
> would have other problems if you didn't have that mapping.

right, the idea behind is not to be dependent
on how kernel chains events in the list

jirka

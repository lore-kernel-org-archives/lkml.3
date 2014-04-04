Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515AbaDDTb1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 15:31:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2976 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754374AbaDDTbZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 15:31:25 -0400
Date: Fri, 4 Apr 2014 15:31:19 -0400
From: Don Zickus <dzickus@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        jolsa@redhat.com, jmario@redhat.com, fowles@inreach.com
Subject: Re: [PATCH 3/4] perf, callchain: Add generic report parse callchain
 callback function
Message-ID: <20140404193119.GI8488@redhat.com>
References: <1395689577-214654-1-git-send-email-dzickus@redhat.com>
 <1395689577-214654-4-git-send-email-dzickus@redhat.com>
 <87zjk3x8dv.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zjk3x8dv.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, 2014 at 02:57:32PM +0900, Namhyung Kim wrote:
> On Mon, 24 Mar 2014 15:32:56 -0400, Don Zickus wrote:
> > This takes the parse_callchain_opt function and copies it into the
> > callchain.c file.  Now the c2c tool can use it too without duplicating.
> >
> > Signed-off-by: Don Zickus <dzickus@redhat.com>
> > ---
> >  tools/perf/util/callchain.c | 83 +++++++++++++++++++++++++++++++++++++++++++++
> >  tools/perf/util/callchain.h |  1 +
> >  2 files changed, 84 insertions(+)
> >
> > diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
> > index 8d9db45..2320678 100644
> > --- a/tools/perf/util/callchain.c
> > +++ b/tools/perf/util/callchain.c
> > @@ -25,6 +25,89 @@
> >  
> >  __thread struct callchain_cursor callchain_cursor;
> >  
> > +int
> > +report_parse_callchain_opt(const char *arg)
> 
> As it eliminated any dependency to the report code, the name can omit
> 'report' as well.

Hmm, shrinking this down to 'parse_callchain_opt' seems to conflict with
builtin-top.c's defintion which is a wrapper around
record_parse_callchain_opt.

I can modify builtin-top.c's defintion to top_parse_callchain_opt, but do
we want to make the function parse_callchain_opt name more obvious that it is
for 'report' style parsing (which means it looks for the embedded
callchain flag)?  Vs. the record_parse_callchain_opt function, which is for
setting up the callchain flag?

Cheers,
Don

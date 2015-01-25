Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759467AbbAYTWj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 14:22:39 -0500
Received: from smtprelay0092.hostedemail.com ([216.40.44.92]:35087 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756203AbbAYTWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 14:22:36 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2693:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3870:3872:4250:4321:4362:5007:6119:6261:7875:7903:10004:10400:10848:10967:11026:11232:11657:11658:11914:12517:12519:12555:12740:13069:13311:13357:14096:14097:21067:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cord12_6dc07059ff416
X-Filterd-Recvd-Size: 2006
Date: Sun, 25 Jan 2015 14:22:33 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH 2/5] tools lib api fs: Add tracefs mount helper
 functions
Message-ID: <20150125142233.1338c2e5@gandalf.local.home>
In-Reply-To: <20150125164536.GD31987@krava.brq.redhat.com>
References: <20150124181330.195149364@goodmis.org>
	<20150124181448.680347393@goodmis.org>
	<20150125164536.GD31987@krava.brq.redhat.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Jan 2015 17:45:36 +0100
Jiri Olsa <jolsa@redhat.com> wrote:

> On Sat, Jan 24, 2015 at 01:13:32PM -0500, Steven Rostedt wrote:
> 
> SNIP
> 
> > diff --git a/tools/lib/api/fs/tracefs.h b/tools/lib/api/fs/tracefs.h
> > new file mode 100644
> > index 000000000000..576206500e15
> > --- /dev/null
> > +++ b/tools/lib/api/fs/tracefs.h
> > @@ -0,0 +1,29 @@
> > +#ifndef __API_TRACEFS_H__
> > +#define __API_TRACEFS_H__
> > +
> > +#define _STR(x) #x
> > +#define STR(x) _STR(x)
> 
> I can't find STR macro being used in the code..

I noticed this too just after I sent the series. I was seeing who had
good eyes ;-)

It's from doing a cut and paste from debugfs.h, which still has it,
even though after this series, it's only used by findfs.c. Thus it
should be moved to findfs.h, and removed from debugfs.h and tracefs.h.

Thanks, will fix.

-- Steve

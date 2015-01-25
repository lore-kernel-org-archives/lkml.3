Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933057AbbAYTUe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 14:20:34 -0500
Received: from smtprelay0049.hostedemail.com ([216.40.44.49]:33609 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757857AbbAYTU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 14:20:29 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1538:1568:1593:1594:1711:1714:1730:1747:1777:1792:2198:2199:2393:2553:2559:2562:2693:3138:3139:3140:3141:3142:3622:3871:3876:4605:5007:6261:7875:7903:10004:10400:10848:10967:11026:11232:11658:11914:12438:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: spark43_5b59b07d47c2d
X-Filterd-Recvd-Size: 1621
Date: Sun, 25 Jan 2015 14:20:26 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH 1/5] tools lib fs: Add helper to find mounted file
 systems
Message-ID: <20150125142026.4e9a822e@gandalf.local.home>
In-Reply-To: <20150125164059.GC31987@krava.brq.redhat.com>
References: <20150124181330.195149364@goodmis.org>
	<20150124181448.499062732@goodmis.org>
	<20150125164059.GC31987@krava.brq.redhat.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Jan 2015 17:41:00 +0100
Jiri Olsa <jolsa@redhat.com> wrote:

> On Sat, Jan 24, 2015 at 01:13:31PM -0500, Steven Rostedt wrote:
> 

> > -	debugfs_found = true;
> > -
> > -	return debugfs_mountpoint;
> > +	return find_mountpoint("debugfs", (long) DEBUGFS_MAGIC,
> > +			       debugfs_mountpoint, PATH_MAX + 1,
> > +			       debugfs_known_mountpoints);
> >  }
> 
> debugfs_found is no longer set 'true' by debugfs_find_mountpoint
> 

Grumble. Will fix, thanks.

-- Steve

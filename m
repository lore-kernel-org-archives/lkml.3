Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759425AbbAYT1e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 14:27:34 -0500
Received: from smtprelay0125.hostedemail.com ([216.40.44.125]:45548 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755259AbbAYT12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 14:27:28 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2693:3138:3139:3140:3141:3142:3352:3622:3876:3877:5007:6114:6261:6642:7875:10004:10400:10848:10967:11026:11232:11473:11658:11914:12114:12438:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: stove33_6da7fb51cd00
X-Filterd-Recvd-Size: 2072
Date: Sun, 25 Jan 2015 14:27:26 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH 4/5] tools lib api fs: Add
 {tracefs,debugfs}_configured() functions
Message-ID: <20150125142726.7990cb6c@gandalf.local.home>
In-Reply-To: <20150125170203.GG31987@krava.brq.redhat.com>
References: <20150124181330.195149364@goodmis.org>
	<20150124181449.008674149@goodmis.org>
	<20150125170203.GG31987@krava.brq.redhat.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Jan 2015 18:02:03 +0100
Jiri Olsa <jolsa@redhat.com> wrote:

> On Sat, Jan 24, 2015 at 01:13:34PM -0500, Steven Rostedt wrote:
> 
> SNIP
> 
> >  #include <sys/mount.h>
> >  #include <linux/kernel.h>
> >  
> > @@ -24,6 +27,16 @@ static const char * const debugfs_known_mountpoints[] = {
> >  
> >  static bool debugfs_found;
> >  
> > +bool debugfs_configured(void)
> > +{
> > +	struct stat st;
> > +
> > +	if (stat(DEBUGFS_DEFAULT_PATH, &st) < 0)
> > +		return false;
> > +
> 
> hum, should  this function rather do
> 
> bool debugfs_configured(void)
> {
> 	return debugfs_find_mountpoint() != NULL;
> }
> 
> 
> SNIP
> 
> >  static bool tracefs_found;
> >  
> > +bool tracefs_configured(void)
> > +{
> > +	struct stat st;
> > +
> > +	if (stat(TRACEFS_DEFAULT_PATH, &st) < 0)
> > +		return false;
> > +
> > +	return true;
> > +}
> 
> same for this one..


OK, will change.

-- Steve

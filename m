Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758518AbbA0PT7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 10:19:59 -0500
Received: from smtprelay0211.hostedemail.com ([216.40.44.211]:58745 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754613AbbA0PT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 10:19:56 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3871:3872:3873:3874:5007:6119:6261:7875:7903:8526:9389:10004:10400:10450:10455:10848:10967:11026:11232:11658:11914:12517:12519:12740:13069:13211:13229:13311:13357:14096:14097:19904:19999:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: crate11_90ba1d96a625b
X-Filterd-Recvd-Size: 2294
Date: Tue, 27 Jan 2015 10:19:53 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 00/16 v3] tracing: Add new file system tracefs
Message-ID: <20150127101953.3245aaed@gandalf.local.home>
In-Reply-To: <20150127043839.GW29656@ZenIV.linux.org.uk>
References: <20150126150913.653681560@goodmis.org>
	<20150126193049.GN29656@ZenIV.linux.org.uk>
	<20150126154259.5e650d32@gandalf.local.home>
	<20150126214658.GQ29656@ZenIV.linux.org.uk>
	<20150126184314.24f2583c@gandalf.local.home>
	<20150127003742.GU29656@ZenIV.linux.org.uk>
	<20150126200218.6ecfc931@grimm.local.home>
	<20150126200350.471db2c0@grimm.local.home>
	<20150127043839.GW29656@ZenIV.linux.org.uk>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2015 04:38:39 +0000
Al Viro <viro@ZenIV.linux.org.uk> wrote:

> On Mon, Jan 26, 2015 at 08:03:50PM -0500, Steven Rostedt wrote:
> > On Mon, 26 Jan 2015 20:02:18 -0500
> > Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > 
> > > Now you see why I found just dropping the parent mutex easier.
> > 
> > And this is probably why kernfs does things the way it does. I can
> > imagine it having the same locking issues.
> 
> The least said about kernfs locking, the better...
> 
> As for the use of trace_types_lock to serialize rmdir vs. event
> addition/removal, I wonder what's wrong with actually using the
> ->i_mutex of /instances - you have a reference to its dentry,
> after all...

You mean, instead of grabbing trace_types_lock for modifying of events
and trace arrays, we should grab the dentry->d_inode->i_mutex?

BTW, what exactly can go wrong with the current method I have that
releases the i_mutex, calls the mkdir() method, and then regrabs the
i_mutex?

-- Steve

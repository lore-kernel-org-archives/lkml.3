Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583AbaKRBID (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 20:08:03 -0500
Received: from smtprelay0020.hostedemail.com ([216.40.44.20]:59663 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753091AbaKRBIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 20:08:01 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3872:3873:3874:4321:5007:6119:6261:10004:10400:10848:10967:11232:11658:11914:12296:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: laugh16_7ff101c616b3c
X-Filterd-Recvd-Size: 1998
Message-ID: <1416272878.29010.8.camel@perches.com>
Subject: Re: [PATCH 20/26 v5] seq_buf: Add seq_buf_can_fit() helper function
From: Joe Perches <joe@perches.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Petr Mladek <pmladek@suse.cz>
Date: Mon, 17 Nov 2014 17:07:58 -0800
In-Reply-To: <20141117195651.27c79369@gandalf.local.home>
References: <20141115045847.712848224@goodmis.org>
	 <20141115050604.073390701@goodmis.org>
	 <20141117123642.1de9252e@gandalf.local.home>
	 <1416269253.29010.4.camel@perches.com>
	 <20141117192733.0ab1ba2e@gandalf.local.home>
	 <1416270932.29010.6.camel@perches.com>
	 <20141117195651.27c79369@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-11-17 at 19:56 -0500, Steven Rostedt wrote:
> On Mon, 17 Nov 2014 16:35:32 -0800
> Joe Perches <joe@perches.com> wrote:
> 
>  
> > What "logic" does it place in one place and
> > how does it matter?
> 
> Look at the next patch.

I don't have it and you are not cc'ing me.
I think you are getting carried away with the helpers.

> > I don't see it making mistakes more or less
> > likely, I just see it being used to avoid
> > setting the overflow state which seems like
> > more of an error than anything else.
> > 
> > Why avoid setting overflow at all?
[]
> It has nothing to do with overflow. Where did you get that from?

writing to seq_buf really only cares about overflow.

seq_buf -> write to buffer -> overflowed?
expand buffer, redo everything else when finished,
dump buffer


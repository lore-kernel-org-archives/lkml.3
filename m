Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751249AbaKEXUt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 18:20:49 -0500
Received: from smtprelay0171.hostedemail.com ([216.40.44.171]:56304 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750975AbaKEXUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 18:20:45 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:960:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1981:2110:2194:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4321:5007:6261:7550:10004:10400:10848:11026:11232:11658:11914:12296:12517:12519:12740:13069:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: stem12_5daffe6e08d34
X-Filterd-Recvd-Size: 3130
Message-ID: <1415229642.6634.32.camel@perches.com>
Subject: Re: [PATCH 04/13] autofs4 - change printks AUTOFS defined prints
From: Joe Perches <joe@perches.com>
To: Ian Kent <raven@themaw.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        autofs mailing list <autofs@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed, 05 Nov 2014 15:20:42 -0800
In-Reply-To: <1415228573.2365.24.camel@perseus.themaw.net>
References: <20141103081218.6215.85903.stgit@perseus.themaw.net>
	 <20141103081234.6215.82821.stgit@perseus.themaw.net>
	 <1415003136.17743.9.camel@perches.com>
	 <1415006418.6573.6.camel@perseus.themaw.net>
	 <1415025215.17743.12.camel@perches.com>
	 <1415228573.2365.24.camel@perseus.themaw.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-11-06 at 07:02 +0800, Ian Kent wrote:
> On Mon, 2014-11-03 at 06:33 -0800, Joe Perches wrote:
> > 
> > That's fine.  I left out the trailing semicolon/space.
> > The pr_fmt could be something like:
> > #define pr_fmt(fmt) KBUILD_MODNAME ":%d:%s: " fmt, current->pid, __func__
> > or add a "pid:" descriptor prefix if you like too:
> > #define pr_fmt(fmt) KBUILD_MODNAME ":pid:%d:%s: " fmt, current->pid, __func__
> > 
> > > > it's better to use a consistent style for
> > > > these logging functions ideally with terminating
> > > > newlines so there isn't a mix of code with
> > > > and without those newlines.  That inconsistency
> > > > leads to unintended defects.
> > > 
> > > The idea here was to make the logging consistent throughout.
> > 
> > Mine too.
> > 
> > > I have become used of not using the new-line terminator in logging over
> > > the years and tend to favour that myself. You recommend not doing that
> > > probably from a kernel wide consistency perspective? Maybe that is
> > > better ...
> > 
> > Yes, kernel style consistency is the rationale.
> > 
> > Over time, people come along and add messages
> > while not reading the code very closely so using
> > the kernel style with newlines can help avoid
> > these trivial defects.
> 
> I can see how not including the trailing newline in the macros is a good
> thing and I'll forward a couple more patches to Andrew for this and fix
> the inconsistencies.

OK, great.

> But idea of using pr_xxx() and pr_fmt() (actually that's too open to
> name clashes so it would need to be named something like autofs_pr_fmt()
> anyway) looks like it results in less readable code so I'd really prefer
> not to do that.

Using pr_info/pr_debug (or any other pr_<level>) is a
generic mechanism in the kernel.  Adding a
#define pr_fmt is also generic thing that works with
all the pr_<level> uses in a specific compilation unit.

cheers, Joe


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab3EJVRZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 17:17:25 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:37586 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149Ab3EJVRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 17:17:24 -0400
Date: Fri, 10 May 2013 22:17:16 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Borislav Petkov <bp@alien8.de>, Andrew Morton <akpm@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: SyS symbol munging.
Message-ID: <20130510211716.GN25399@ZenIV.linux.org.uk>
References: <20130510192417.GA4915@redhat.com>
 <20130510123510.78c066f177a7a8e5dd9ec7e4@linux-foundation.org>
 <20130510195500.GD23014@pd.tnic>
 <20130510200503.GM25399@ZenIV.linux.org.uk>
 <20130510205622.GD9583@home.goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130510205622.GD9583@home.goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 04:56:22PM -0400, Steven Rostedt wrote:
> On Fri, May 10, 2013 at 09:05:03PM +0100, Al Viro wrote:
> > On Fri, May 10, 2013 at 09:55:00PM +0200, Borislav Petkov wrote:
> > > On Fri, May 10, 2013 at 12:35:10PM -0700, Andrew Morton wrote:
> > > > I forget who did this initially and peeling back those layers with git
> > > > is tiresome.
> > > 
> > > 1a94bc34768e4 from 2009, although those SyS* things started appearing in
> > > stack traces only recently AFAIR.
> > 
> > Note that both sys_something and SyS_something end up in vmlinux symbol
> > table, refering to the same address.  AFAICS, what matters is which one
> > goes first.  May be even linker-dependent...
> 
> Actually, it's the first one that kallsyms finds in its binary search.
> 
> If the table is layed out a little differently, it may find the first
> one or the second one.

Then maybe it's worth trying to kill these aliases in kallsyms.  We also
have compat_SyS_something stuff.  Actually, most of the aliases seem to be
of those forms - after removing (a_sys_b,a_SyS_b) pairs the list of duplicates
in System.map shrinks by factor of 15 or so...

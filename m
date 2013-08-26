Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589Ab3HZLs2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 07:48:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48767 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751596Ab3HZLs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 07:48:27 -0400
Date: Mon, 26 Aug 2013 13:48:21 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        mhocko@suse.cz, hare@suse.de, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 0/4 v6] Avoid softlockups in console_unlock()
In-Reply-To: <20130823125822.b3f5b946ef1e86c52834d0c3@linux-foundation.org>
Message-ID: <alpine.LNX.2.00.1308261347220.2077@pobox.suse.cz>
References: <1377072512-7986-1-git-send-email-jack@suse.cz> <20130821142723.5fd8c0b0062b35ee83a68dcc@linux-foundation.org> <20130821225915.GA16653@quack.suse.cz> <20130822124913.c6de8fe61e9fd601bd83ff63@linux-foundation.org> <alpine.LNX.2.00.1308232146250.25124@deuxcents.site>
 <20130823125822.b3f5b946ef1e86c52834d0c3@linux-foundation.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Aug 2013, Andrew Morton wrote:

> > > >   We have customers (quite a few of them actually) which have machines with
> > > > lots of SCSI disks attached (due to multipath etc.) and during boot when
> > > > these disks are discovered and partitions set up quite some printing
> > > > happens - multiplied by the number of devices (1000+) it is too much for a
> > > > serial console to handle quickly enough. So these machines aren't able to
> > > > boot with serial console enabled.
> > > 
> > > It sounds like rather a corner case, not worth mucking up the critical
> > > core logging code.
> > 
> > Andrew, I have to admit I don't understand this argument at all.
> 
> Of course you do.  print should be simple, robust and have minimum
> dependency on other kernel parts.

I agree. That would need a complete printk() rewrite though. Before that 
happens, fixing obvious lockup in the code seems like a very proper thing 
to do.

-- 
Jiri Kosina
SUSE Labs

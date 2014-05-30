Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933077AbaE3KKM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 06:10:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60064 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755355AbaE3KKK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 06:10:10 -0400
Date: Fri, 30 May 2014 12:10:06 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jan Kara <jack@suse.cz>
cc: Frederic Weisbecker <fweisbec@gmail.com>, Petr Mladek <pmladek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Dave Anderson <anderson@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Kay Sievers <kay@vrfy.org>, Michal Hocko <mhocko@suse.cz>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 00/11] printk: safe printing in NMI context
In-Reply-To: <20140530081328.GA2419@quack.suse.cz>
Message-ID: <alpine.LNX.2.00.1405301207310.9080@pobox.suse.cz>
References: <1399626665-29817-1-git-send-email-pmladek@suse.cz> <alpine.LNX.2.00.1405290000350.17241@pobox.suse.cz> <20140529000909.GC6507@localhost.localdomain> <20140530081328.GA2419@quack.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 May 2014, Jan Kara wrote:

> >  Documentation/kernel-parameters.txt |   19 +-
> >  kernel/printk/printk.c              | 1218 +++++++++++++++++++++++++----------
> >  2 files changed, 878 insertions(+), 359 deletions(-)
> > 
> > 
> > Your patches look clean and pretty nice actually. They must be seriously
> > considered if we want to keep the current locked ring buffer design and
> > extend it to multiple per context buffers. But I wonder if it's worth to
> > continue that way with the printk ancient design.
> > 
> > If it takes more than 1000 line changes (including 500 added) to make it
> > finally work correctly with NMIs by working around its fundamental flaws,
> > shouldn't we rather redesign it to use a lockless ring buffer like ftrace
> > or perf ones?
>   I agree that lockless ringbuffer would be a more elegant solution but a
> much more intrusive one and complex as well. Petr's patch set basically
> leaves ordinary printk path intact to avoid concerns about regressions
> there.

Fully agreed, vast majority of the changes done by the patchset are on the 
unlikely in-NMI path, leaving normal printk operation as-is.

-- 
Jiri Kosina
SUSE Labs

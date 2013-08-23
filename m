Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756370Ab3HWT61 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 15:58:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59854 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756235Ab3HWT6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 15:58:25 -0400
Date: Fri, 23 Aug 2013 12:58:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        mhocko@suse.cz, hare@suse.de, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 0/4 v6] Avoid softlockups in console_unlock()
Message-Id: <20130823125822.b3f5b946ef1e86c52834d0c3@linux-foundation.org>
In-Reply-To: <alpine.LNX.2.00.1308232146250.25124@deuxcents.site>
References: <1377072512-7986-1-git-send-email-jack@suse.cz>
	<20130821142723.5fd8c0b0062b35ee83a68dcc@linux-foundation.org>
	<20130821225915.GA16653@quack.suse.cz>
	<20130822124913.c6de8fe61e9fd601bd83ff63@linux-foundation.org>
	<alpine.LNX.2.00.1308232146250.25124@deuxcents.site>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Aug 2013 21:48:36 +0200 (CEST) Jiri Kosina <jkosina@suse.cz> wrote:

> > >   We have customers (quite a few of them actually) which have machines with
> > > lots of SCSI disks attached (due to multipath etc.) and during boot when
> > > these disks are discovered and partitions set up quite some printing
> > > happens - multiplied by the number of devices (1000+) it is too much for a
> > > serial console to handle quickly enough. So these machines aren't able to
> > > boot with serial console enabled.
> > 
> > It sounds like rather a corner case, not worth mucking up the critical
> > core logging code.
> 
> Andrew, I have to admit I don't understand this argument at all.

Of course you do.  print should be simple, robust and have minimum
dependency on other kernel parts.

I suppose that if you make the proposed
/proc/sys/kernel/max_printk_chars settable from the boot command line
and default to zero, any risks are minimized.

Baling out if oops_in_progress was a good thing also.

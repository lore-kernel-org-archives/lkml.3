Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356Ab3HVWOa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 18:14:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46818 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658Ab3HVWO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 18:14:29 -0400
Date: Thu, 22 Aug 2013 15:14:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, mhocko@suse.cz, hare@suse.de,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 0/4 v6] Avoid softlockups in console_unlock()
Message-Id: <20130822151427.38650aae09e909d52a57b393@linux-foundation.org>
In-Reply-To: <20130822215742.GA32040@quack.suse.cz>
References: <1377072512-7986-1-git-send-email-jack@suse.cz>
	<20130821142723.5fd8c0b0062b35ee83a68dcc@linux-foundation.org>
	<20130821225915.GA16653@quack.suse.cz>
	<20130822124913.c6de8fe61e9fd601bd83ff63@linux-foundation.org>
	<20130822215742.GA32040@quack.suse.cz>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Aug 2013 23:57:42 +0200 Jan Kara <jack@suse.cz> wrote:

> On Thu 22-08-13 12:49:13, Andrew Morton wrote:
> > Desperately seeking alternatives...
> > 
> > I suppose there's some reason why we can't just make those drivers shut
> > up?  If the messages are in the log buffer but aren't displayed,
> > they're still accessible after boot?
> > 
> > Or how about passing those messages over to a kernel thread, to be
> > printed out at a lower rate?  A linked list and schedule_work() would
> > suffice.
> 
>   Andrew, you seem really desperate ;-)

Years of hard experience have taught me: don't muck with printk.  It
needs to be robust, simple and to have minimum dependency on both the
calling environment and on correctly functioning kernel components. 
printk and NMI are the harshest environments we have to deal with.

> I don't really like modifying
> individual drivers, partitioning code, or SCSI core to be less verbose -
> IMHO that's fighting with windmills and it's not like any of those parts is
> excessively verbose. Every part prints its bits and it accumulates. I
> cannot really imagine this would work long term.
> 
> Handing over printing to someone else is exactly what I'm doing

No you aren't - you're mucking with printk!

What I'm proposing is to put a front-end *before* printk.  Thus leaving
printk unmucked with.

But it was just a suggestion.  Maybe there are other ways.  I'm
inviting you to suggest ways of fixing this obscure corner case
without mucking with everyone's printk.


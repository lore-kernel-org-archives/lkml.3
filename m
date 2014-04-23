Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757686AbaDWSRx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 14:17:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57695 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500AbaDWSRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 14:17:51 -0400
Date: Wed, 23 Apr 2014 11:17:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        LKML <linux-kernel@vger.kernel.org>, pmladek@suse.cz,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 8/8] printk: Add config option for disabling printk
 offloading
Message-Id: <20140423111750.88ad799bb271a1fe0bed119f@linux-foundation.org>
In-Reply-To: <20140423110847.GB17824@quack.suse.cz>
References: <1395770101-24534-1-git-send-email-jack@suse.cz>
	<1395770101-24534-9-git-send-email-jack@suse.cz>
	<20140326172332.5f1e1bfb@alan.etchedpixels.co.uk>
	<20140326192815.GC18118@quack.suse.cz>
	<20140418115438.1e65e07af17e3ba6d7c554db@linux-foundation.org>
	<20140422112259.5f106a44@alan.etchedpixels.co.uk>
	<20140423110847.GB17824@quack.suse.cz>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Apr 2014 13:08:47 +0200 Jan Kara <jack@suse.cz> wrote:

> > If you want reliable crash logging then we need to be able to set a
> > printk level mask per console and just set the serial console for
> > "crit/err" and the queue console for the rest, with a 'cat
> > >/dev/ttywhatever' running if this feature was in use ?
>   Ok, now I understand. Thanks for an interesting idea. IMO people
> definitely need messages logged directly into serial console when e.g. oops
> is happening because very likely they won't get logged to disk and even
> userspace won't have a chance to run and copy messages to the serial
> console. Plus for useful softlockup reports or oops messages you need also
> the KERN_NOTICE and KERN_INFO messages - stack traces, cpu numbers, process
> information - all this is printed with these levels.
> 
> These obvious places could be changed to print with lower log level I
> assume but still I'm somewhat worried that some KERN_INFO messages that
> would be useful for debugging a crash won't make it to console before the
> crash happens.
> 
> But if both you and Andrew think that the above problems are smaller than
> the complexity connected with printk offloading, I can give it a try.
> Andrew?

I'm curious about the idea of writing a new(?) console driver which the
problematic machines can use.

The problem of course will be in sizing the driver's queue.  Perhaps we
can have a driver which uses a huge queue, temporarily use that driver
during boot then switch over to a conventional console driver?


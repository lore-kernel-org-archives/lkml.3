Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845AbaDWMf6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 08:35:58 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:55132 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725AbaDWMfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 08:35:55 -0400
Date: Wed, 23 Apr 2014 13:35:44 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, pmladek@suse.cz,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 8/8] printk: Add config option for disabling printk
 offloading
Message-ID: <20140423133544.5598c18a@alan.etchedpixels.co.uk>
In-Reply-To: <20140423110847.GB17824@quack.suse.cz>
References: <1395770101-24534-1-git-send-email-jack@suse.cz>
	<1395770101-24534-9-git-send-email-jack@suse.cz>
	<20140326172332.5f1e1bfb@alan.etchedpixels.co.uk>
	<20140326192815.GC18118@quack.suse.cz>
	<20140418115438.1e65e07af17e3ba6d7c554db@linux-foundation.org>
	<20140422112259.5f106a44@alan.etchedpixels.co.uk>
	<20140423110847.GB17824@quack.suse.cz>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > It's not worth adding for upstream anyway - not in that form. If it just
> > used schedule_work it would be way way cleaner anyway.
>   Alan, please stop complaining that the patches don't use schedule_work()
> when you didn't bother to answer to me when I was explaining to you twice
> what is the problem with using schedule_work().

I have not seen any response to the schedule_work() comment. If the
filters ate it then I apologize.

> console. Plus for useful softlockup reports or oops messages you need also
> the KERN_NOTICE and KERN_INFO messages - stack traces, cpu numbers, process
> information - all this is printed with these levels.

If there is softlockup and oops trace data being printed at KERN_INFO
that could be fixed by changing the level.

> These obvious places could be changed to print with lower log level I
> assume but still I'm somewhat worried that some KERN_INFO messages that
> would be useful for debugging a crash won't make it to console before the
> crash happens.

That's true whatever you do. Either your output is synchronous and makes
it out because it is physically output before the box is permitted to go
bang, or its asynchronous in which case be it work queue, thread or
anything else it may not get out.

Alan

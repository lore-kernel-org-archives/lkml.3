Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481AbaCNM0Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 08:26:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58735 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753065AbaCNM0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 08:26:24 -0400
Date: Fri, 14 Mar 2014 13:26:21 +0100
From: Jan Kara <jack@suse.cz>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>, pmladek@suse.cz,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 5/6] printk: Hand over printing to console if printing
 too long
Message-ID: <20140314122621.GC18583@quack.suse.cz>
References: <1394726318-2757-1-git-send-email-jack@suse.cz>
 <1394726318-2757-6-git-send-email-jack@suse.cz>
 <20140313160625.1c62ca6bba080286194aa868@linux-foundation.org>
 <20140313232636.02766d06@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140313232636.02766d06@alan.etchedpixels.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 13-03-14 23:26:36, One Thousand Gnomes wrote:
> > Creating yet more kernel threads to solve this problem is a bit sad. 
> > Is there no way in which we can borrow one of the existing threads?
> 
> schedule_work()
> 
> Surely that's all we need, if we get bunged up for a bit then it ends up
> on a work queue item and everyone with a billion disks and a 9600 baud
> serial port is still happy. Nobody else will ever see it.
  Yes, I know about schedule_work() and I've used it about an year (and ~10
patchset iterations) ago when first trying to solve this problem. The
problem with using workqueues is that if workqueue code ever does printk()
while holding some workqueue lock, we could deadlock when trying to do
schedule_work() from printk which might need the same lock. And people were
objecting to restricting workqueue code to not call printk(). That's why
I've chosen dedicated kthreads were we have tight control over what they
do.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

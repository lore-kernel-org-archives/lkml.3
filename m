Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751262AbaAENS1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 08:18:27 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:58586 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbaAENS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 08:18:26 -0500
Date: Sun, 5 Jan 2014 21:13:00 +0800
From: Shaohua Li <shli@kernel.org>
To: Kent Overstreet <kmo@daterainc.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, hch@infradead.org
Subject: Re: [patch 1/2]percpu_ida: fix a live lock
Message-ID: <20140105131300.GB4186@kernel.org>
References: <20131231033827.GA31994@kernel.org>
 <20140104210804.GA24199@kmo-pixel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140104210804.GA24199@kmo-pixel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 04, 2014 at 01:08:04PM -0800, Kent Overstreet wrote:
> On Tue, Dec 31, 2013 at 11:38:27AM +0800, Shaohua Li wrote:
> > 
> > steal_tags only happens when free tags is more than half of the total tags.
> > This is too restrict and can cause live lock. I found one cpu has free tags,
> > but other cpu can't steal (thread is bound to specific cpus), threads which
> > wants to allocate tags are always sleeping. I found this when I run next patch,
> > but this could happen without it I think.
> > 
> > I did performance test too with null_blk. Two cases (each cpu has enough percpu
> > tags, or total tags are limited) haven't performance changes.
> 
> This doesn't appear to me to fix anything wrong with the current code
> (and it'll hurt performance)

I suspects this hurts performance too, but it doesn't actually in my test.

> - we explicitly don't guarantee that all
> the tags will be available for allocation at any given time, only half
> of them. 

only half of the tags can be used? this is scaring. Of course we hope all tags
are available.

> Can you explain more how this is being used where you're seeing
> the issue? And I don't see the other patch in your patch series.

tasks are bound to specific cpus. And I saw one cpu has a lot of free (but less
than half of total tags), but other cpus can't allocate tags, so I saw a live
lock.

Thanks,
Shaohua

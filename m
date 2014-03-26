Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035AbaCZT2V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 15:28:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51917 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755199AbaCZT2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 15:28:19 -0400
Date: Wed, 26 Mar 2014 20:28:15 +0100
From: Jan Kara <jack@suse.cz>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, pmladek@suse.cz,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 8/8] printk: Add config option for disabling printk
 offloading
Message-ID: <20140326192815.GC18118@quack.suse.cz>
References: <1395770101-24534-1-git-send-email-jack@suse.cz>
 <1395770101-24534-9-git-send-email-jack@suse.cz>
 <20140326172332.5f1e1bfb@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140326172332.5f1e1bfb@alan.etchedpixels.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 26-03-14 17:23:32, One Thousand Gnomes wrote:
> On Tue, 25 Mar 2014 18:55:01 +0100
> Jan Kara <jack@suse.cz> wrote:
> 
> > Necessity for offloading of printing was observed only for large
> > systems. So add a config option (disabled by default) which removes most
> > of the overhead added by this functionality.
> 
> If its an option it'll not get used. It ought to be automatic.
>
> I still think the mindset of this patch set is wrong. Only the device
> driver really knows what is good or bad. A large x86 connected to a
> network fake 16x50 serial port for example typically has a giant FIFO so
> 'bad' becomes 32K not 1000. A USB serial port already does async queueing
> so the value is 0.
  I'd be very happy to take a patch which would do the propagation of
the information how fast the driver is from the driver into the printk. But
I have no knowledge of what console drivers do and how fast devices are
supposed to be and reading all that code just for the sake of this seems
like a bad investment of time to me.

I'm happy with a solution that the feature is disabled by default so people
don't have to pay the cost. For enterprise kernels which are supposed to
run on large enough machines that printk offload makes sense, the overhead
just doesn't matter IMHO.

> It also ignores priority so you might queue and loose an oops as a box
> goes down in preference to reporting debugging crap.
  But that's no different to what happens now. Or am I missing something?

> All the afflicted consoles are serial, all go via the uart layer as far
> as I can see.
> 
> The uart layer has a queue mechanism that could be used
  I'm sorry, I don't follow here - what can the uart queueing be used for?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

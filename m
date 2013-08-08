Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757805Ab3HHMMC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 08:12:02 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:47856 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627Ab3HHMMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 08:12:01 -0400
Date: Thu, 8 Aug 2013 05:11:54 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Kent Overstreet <kmo@daterainc.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ben Hutchings <ben@decadent.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>
Subject: Re: PREEMPT_RT vs bcache
Message-ID: <20130808121154.GA5180@infradead.org>
References: <1375907298.27403.35.camel@deadeye.wl.decadent.org.uk>
 <20130808072623.GA3509@infradead.org>
 <20130808074326.GA15409@kmo-pixel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130808074326.GA15409@kmo-pixel>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 08, 2013 at 12:43:26AM -0700, Kent Overstreet wrote:
> I seem to recall from looking at the logs that you just removed them
> because all the old users could be and were converted to something
> saner, for what they were doing (using them as completions, I want to
> say?)

We explicitly converted them away so that we could kill it.  This was
a joint project with Thomas.

> Bcache isn't using the rw sem as a completion though, it really is a
> read/write lock that protects a specific data structure, and  where
> we're taking a read lock for the duration of write IOs - and since bios
> are asynchronous, that's why we need the non_owner() bit.

Part of this commit was to make the rw_semaphore behaviour similar to
plain mutex, that is making sure there is exactly one owner and not
different processes locking/unlocking it.  This is useful for PI (that's
why the rt folks care), lock debugging and kinds of other use cases.

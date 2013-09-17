Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711Ab3IQRKb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 13:10:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36060 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753447Ab3IQRKa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 13:10:30 -0400
Date: Tue, 17 Sep 2013 19:10:28 +0200
From: Jan Kara <jack@suse.cz>
To: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: BLK_TN_PROCESS events not delivered for all devices
Message-ID: <20130917171028.GB16938@quack.suse.cz>
References: <20130916092347.GB19027@quack.suse.cz>
 <52386733.4010801@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52386733.4010801@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 17-09-13 08:29:07, Jens Axboe wrote:
> On 09/16/2013 03:23 AM, Jan Kara wrote:
> >   Hi,
> > 
> >   I've been looking into a problem where BLK_TN_PROCESS events are not
> > delivered to all devices which are being traced. This results in process
> > name being (null) when trace for a single device is parsed.
> > 
> > The reason for this problem is that trace_note_tsk() is called only if
> > tsk->btrace_seq != blktrace_seq and it updates tsk->btrace_seq to
> > blktrace_seq. Thus after a trace for another device is started
> > BLK_TN_PROCESS event is sent only on behalf of the first device with which
> > the task interacts. That isn't necessarily the new device thus traces for
> > some devices accumulate several BLK_TN_PROCESS events for one task while
> > other have none. Is this a known problem and is this intended to work
> > better?
> > 
> > I was thinking how to fix that for a while and it doesn't seem to be
> > possible without tracking with each block trace which tasks it has been
> > notified about. And that is relatively expensive...
> 
> It is unfortunately a known issue... I have not come up with a good way
> to fix it either, while keeping it cheap. So if you think of something,
> do let me know.
  Hum... How about linking all running block traces (struct blk_trace) in a
linked list and sending BLK_TN_PROCESS to all the traces? Sure we will be
spamming with BLK_TN_PROCESS a bit but starting a trace isn't such a common
thing so it shouldn't be too bad. What do you think?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

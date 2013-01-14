Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757622Ab3ANSEa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 13:04:30 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:59135 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757357Ab3ANSE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 13:04:28 -0500
Date: Mon, 14 Jan 2013 13:04:27 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Ming Lei <ming.lei@canonical.com>, Alex Riesen <raa.lkml@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: USB device cannot be reconnected and khubd "blocked for more
 than 120 seconds"
In-Reply-To: <CA+55aFxV40V2WvNtJY3EC0F-B9wPk8CV2o1TTTyoF4CoWH7rhQ@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1301141302380.1782-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jan 2013, Linus Torvalds wrote:

> > - from view of driver, introducing async_synchronize_full() after
> > do_one_initcall() inside do_init_module() is like a sync probe
> > for drivers built as module, and cause this kind of deadlock easily.
> >
> > So could we revert the commit and fix the previous problems just
> > case by case? or other better fix?
> 
> There's no way in hell we take a "fix things one by one" approach.
> It's not going to work. And your suggestion seems to not do async
> discovery of devices in general, which is a *much* worse fix than
> anything else. It's just crazy.
> 
> But there are other approaches we might take. We might move the call to
> 
>     async_synchronize_full();
> 
> to other places. For example, maybe we're better off doing it at
> block/char device open instead?

How about skipping that call if the current thread is one of the async 
helpers?  Is it possible to detect when that happens?

Or maybe such a check should go inside async_synchronize_full() itself.

Alan Stern


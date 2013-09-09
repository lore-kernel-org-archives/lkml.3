Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492Ab3IIPLI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 11:11:08 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:39251 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199Ab3IIPLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 11:11:06 -0400
Date: Mon, 9 Sep 2013 18:09:42 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Minchan Kim <minchan@kernel.org>,
        Jerome Marchand <jmarchan@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] staging: zram: minimize `slot_free_lock' usage (v2)
Message-ID: <20130909150942.GC2221@swordfish.minsk.epam.com>
References: <20130906151255.GE2238@swordfish.minsk.epam.com>
 <20130909123329.GZ19256@mwanda>
 <20130909124942.GA2221@swordfish.minsk.epam.com>
 <20130909132124.GY6329@mwanda>
 <20130909144259.GB2221@swordfish.minsk.epam.com>
 <20130909145229.GB19256@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130909145229.GB19256@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (09/09/13 17:52), Dan Carpenter wrote:
> On Mon, Sep 09, 2013 at 05:42:59PM +0300, Sergey Senozhatsky wrote:
> > > 3) Explain why it is safe to test zram->slot_free_rq when we are not
> > >    holding the lock.  I think it is unsafe.  I don't want to even think
> > >    about it without the numbers.
> > 
> > atomic pointer test, which is either NULL or !NULL.
> > 
> 
> That's not how concurency works.  Atomic types are complicated than
> that.  Anyway, the zram maintainers don't need me to explain that to
> them so I'll let them take over from here.
> 

yes, I understand that. but can't we check slot_free_rq pointer
(32 or 64 bit read) w/o locking to just decide if we must:
-- call handle_pending_slot_free()
-- take the slot_free_lock
-- check slot_free_rq again (this time under the slot_free_lock) and perform
   slot_free_rq operations while it is !NULL.

	-ss

> regards,
> dan carpenter
> 

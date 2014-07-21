Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123AbaGUJLG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 05:11:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55595 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753031AbaGUJLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 05:11:03 -0400
Date: Mon, 21 Jul 2014 11:11:45 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] blk-mq: bitmap tag: fix potential unwakeable sleep in
 bt_get()
Message-ID: <20140721091144.GB2107@dhcp-26-207.brq.redhat.com>
References: <1405930246-2051-1-git-send-email-agordeev@redhat.com>
 <53CCCC76.7060506@kernel.dk>
 <20140721083202.GA2107@dhcp-26-207.brq.redhat.com>
 <53CCD08C.80702@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53CCD08C.80702@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 10:34:20AM +0200, Jens Axboe wrote:
> On 2014-07-21 10:32, Alexander Gordeev wrote:
> >On Mon, Jul 21, 2014 at 10:16:54AM +0200, Jens Axboe wrote:
> >>What is this patch against?
> >
> >v3.16-rc5
> 
> My bad, was looking at the wrong sources. What is the race? If the
> clear and wakeup come in after the prepare_to_wait() but before the
> io_schedule(), the io_schedule() will be a no-op and it wont
> actually sleep. Your commit message doesn't mention any particular
> details.

Let me examine the code.. It was few weeks ago and I can not
remember what was that. And the changelog does not help :)

> 
> -- 
> Jens Axboe
> 

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com

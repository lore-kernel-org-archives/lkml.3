Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734AbaGJUFs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 16:05:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43274 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752560AbaGJUFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 16:05:46 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Benjamin LaHaise <bcrl@kvack.org>,
        "Elliott\, Robert \(Server Storage\)" <Elliott@hp.com>,
        Christoph Hellwig <hch@infradead.org>,
        "dgilbert\@interlog.com" <dgilbert@interlog.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Bart Van Assche <bvanassche@fusionio.com>,
        "linux-scsi\@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: scsi-mq V2
References: <1403715121-1201-1-git-send-email-hch@lst.de>
	<20140708144829.GA5539@infradead.org> <53BD7041.5010300@interlog.com>
	<53BD9A24.7010203@kernel.dk>
	<94D0CD8314A33A4D9D801C0FE68B402958B9628B@G9W0745.americas.hpqcorp.net>
	<20140710062040.GB20146@infradead.org>
	<20140710133609.GO12478@kvack.org>
	<20140710135051.GA28227@infradead.org> <53BE9AB1.6090603@kernel.dk>
	<94D0CD8314A33A4D9D801C0FE68B402958B96CF0@G9W0745.americas.hpqcorp.net>
	<20140710144539.GU12478@kvack.org>
	<x49k37l1c6p.fsf@segfault.boston.devel.redhat.com>
	<53BEF0A8.7010608@kernel.dk>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 10 Jul 2014 16:05:02 -0400
In-Reply-To: <53BEF0A8.7010608@kernel.dk> (Jens Axboe's message of "Thu, 10
	Jul 2014 21:59:36 +0200")
Message-ID: <x49r41tyo7l.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:

> On 2014-07-10 17:11, Jeff Moyer wrote:
>> Benjamin LaHaise <bcrl@kvack.org> writes:
>>
>>>>
>>>> [  186.339064] ioctx_alloc: nr_events=-2 aio_max_nr=65536
>>>> [  186.339065] ioctx_alloc: nr_events=-2 aio_max_nr=65536
>>>> [  186.339067] ioctx_alloc: nr_events=-2 aio_max_nr=65536
>>>> [  186.339068] ioctx_alloc: nr_events=-2 aio_max_nr=65536
>>>> [  186.339069] ioctx_alloc: nr_events=-2 aio_max_nr=65536
>>>
>>> Something is horribly wrong here.  There is no way that value for nr_events
>>> should be passed in to ioctx_alloc().  This implies that userland is calling
>>> io_setup() with an impossibly large value for nr_events.  Can you post the
>>> actual diff for your fs/aio.c relative to linus' tree?
>>>
>>
>> fio does exactly this!  it passes INT_MAX.
>
> That's correct, I had actually forgotten about this. It was a change
> made a few years back, in correlation with the aio optimizations
> posted then, basically telling aio to ignore that silly (and broken)
> user ring.

I still don't see how you accomplish that.  Making it bigger doesn't get
rid of it.  ;-)

Cheers,
Jeff

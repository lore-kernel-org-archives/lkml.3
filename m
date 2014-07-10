Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750AbaGJUG7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 16:06:59 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:48417 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbaGJUG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 16:06:58 -0400
Message-ID: <53BEF25C.5030607@kernel.dk>
Date: Thu, 10 Jul 2014 22:06:52 +0200
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: Benjamin LaHaise <bcrl@kvack.org>,
        "Elliott\, Robert \(Server Storage\)" <Elliott@hp.com>,
        Christoph Hellwig <hch@infradead.org>,
        "dgilbert@interlog.com" <dgilbert@interlog.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Bart Van Assche <bvanassche@fusionio.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: scsi-mq V2
References: <1403715121-1201-1-git-send-email-hch@lst.de>	<20140708144829.GA5539@infradead.org> <53BD7041.5010300@interlog.com>	<53BD9A24.7010203@kernel.dk>	<94D0CD8314A33A4D9D801C0FE68B402958B9628B@G9W0745.americas.hpqcorp.net>	<20140710062040.GB20146@infradead.org>	<20140710133609.GO12478@kvack.org>	<20140710135051.GA28227@infradead.org> <53BE9AB1.6090603@kernel.dk>	<94D0CD8314A33A4D9D801C0FE68B402958B96CF0@G9W0745.americas.hpqcorp.net>	<20140710144539.GU12478@kvack.org>	<x49k37l1c6p.fsf@segfault.boston.devel.redhat.com>	<53BEF0A8.7010608@kernel.dk> <x49r41tyo7l.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49r41tyo7l.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-07-10 22:05, Jeff Moyer wrote:
> Jens Axboe <axboe@kernel.dk> writes:
>
>> On 2014-07-10 17:11, Jeff Moyer wrote:
>>> Benjamin LaHaise <bcrl@kvack.org> writes:
>>>
>>>>>
>>>>> [  186.339064] ioctx_alloc: nr_events=-2 aio_max_nr=65536
>>>>> [  186.339065] ioctx_alloc: nr_events=-2 aio_max_nr=65536
>>>>> [  186.339067] ioctx_alloc: nr_events=-2 aio_max_nr=65536
>>>>> [  186.339068] ioctx_alloc: nr_events=-2 aio_max_nr=65536
>>>>> [  186.339069] ioctx_alloc: nr_events=-2 aio_max_nr=65536
>>>>
>>>> Something is horribly wrong here.  There is no way that value for nr_events
>>>> should be passed in to ioctx_alloc().  This implies that userland is calling
>>>> io_setup() with an impossibly large value for nr_events.  Can you post the
>>>> actual diff for your fs/aio.c relative to linus' tree?
>>>>
>>>
>>> fio does exactly this!  it passes INT_MAX.
>>
>> That's correct, I had actually forgotten about this. It was a change
>> made a few years back, in correlation with the aio optimizations
>> posted then, basically telling aio to ignore that silly (and broken)
>> user ring.
>
> I still don't see how you accomplish that.  Making it bigger doesn't get
> rid of it.  ;-)

See the patches from back then - INT_MAX basically just meant the same 
as 0, but 0 could not be used because of the (silly) setup with the 
wrappers around the syscalls. So INT_MAX was overloaded to mean "no ring 
events, I don't care".

-- 
Jens Axboe


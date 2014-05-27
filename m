Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493AbaE0Sy2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 14:54:28 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:41566 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479AbaE0SyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 14:54:24 -0400
Message-ID: <5384DF5E.3020304@kernel.dk>
Date: Tue, 27 May 2014 12:54:22 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: Ming Lei <tom.leiming@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] block: mq flush: fix race between IPI handler and mq
 flush worker
References: <1400511950-18522-1-git-send-email-tom.leiming@gmail.com> <20140519151824.GA21762@lst.de> <CACVXFVNprzhEpXGKze=A4T2b-y35vXRxRTOUqpywu+Et=t37Kw@mail.gmail.com> <20140520152303.GA20352@lst.de> <CACVXFVNP--zj_-UtygxfXk7GvSXwKm2KMKFs=h9KsrL=ZzbWVQ@mail.gmail.com> <20140521053634.GA4764@lst.de> <CACVXFVO5znzYtPKMTPwx_2MU97xFZY+wHwm+R33T043SW4JHHw@mail.gmail.com> <20140527181305.GA7975@lst.de> <5384DB97.70606@kernel.dk> <20140527185301.GA8466@lst.de>
In-Reply-To: <20140527185301.GA8466@lst.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-05-27 12:53, Christoph Hellwig wrote:
> On Tue, May 27, 2014 at 12:38:15PM -0600, Jens Axboe wrote:
>> On 2014-05-27 12:13, Christoph Hellwig wrote:
>>> Here is my counter proposal that requeues via two lists and a work struct
>>> in the request_queue.  I've also tested it with scsi-mq.
>>>
>>
>> I like this, moves the state out of the request. But how about we
>> consolidate the two requeue requests lists, and just mark the request as
>> needing head insertion instead? Just add a cmd_flags flag, REQ_REQUEUE_HEAD
>> or something.
>
> That should be doable, just didn't like introducing even more flags.

Space is plenty big again now... The down side is that the splice trick 
wont work, but if we have more than a few requests on the requeue list, 
we're doing it wrong anyway.

-- 
Jens Axboe


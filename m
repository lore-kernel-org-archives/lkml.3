Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430AbaE0SxI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 14:53:08 -0400
Received: from verein.lst.de ([213.95.11.211]:60818 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654AbaE0SxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 14:53:05 -0400
Date: Tue, 27 May 2014 20:53:01 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Ming Lei <tom.leiming@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] block: mq flush: fix race between IPI handler and mq
	flush worker
Message-ID: <20140527185301.GA8466@lst.de>
References: <1400511950-18522-1-git-send-email-tom.leiming@gmail.com> <20140519151824.GA21762@lst.de> <CACVXFVNprzhEpXGKze=A4T2b-y35vXRxRTOUqpywu+Et=t37Kw@mail.gmail.com> <20140520152303.GA20352@lst.de> <CACVXFVNP--zj_-UtygxfXk7GvSXwKm2KMKFs=h9KsrL=ZzbWVQ@mail.gmail.com> <20140521053634.GA4764@lst.de> <CACVXFVO5znzYtPKMTPwx_2MU97xFZY+wHwm+R33T043SW4JHHw@mail.gmail.com> <20140527181305.GA7975@lst.de> <5384DB97.70606@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5384DB97.70606@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 12:38:15PM -0600, Jens Axboe wrote:
> On 2014-05-27 12:13, Christoph Hellwig wrote:
>> Here is my counter proposal that requeues via two lists and a work struct
>> in the request_queue.  I've also tested it with scsi-mq.
>>
>
> I like this, moves the state out of the request. But how about we 
> consolidate the two requeue requests lists, and just mark the request as 
> needing head insertion instead? Just add a cmd_flags flag, REQ_REQUEUE_HEAD 
> or something.

That should be doable, just didn't like introducing even more flags.

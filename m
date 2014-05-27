Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391AbaE0SiU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 14:38:20 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:46174 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237AbaE0SiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 14:38:17 -0400
Message-ID: <5384DB97.70606@kernel.dk>
Date: Tue, 27 May 2014 12:38:15 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>, Ming Lei <tom.leiming@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] block: mq flush: fix race between IPI handler and mq
 flush worker
References: <1400511950-18522-1-git-send-email-tom.leiming@gmail.com> <20140519151824.GA21762@lst.de> <CACVXFVNprzhEpXGKze=A4T2b-y35vXRxRTOUqpywu+Et=t37Kw@mail.gmail.com> <20140520152303.GA20352@lst.de> <CACVXFVNP--zj_-UtygxfXk7GvSXwKm2KMKFs=h9KsrL=ZzbWVQ@mail.gmail.com> <20140521053634.GA4764@lst.de> <CACVXFVO5znzYtPKMTPwx_2MU97xFZY+wHwm+R33T043SW4JHHw@mail.gmail.com> <20140527181305.GA7975@lst.de>
In-Reply-To: <20140527181305.GA7975@lst.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-05-27 12:13, Christoph Hellwig wrote:
> Here is my counter proposal that requeues via two lists and a work struct
> in the request_queue.  I've also tested it with scsi-mq.
>

I like this, moves the state out of the request. But how about we 
consolidate the two requeue requests lists, and just mark the request as 
needing head insertion instead? Just add a cmd_flags flag, 
REQ_REQUEUE_HEAD or something.

-- 
Jens Axboe


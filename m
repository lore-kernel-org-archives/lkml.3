Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683AbaISNHk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 09:07:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46400 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754085AbaISNHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 09:07:39 -0400
MIME-Version: 1.0
In-Reply-To: <541B105E.1030507@fb.com>
References: <1411055950-28657-1-git-send-email-ming.lei@canonical.com>
	<20140918163549.GB3950@lst.de>
	<541B105E.1030507@fb.com>
Date: Fri, 19 Sep 2014 21:07:35 +0800
Message-ID: <CACVXFVP18pgz03LSwab-n2tKMAT15JmuF7Eh_O+q9TOHmhj2Qw@mail.gmail.com>
Subject: Re: [PATCH] scsi-mq: fix hw queue hang caused by timeout
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <JBottomley@parallels.com>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Douglas Gilbert <dgilbert@interlog.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 1:03 AM, Jens Axboe <axboe@fb.com> wrote:
> On 2014-09-18 10:35, Christoph Hellwig wrote:
>>
>> On Thu, Sep 18, 2014 at 11:59:10PM +0800, Ming Lei wrote:
>>>
>>> If there are two requests or more timed out, the dispatch queue
>>> is put into stopped state and never be recoverd, and there
>>> is no such problem in non-mq mode.
>>>
>>> This patch trys to recover the stopped queue when the queue
>>> becomes unbusy, then the following retries can move on.
>>>
>>> Basically this patch maintains same behavior for this situation
>>> with non-mq mode.
>>
>>
>> This looks somewhat similar to the issues that Doug reported, and I
>> remember
>> when he was last running into boot problems it was timeout related, too.
>>
>> As far as the implementation is concerned I think the correct fix is
>> to clear the BLK_MQ_S_STOPPED queue flags in blk_mq_kick_requeue_list.
>
>
> Since that's the kick part of the requeue, auto-starting the queue for that
> makes a lot of sense. I say that's the way we go.

Yeah, that looks better.

But it doesn't work after the simple change, and I need to
investigate further.

Thanks,

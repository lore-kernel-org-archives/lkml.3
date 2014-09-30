Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519AbaI3SKY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 14:10:24 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:44815 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbaI3SKW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 14:10:22 -0400
MIME-Version: 1.0
X-Originating-IP: [80.196.35.44]
In-Reply-To: <alpine.LRH.2.03.1409301134580.4688@AMR>
References: <1412098195-30133-1-git-send-email-m@bjorling.me>
	<1412098195-30133-2-git-send-email-m@bjorling.me>
	<alpine.LRH.2.03.1409301134580.4688@AMR>
Date: Tue, 30 Sep 2014 20:10:21 +0200
Message-ID: <CAOu_J6kb8pQRzhUWD=JOhi1_=mxORUiL-isSaCfrxQ-yxOUepw@mail.gmail.com>
Subject: Re: [PATCH v13] NVMe: Convert to blk-mq
From: =?UTF-8?Q?Matias_Bj=C3=B8rling?= <m@bjorling.me>
To: Keith Busch <keith.busch@intel.com>
Cc: Matthew Wilcox <willy@linux.intel.com>,
        "Sam Bradshaw (sbradshaw)" <sbradshaw@micron.com>,
        Jens Axboe <axboe@fb.com>, Ming Lei <tom.leiming@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        Rob Nelson <rlnelson@google.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-nvme <linux-nvme@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 7:42 PM, Keith Busch <keith.busch@intel.com> wrote:
> On Tue, 30 Sep 2014, Matias Bjørling wrote:
>>
>> @@ -1967,27 +1801,30 @@ static struct nvme_ns *nvme_alloc_ns(struct
>> nvme_dev *dev, unsigned nsid,
>> {
>
> ...
>>
>> -       ns->queue->queue_flags = QUEUE_FLAG_DEFAULT;
>> +       queue_flag_set_unlocked(QUEUE_FLAG_DEFAULT, ns->queue);
>
>
> Instead of the above, you want
>
> +       ns->queue->queue_flags |= QUEUE_FLAG_DEFAULT;
>
> I only caught it because of the fun dm-mpath attempt with nvme and
> blk-mq. Or maybe we don't want to include "QUEUE_FLAG_STACKABLE" right
> now (part of the default flags) because it will kernel crash if you're
> using dm-multipath with a blk-mq driver today.
>

Great find. We should properly add a bunch of patches that add the
necessary support after the patch has gone in. I have a feeling that
there is a lot of interesting corner cases for getting stackable to
work.

> Otherwise, looks great!

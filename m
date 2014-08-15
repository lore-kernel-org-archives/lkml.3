Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484AbaHOOcs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 10:32:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54872 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbaHOOcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 10:32:46 -0400
MIME-Version: 1.0
In-Reply-To: <20140815131137.GA31079@infradead.org>
References: <1408031441-31156-1-git-send-email-ming.lei@canonical.com>
	<53ECE998.8070407@kernel.dk>
	<CACVXFVNGaZ0C1cA5fq0UnEBDPPMpBDqF2PxNk4TAOOCGL3jh5g@mail.gmail.com>
	<20140815131137.GA31079@infradead.org>
Date: Fri, 15 Aug 2014 22:32:43 +0800
Message-ID: <CACVXFVPLW-36aJV83L-Jfcp8MfW+XtZObM=sN-_W0ZV5xznEbw@mail.gmail.com>
Subject: Re: [PATCH v1 0/9] block & aio: kernel aio and loop mq conversion
From: Ming Lei <ming.lei@canonical.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Kleikamp <dave.kleikamp@oracle.com>, Zach Brown <zab@zabbo.net>,
        Benjamin LaHaise <bcrl@kvack.org>, Kent Overstreet <kmo@daterainc.com>,
        "open list:AIO" <linux-aio@kvack.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/15/14, Christoph Hellwig <hch@infradead.org> wrote:
> On Fri, Aug 15, 2014 at 08:59:56PM +0800, Ming Lei wrote:
>> Your concern is right, previous I thought that mq conversion wouldn't
>> improve
>> throughput, but I did ignore workqueue's concurrency management, it
>> turns out blk-mq conversion can improvment throughput close to 10 times
>> in
>> my test(loop over virtio-blk which is backed by one image on SSD).  It is
>> like
>> POSIX style AIO after mq conversion thanks to workqueue, and I need to
>> update the performance data in V2.
>>
>> Actually kernel AIO needn't such high concurrency.
>
> Can you juse send a loop blk-mq conversion for now?  I think that's

OK.

> a bit less controversial than the new kernel aio APIs, and keeping the
> two separate is a good idea in general.

Exactly, the two should be perfect pair for loop block, IMO.

Thanks,
-- 
Ming Lei

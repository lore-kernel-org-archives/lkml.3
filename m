Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbaKDVsv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 16:48:51 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:57004 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbaKDVst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 16:48:49 -0500
Message-ID: <545949BF.1080503@kernel.dk>
Date: Tue, 04 Nov 2014 14:48:47 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, Christian Borntraeger <borntraeger@de.ibm.com>
CC: Kent Overstreet <kmo@daterainc.com>, Christoph Hellwig <hch@lst.de>,
        "linux-kernel@vger.kernel.org >> Linux Kernel Mailing List" 
	<linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>
Subject: Re: [PATCH block/for-linus] blk-mq: make mq_queue_reinit_notify()
 freeze queues in parallel
References: <544FF00B.8050403@de.ibm.com> <20141028200055.GA8205@htj.dyndns.org> <544FFAA7.1060705@de.ibm.com> <20141028202255.GB8205@htj.dyndns.org> <544FFC9C.60908@de.ibm.com> <20141028203040.GD8205@htj.dyndns.org> <20141104185227.GH14459@htj.dyndns.org>
In-Reply-To: <20141104185227.GH14459@htj.dyndns.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-11-04 11:52, Tejun Heo wrote:
> q->mq_usage_counter is a percpu_ref which is killed and drained when
> the queue is frozen.  On a CPU hotplug event, blk_mq_queue_reinit()
> which involves freezing the queue is invoked on all existing queues.
> Because percpu_ref killing and draining involve a RCU grace period,
> doing the above on one queue after another may take a long time if
> there are many queues on the system.
>
> This patch splits out initiation of freezing and waiting for its
> completion, and updates blk_mq_queue_reinit_notify() so that the
> queues are frozen in parallel instead of one after another.  Note that
> freezing and unfreezing are moved from blk_mq_queue_reinit() to
> blk_mq_queue_reinit_notify().
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
> Christian, can you please verify that this resolves the latency issue
> that you're seeing?  Jens, can you please route this patch once
> Christian confirms it?

Will queue up for 3.18.

-- 
Jens Axboe


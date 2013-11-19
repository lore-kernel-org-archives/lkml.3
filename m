Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143Ab3KSQRJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 11:17:09 -0500
Received: from merlin.infradead.org ([205.233.59.134]:41890 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab3KSQRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 11:17:07 -0500
Message-ID: <528B8EE6.7030005@kernel.dk>
Date: Tue, 19 Nov 2013 09:16:38 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org
Subject: Re: [Regression x2, 3.13-git] virtio block mq hang, iostat busted
 on virtio devices
References: <20131119080218.GJ11434@dastard> <20131119103635.GA9223@infradead.org> <20131119160509.GB21343@kernel.dk> <20131119160949.GA24191@infradead.org>
In-Reply-To: <20131119160949.GA24191@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2013 09:09 AM, Christoph Hellwig wrote:
> On Tue, Nov 19, 2013 at 09:05:09AM -0700, Jens Axboe wrote:
>> I have queued up the below.
> 
> I don't think that will work.  We only set QUEUE_FLAG_IO_STAT in
> blk_init_allocated_queue, which doesn't get called from
> blk_mq_init_queue.  That being said I really don't understand why we
> need to have the QUEUE_FLAG_IO_STAT flag at all.

Hmm good point, we need to init those flags there too. I'll get this
properly tested.

Back when the accounting was initially made optional, there was about a
1% reduction in overhead with it off. That's why the tunable is there.

-- 
Jens Axboe


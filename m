Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380Ab3KTQUs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 11:20:48 -0500
Received: from merlin.infradead.org ([205.233.59.134]:45921 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050Ab3KTQUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 11:20:44 -0500
Message-ID: <528CE13D.3000907@kernel.dk>
Date: Wed, 20 Nov 2013 09:20:13 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org
Subject: Re: [Regression x2, 3.13-git] virtio block mq hang, iostat busted
 on virtio devices
References: <20131119080218.GJ11434@dastard> <20131119201531.GA4094@kernel.dk> <20131119212042.GB4094@kernel.dk> <20131119213429.GQ11434@dastard> <528BDB97.8090608@kernel.dk> <20131120080440.GA13147@infradead.org>
In-Reply-To: <20131120080440.GA13147@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2013 01:04 AM, Christoph Hellwig wrote:
> On Tue, Nov 19, 2013 at 02:43:51PM -0700, Jens Axboe wrote:
>> No, the nr_requests isn't actually relevant in the blk-mq context, the
>> driver sets its own depth. For the above, it's 64 normal commands, and 2
>> reserved. The reserved would be for a flush, for instance. If someone
>> attempts to queue more than the allocated number of requests, it'll stop
>> the blk-mq queue and kick things into gear on the virtio side. Then when
>> requests complete, we start the queue again.
> 
> Btw, any reason we lowerered the queue depth from 128 to 64 in
> virtio-blk?

No, we can easily bump it to 128 again, I think it was a leftover from
where it had more queues and testing.

-- 
Jens Axboe


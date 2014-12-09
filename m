Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464AbaLIQGq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 11:06:46 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:45530 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093AbaLIQGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 11:06:45 -0500
Message-ID: <54871E12.7010301@kernel.dk>
Date: Tue, 09 Dec 2014 09:06:42 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Bart Van Assche <bvanassche@acm.org>
CC: Christoph Hellwig <hch@lst.de>, Robert Elliott <elliott@hp.com>,
        Ming Lei <ming.lei@canonical.com>,
        Alexander Gordeev <agordeev@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/6] blk-mq: Micro-optimize bt_get()
References: <54871BD0.8020305@acm.org> <54871C74.4080609@acm.org>
In-Reply-To: <54871C74.4080609@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2014 08:59 AM, Bart Van Assche wrote:
> Remove a superfluous finish_wait() call. Convert the two bt_wait_ptr()
> calls into a single call.

I had to double check this, but looks OK to me. And it's better than a 
micro-optimization, should be a nice win for the tag contended case.


-- 
Jens Axboe


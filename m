Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716AbaHOQg3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 12:36:29 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:34470 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbaHOQg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 12:36:27 -0400
Message-ID: <53EE370D.1060106@kernel.dk>
Date: Fri, 15 Aug 2014 10:36:29 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>, Ming Lei <ming.lei@canonical.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Dave Kleikamp <dave.kleikamp@oracle.com>, Zach Brown <zab@zabbo.net>,
        Benjamin LaHaise <bcrl@kvack.org>, Kent Overstreet <kmo@daterainc.com>,
        linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v1 5/9] block: loop: convert to blk-mq
References: <1408031441-31156-1-git-send-email-ming.lei@canonical.com> <1408031441-31156-6-git-send-email-ming.lei@canonical.com> <20140815163111.GA16652@infradead.org>
In-Reply-To: <20140815163111.GA16652@infradead.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2014 10:31 AM, Christoph Hellwig wrote:
>> +static void loop_queue_work(struct work_struct *work)
> 
> Offloading work straight to a workqueue dosn't make much sense
> in the blk-mq model as we'll usually be called from one.  If you
> need to avoid the cases where we are called directly a flag for
> the blk-mq code to always schedule a workqueue sounds like a much
> better plan.

That's a good point - would clean up this bit, and be pretty close to a
one-liner to support in blk-mq for the drivers that always need blocking
context.

-- 
Jens Axboe


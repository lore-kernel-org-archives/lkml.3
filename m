Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660Ab3F0OVb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 10:21:31 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58474 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766Ab3F0OV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 10:21:29 -0400
Date: Thu, 27 Jun 2013 16:21:27 +0200
From: Jens Axboe <axboe@kernel.dk>
To: xun ni <ni.xun.intel@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Block Layer Multi queue question
Message-ID: <20130627142127.GZ25599@kernel.dk>
References: <CANLX1YGQqbbNb5hgoHtcFS27KJmLtnC+JY6CnWsSBR3+KLO60g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANLX1YGQqbbNb5hgoHtcFS27KJmLtnC+JY6CnWsSBR3+KLO60g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27 2013, xun ni wrote:
> Hello, Axboe:
> 
>    I read your article about the block io layer Multi-queue support SSD on
> the multi-core systems. And i do some experiment on raid5 which consist of
> 5 intel ssd disks. I get code from linux-block and checked out mq. After
> apply kent's patch , the raid5 system works. I tested the raid with FIO and
> find that the performance is not growing. 4k read iops down from 82k to
> 76k. 4k random write iops down from 14k to 9k. The latency is also down
> about 8%
>    So my question is that any configuration or modification is needed
> before testing the raid5 so that the Multi-queue method works and
> performance increase?

raid5/md isn't blk-mq aware at all. So that code path isn't really
changed at all. If you are seeing a change in performance, that must be
because the baseline is different (blk-mq sits on top of 3.10-rc, don't
know what you are comparing to). You should try 3.10-rc7 and see how
that fares, and report if you are seeing a performance degredation.

-- 
Jens Axboe


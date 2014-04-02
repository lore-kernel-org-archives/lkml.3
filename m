Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101AbaDBAQ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 20:16:27 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:62941 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbaDBAQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 20:16:24 -0400
Message-ID: <533B56D5.5070803@bjorling.me>
Date: Tue, 01 Apr 2014 17:16:21 -0700
From: Matias Bjorling <m@bjorling.me>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@fb.com>
CC: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [RFC] blk-mq: support for shared tags
References: <1396277175-21382-1-git-send-email-hch@lst.de>
In-Reply-To: <1396277175-21382-1-git-send-email-hch@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2014 07:46 AM, Christoph Hellwig wrote:
> This series adds support for sharing tags (and thus requests) between
> multiple request_queues.  We'll need this for SCSI, and I think Martin
> also wants something similar for nvme.
> 
> Besides the mess with request contructors/destructors the major RFC here
> is how the blk_mq_alloc_shared_tags API should look like.  For now I've
> been lazy and reused struct blk_mq_reg, but that feels a bit cumbersome.
> Either a separate blk_mq_tags_reg or just passing the few arguments directly
> would work fine for me.
> 

Hi Christoph,

Can you rebase it on top of 3.14. I have trouble applying it for testing.

For nvme, there's need for two separate types of queues. The admin queue
(before initializing blk-mq) and the actual hardware queues.

Should we allow the driver to get/put tags before initializing blk-mq?
Or let drivers implement their own framework?

Thanks,
Matias

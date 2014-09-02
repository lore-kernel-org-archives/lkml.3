Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbaIBQYj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 12:24:39 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:33701 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbaIBQYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 12:24:38 -0400
Message-ID: <5405EF48.9070601@kernel.dk>
Date: Tue, 02 Sep 2014 10:24:40 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Ming Lei <ming.lei@canonical.com>, linux-kernel@vger.kernel.org
CC: Kick In <pierre-andre.morey@canonical.com>,
        Chris J Arges <chris.j.arges@canonical.com>
Subject: Re: [PATCH] blk-merge: fix blk_recount_segments
References: <1409670180-17352-1-git-send-email-ming.lei@canonical.com>
In-Reply-To: <1409670180-17352-1-git-send-email-ming.lei@canonical.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2014 09:02 AM, Ming Lei wrote:
> QUEUE_FLAG_NO_SG_MERGE is set at default for blk-mq devices,
> so bio->bi_phys_segment computed may be bigger than
> queue_max_segments(q) for blk-mq devices, then drivers will
> fail to handle the case, for example, BUG_ON() in
> virtio_queue_rq() can be triggerd for virtio-blk:
> 
> 	https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1359146
> 
> This patch fixes the issue by ignoring the QUEUE_FLAG_NO_SG_MERGE
> flag if the computed bio->bi_phys_segment is bigger than
> queue_max_segments(q), and the regression is caused by commit
> 05f1dd53152173(block: add queue flag for disabling SG merging).
> 
> Reported-by: Kick In <pierre-andre.morey@canonical.com>
> Tested-by: Chris J Arges <chris.j.arges@canonical.com>
> Signed-off-by: Ming Lei <ming.lei@canonical.com>

Thanks Ming, this looks nice and clean. Will apply for 3.17.

-- 
Jens Axboe


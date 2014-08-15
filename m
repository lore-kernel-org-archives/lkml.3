Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508AbaHOQTa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 12:19:30 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:35772 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbaHOQT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 12:19:28 -0400
Message-ID: <53EE3312.2070108@kernel.dk>
Date: Fri, 15 Aug 2014 10:19:30 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Ming Lei <ming.lei@canonical.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Kleikamp <dave.kleikamp@oracle.com>
CC: Zach Brown <zab@zabbo.net>, Benjamin LaHaise <bcrl@kvack.org>,
        Christoph Hellwig <hch@infradead.org>,
        Kent Overstreet <kmo@daterainc.com>, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v1 4/9] blk-mq: introduce init_flush_rq_fn callback in
 'blk_mq_ops'
References: <1408031441-31156-1-git-send-email-ming.lei@canonical.com> <1408031441-31156-5-git-send-email-ming.lei@canonical.com>
In-Reply-To: <1408031441-31156-5-git-send-email-ming.lei@canonical.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2014 09:50 AM, Ming Lei wrote:
> Currently pdu of the flush rq is simlpy copied from another rq,
> it isn't enough to initialize pointer field well, so introduce
> the callback for driver to handle the case easily.

This is the only patch I don't really like. Can't we make do with
calling ->init_request() for this instead of having to add another
(weird) hook?

-- 
Jens Axboe


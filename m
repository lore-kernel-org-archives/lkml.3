Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756381Ab3LaQi4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 11:38:56 -0500
Received: from merlin.infradead.org ([205.233.59.134]:49114 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855Ab3LaQiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 11:38:54 -0500
Date: Tue, 31 Dec 2013 09:38:51 -0700
From: Jens Axboe <axboe@kernel.dk>
To: Ming Lei <tom.leiming@gmail.com>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v1 1/5] block: blk-mq: avoid initializing request during
 its completion
Message-ID: <20131231163851.GJ21823@kernel.dk>
References: <1388064698-27344-1-git-send-email-tom.leiming@gmail.com>
 <1388064698-27344-2-git-send-email-tom.leiming@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1388064698-27344-2-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 26 2013, Ming Lei wrote:
> One problem is that request->start_time/start_time_ns could be
> set as wrong.
> 
> Also it is normal to intialize one data structure just after its
> allocation.
> 
> So move the initialization out of its completion path.

It's done that way because of presumed cache hotness on completion,
since we just touched a lot of the members. Lets just fix the start time
issue by itself.

-- 
Jens Axboe


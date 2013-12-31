Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904Ab3LaQNO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 11:13:14 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48496 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639Ab3LaQNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 11:13:13 -0500
Message-ID: <52C2ECF1.3020808@kernel.dk>
Date: Tue, 31 Dec 2013 09:12:33 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Shaohua Li <shli@kernel.org>, linux-kernel@vger.kernel.org
CC: hch@infradead.org, kmo@daterainc.com
Subject: Re: [patch 2/2]blk-mq: Don't reserve a tag for flush request
References: <20131231033850.GB31994@kernel.org>
In-Reply-To: <20131231033850.GB31994@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/30/2013 08:38 PM, Shaohua Li wrote:
> 
> Reserving a tag (request) for flush to avoid dead lock is a overkill. tag is
> valuable resource. We can track flush request number and disallow too many
> pending flush requests allocated. With this patch,
> blk_mq_alloc_request_pinned() could do a busy nop (but not a dead loop) if too
> pending requests are allocated and new flush request is allocating. But this
> should not be a problem, too many pending flush requests are very rare case.
> 
> I verified this can fix the deadlock caused by too many pending flush requests.

I think this looks pretty good, and it's a lot better than the hack that
is currently in place. The atomic inc/dec should be a noop on a per-hctx
basis, especially when it's only per-flush...

I'll get this queued up, with the ida fix too.

-- 
Jens Axboe


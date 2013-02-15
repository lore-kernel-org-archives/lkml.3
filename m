Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935929Ab3BOPpt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 10:45:49 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:50418
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752206Ab3BOPps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 10:45:48 -0500
Date: Fri, 15 Feb 2013 16:44:21 +0100
From: Jens Axboe <axboe@kernel.dk>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        devel@openvz.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] block: account iowait time when waiting for
 completion of IO request
Message-ID: <20130215154421.GA6131@kernel.dk>
References: <d5e5c32b045e448072b3a4b77cd6557408b77103.1360851174.git.vdavydov@parallels.com>
 <d1fdb105fe23f979871b92c4b4d3dd374146e337.1360851174.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d1fdb105fe23f979871b92c4b4d3dd374146e337.1360851174.git.vdavydov@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14 2013, Vladimir Davydov wrote:
> Using wait_for_completion() for waiting for a IO request to be executed
> results in wrong iowait time accounting. For example, a system having
> the only task doing write() and fdatasync() on a block device can be
> reported being idle instead of iowaiting as it should because
> blkdev_issue_flush() calls wait_for_completion() which in turn calls
> schedule() that does not increment the iowait proc counter and thus does
> not turn on iowait time accounting.
> 
> The patch makes block layer use wait_for_completion_io() instead of
> wait_for_completion() where appropriate to account iowait time
> correctly.

Thanks, applied both for 3.9 (with Ingos ack).

-- 
Jens Axboe


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589AbbAETmK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 14:42:10 -0500
Received: from verein.lst.de ([213.95.11.211]:55491 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754367AbbAETmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 14:42:08 -0500
Date: Mon, 5 Jan 2015 20:42:03 +0100
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Sasha Levin <sasha.levin@oracle.com>, bvanassche@acm.org, hare@suse.de,
        JBottomley@parallels.com, linux-scsi@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: Re: scsi: non atomic allocation in mempool_alloc in atomic context
Message-ID: <20150105194203.GA32107@lst.de>
References: <54A43CFB.2080705@oracle.com> <20150105091516.GA22226@lst.de> <54AADF6A.6090100@kernel.dk> <20150105193213.GA31955@lst.de> <54AAE81C.2080402@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54AAE81C.2080402@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2015 at 12:38:04PM -0700, Jens Axboe wrote:
> That was true in earlier kernels as well, going back a few versions at
> least, preempt was disabled on calling __blk_mq_run_hw_queue(). Just
> checked, and 3.16 and later have that as the behaviour. The only change
> in 3.19 some shuffling around to avoid double preempt_disable in some
> cases, it's now using get_cpu() and friends.
> 
> So we probably want do mark that as stable so we reach back to when
> scsi-mq was added, unless the originally referenced patch getting rid of
> the gfp_t mask didn't have the issue.

Before that commit we always passed down GFP_ATOMIC, so we'll only
need the patch for 3.19.

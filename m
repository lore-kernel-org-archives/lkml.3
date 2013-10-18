Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603Ab3JRP6e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 11:58:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:47735 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754542Ab3JRP6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 11:58:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,523,1378882800"; 
   d="scan'208";a="413316269"
Date: Fri, 18 Oct 2013 11:48:01 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: Matias Bjorling <m@bjorling.me>
Cc: axboe@kernel.dk, keith.busch@intel.com, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org
Subject: Re: [PATCH 0/3] Convert from bio-based to blk-mq v2
Message-ID: <20131018154801.GQ16716@linux.intel.com>
References: <1382102062-22270-1-git-send-email-m@bjorling.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382102062-22270-1-git-send-email-m@bjorling.me>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 18, 2013 at 03:14:19PM +0200, Matias Bjorling wrote:
> Performance study:
> 
> System: HGST Research NVMe prototype, Haswell i7-4770 3.4Ghz, 32GB 1333Mhz

I don't have one of these.  Can you provide more details about it,
such as:
 - How many I/O queues does it have?
 - Are the interrupts correctly bound to the CPUs (for both sets of tests)?
   The driver isn't allowed to set the irq affinity correctly itself;
   it can only set a hint and userspace (eg irqbalance) has to set the
   affinity correctly
 - Does it support interrupt coalescing?  If so, have you managed to do any
   testing using that feature?

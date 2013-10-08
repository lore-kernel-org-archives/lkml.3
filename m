Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444Ab3JHNK5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 09:10:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:56469 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753828Ab3JHNK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 09:10:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1056,1371106800"; 
   d="scan'208";a="389732478"
Date: Tue, 8 Oct 2013 09:10:36 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: Matias =?iso-8859-1?Q?Bj=F8rling?= <m@bjorling.me>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org
Subject: Re: [PATCH RFC 0/2] Convert from bio-based to blk-mq
Message-ID: <20131008131036.GC7422@linux.intel.com>
References: <1381224862-5299-1-git-send-email-m@bjorling.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1381224862-5299-1-git-send-email-m@bjorling.me>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 11:34:20AM +0200, Matias Bjørling wrote:
> The nvme driver implements itself as a bio-based driver. This primarily because
> of high lock congestion for high-performance nvm devices. To remove the
> congestion, a multi-queue block layer is being implemented.

Um, no.  You'll crater performance by adding another memory allocation
(of the struct request).  multi-queue is not the solution.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932605AbaHVRsu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 13:48:50 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:34704 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932469AbaHVRst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 13:48:49 -0400
Date: Fri, 22 Aug 2014 10:48:48 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Keith Busch <keith.busch@intel.com>
Cc: linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
        axboe@kernel.dk, willy@linux.intel.com, nilesh.choudhury@oracle.com,
        indraneel.m@samsung.com, shiro.itou@outlook.com
Subject: Re: [PATCH] fs/block_dev.c: Use hd_part to find block inodes
Message-ID: <20140822174848.GA11819@infradead.org>
References: <1408724896-3671-1-git-send-email-keith.busch@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408724896-3671-1-git-send-email-keith.busch@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 10:28:16AM -0600, Keith Busch wrote:
> When using the GENHD_FL_EXT_DEVT disk flags, a newly added device may
> be assigned the same major/minor as one that was previously removed but
> opened, and the pesky userspace refuses to close it!

Which means life time rules for those dev_t allocations are broken.
Please fix it to not release the dev_t until the device isn't referenced
at all.


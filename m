Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab3GIOc1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 10:32:27 -0400
Received: from mga03.intel.com ([143.182.124.21]:21050 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753656Ab3GIOcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 10:32:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1028,1363158000"; 
   d="scan'208";a="362590308"
Date: Tue, 9 Jul 2013 22:32:17 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] writeback: Do not sort b_io list only because of block
 device inode
Message-ID: <20130709143217.GA6944@localhost>
References: <1372061269-16663-1-git-send-email-jack@suse.cz>
 <20130708160602.GA14739@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130708160602.GA14739@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 08, 2013 at 06:06:02PM +0200, Jan Kara wrote:
> On Mon 24-06-13 10:07:49, Jan Kara wrote:
> > It is very likely that block device inode will be part of BDI dirty list
> > as well. However it doesn't make sence to sort inodes on the b_io list
> > just because of this inode (as it contains buffers all over the device
> > anyway). So save some CPU cycles which is valuable since we hold relatively
> > contented wb->list_lock.
>   Ping? Fengguang, can you merge the patch please?

OK! It's a good optimization to have.

Thanks,
Fengguang

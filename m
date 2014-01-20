Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752353AbaATNwj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 08:52:39 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:40036 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbaATNwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 08:52:36 -0500
Date: Mon, 20 Jan 2014 05:52:31 -0800
From: Christoph Hellwig <hch@infradead.org>
To: shaobingqing <shaobingqing@bwstor.com.cn>
Cc: trond.myklebust@primarydata.com, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NFSv4.1: PNFS_BLOCK_NONE_DATA should be handle properly
 in bl_add_merge_extent?
Message-ID: <20140120135231.GA17536@infradead.org>
References: <n>
 <1390212448-21354-1-git-send-email-shaobingqing@bwstor.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390212448-21354-1-git-send-email-shaobingqing@bwstor.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 06:07:28PM +0800, shaobingqing wrote:
> In the current code, extents would not delete from the bl_extents list when 
> lseg is removed from layout. Now one extent's lseg is deleted and its type 
> is PNFS_BLOCK_NONE_DATA, while a layoutget request get a extent with the same
> range and its type is PNFS_BLOCK_NONE_DATA. In this situation the function
> bl_add_merge_extent will return -EIO. Furthermore, the READ op which request
> the layout will be execute in band. This perhaps not only degrade performance,
> but also result in data unconsistency. 

I think the right fix is to remove the extent when the lseg is removed.
I can't see how the current pnfs block client could work in the case
where a file is first truncated and then later written into again.

This should be easily reproducable using fsx, btw.


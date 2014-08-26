Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932880AbaHZOSb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 10:18:31 -0400
Received: from verein.lst.de ([213.95.11.211]:43564 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755389AbaHZOS2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 10:18:28 -0400
Date: Tue, 26 Aug 2014 16:18:26 +0200
From: Christoph Hellwig <hch@lst.de>
To: Sabrina Dubroca <sd@queasysnail.net>
Cc: hch@lst.de, linux-kernel@vger.kernel.org, axboe@kernel.dk
Subject: Re: [PATCH] block: fix error handling in sg_io
Message-ID: <20140826141826.GA750@lst.de>
References: <20140826135143.GA30461@lst.de> <1409062442-32766-1-git-send-email-sd@queasysnail.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409062442-32766-1-git-send-email-sd@queasysnail.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 04:14:02PM +0200, Sabrina Dubroca wrote:
> Before commit 2cada584b200 ("block: cleanup error handling in sg_io"),
> we had ret = 0 before entering the last big if block of sg_io.
> 
> Since 2cada584b200, ret = -EFAULT, which breaks hdparm:
> 
> /dev/sda:
>  setting Advanced Power Management level to 0xc8 (200)
>  HDIO_DRIVE_CMD failed: Bad address
>  APM_level      = 128
> 
> Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
> Fixes: 2cada584b200 ("block: cleanup error handling in sg_io")

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

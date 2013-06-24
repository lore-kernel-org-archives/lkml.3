Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751285Ab3FXWvd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 18:51:33 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:45088 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890Ab3FXWvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 18:51:32 -0400
Date: Mon, 24 Jun 2013 15:51:26 -0700
From: Tejun Heo <tj@kernel.org>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
        Jens Axboe <axboe@kernel.dk>, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>,
        Lin Ming <ming.m.lin@intel.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] block:Remove extra condition in end of disk check
Message-ID: <20130624225126.GO1918@mtj.dyndns.org>
References: <20130623171711.7127.16248.sendpatchset@codeblue.in.ibm.com>
 <51C84E94.8020100@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51C84E94.8020100@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 24, 2013 at 07:20:12PM +0530, Raghavendra K T wrote:
> >@@ -1656,7 +1656,7 @@ static inline int bio_check_eod(struct bio *bio, unsigned int nr_sectors)
> >  	if (maxsector) {
> >  		sector_t sector = bio->bi_sector;
> >
> >-		if (maxsector < nr_sectors || maxsector - nr_sectors < sector) {
> >+		if (maxsector - nr_sectors < sector) {

If maxsector < nr_sectors, the subtraction will underflow making it a
very large number and fail to detect the invalid condition, no?

Thanks.

-- 
tejun

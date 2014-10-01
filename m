Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115AbaJAPHO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 11:07:14 -0400
Received: from mail.kernel.org ([198.145.19.201]:33121 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469AbaJAPHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 11:07:12 -0400
Date: Wed, 1 Oct 2014 08:07:14 -0700
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Chao Yu <chao2.yu@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [f2fs-dev] [PATCH 2/3] f2fs: introduce FITRIM in f2fs_ioctl
Message-ID: <20141001150714.GB24084@jaegeuk-mac02.hsd1.ca.comcast.net>
References: <1411447990-37919-1-git-send-email-jaegeuk@kernel.org>
 <1411447990-37919-2-git-send-email-jaegeuk@kernel.org>
 <006001cfdc74$178dcdc0$46a96940$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <006001cfdc74$178dcdc0$46a96940$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 02:01:58PM +0800, Chao Yu wrote:
> > -----Original Message-----
> > From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> > Sent: Tuesday, September 23, 2014 12:53 PM
> > To: linux-kernel@vger.kernel.org; linux-fsdevel@vger.kernel.org;
> > linux-f2fs-devel@lists.sourceforge.net
> > Cc: Jaegeuk Kim
> > Subject: [f2fs-dev] [PATCH 2/3] f2fs: introduce FITRIM in f2fs_ioctl
> > 
> > This patch introduces FITRIM in f2fs_ioctl.
> > In this case, f2fs will issue small discards and prefree discards as many as
> > possible for the given area.
> > 
> > Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> 
> Looks good!
> 
> Reviewed-by: Chao Yu <chao2.yu@samsung.com>
> 
> > +
> >  	/* zero block will be discarded through the prefree list */
> >  	if (!se->valid_blocks || se->valid_blocks == max_blocks)
> >  		return;
> > 
> > +	dmap = kzalloc(SIT_VBLOCK_MAP_SIZE, GFP_KERNEL);
> 
> We can afford 64 bytes allocation in stack, how about altering dmap to a local
> array to reduce memory pressure at that moment and avoid delay of allocation?

It's not a big deal.
Fixed.
Thanks,

> 
> > +	if (!dmap)
> > +		return;
> > +

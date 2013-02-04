Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab3BDDmM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 22:42:12 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:42992 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816Ab3BDDmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 22:42:10 -0500
X-AuditID: 9c930197-b7ca4ae000006ba8-4c-510f2e10ae53
Date: Mon, 4 Feb 2013 12:42:08 +0900
From: Minchan Kim <minchan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, jmarchan@redhat.com
Subject: Re: [PATCH v6 4/4] zram: get rid of lockdep warning
Message-ID: <20130204034208.GF2688@blaptop>
References: <1359513702-18709-1-git-send-email-minchan@kernel.org>
 <1359513702-18709-4-git-send-email-minchan@kernel.org>
 <20130204015333.GA6548@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130204015333.GA6548@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Sun, Feb 03, 2013 at 05:53:33PM -0800, Greg Kroah-Hartman wrote:
> On Wed, Jan 30, 2013 at 11:41:42AM +0900, Minchan Kim wrote:
> > Lockdep complains about recursive deadlock of zram->init_lock.
> > [1] made it false positive because we can't request IO to zram
> > before setting disksize. Anyway, we should shut lockdep up to
> > avoid many reporting from user.
> > 
> > [1] : zram: force disksize setting before using zram
> > 
> > Acked-by: Jerome Marchand <jmarchand@redhat.com>
> > Acked-by: Nitin Gupta <ngupta@vflare.org>
> > Signed-off-by: Minchan Kim <minchan@kernel.org>
> > ---
> >  drivers/staging/zram/zram_drv.c   |  189 +++++++++++++++++++------------------
> >  drivers/staging/zram/zram_drv.h   |   12 ++-
> >  drivers/staging/zram/zram_sysfs.c |   11 ++-
> >  3 files changed, 116 insertions(+), 96 deletions(-)
> 
> This patch fails to apply to my staging-next branch, but the three
> others did, so I took them.  Please refresh this one and resend if you
> want it applied.

We must have missed each other.
A few hours ago, I sent to you v7 based on next-20130202.
https://lkml.org/lkml/2013/2/3/319

v7 includes acks of Jerome and resolve conflict with latest staging.
I believe it is okay to apply your tree.

Please reapply v7 instead of v6.

Thanks.
> 
> thanks,
> 
> greg k-h
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Kind regards,
Minchan Kim

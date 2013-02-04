Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab3BDDsF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 22:48:05 -0500
Received: from mail.kernel.org ([198.145.19.201]:49997 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753759Ab3BDDsB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 22:48:01 -0500
Date: Sun, 3 Feb 2013 19:50:13 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Minchan Kim <minchan@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, jmarchan@redhat.com
Subject: Re: [PATCH v6 4/4] zram: get rid of lockdep warning
Message-ID: <20130204035013.GA13954@kroah.com>
References: <1359513702-18709-1-git-send-email-minchan@kernel.org>
 <1359513702-18709-4-git-send-email-minchan@kernel.org>
 <20130204015333.GA6548@kroah.com>
 <20130204034208.GF2688@blaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130204034208.GF2688@blaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2013 at 12:42:08PM +0900, Minchan Kim wrote:
> Hi Greg,
> 
> On Sun, Feb 03, 2013 at 05:53:33PM -0800, Greg Kroah-Hartman wrote:
> > On Wed, Jan 30, 2013 at 11:41:42AM +0900, Minchan Kim wrote:
> > > Lockdep complains about recursive deadlock of zram->init_lock.
> > > [1] made it false positive because we can't request IO to zram
> > > before setting disksize. Anyway, we should shut lockdep up to
> > > avoid many reporting from user.
> > > 
> > > [1] : zram: force disksize setting before using zram
> > > 
> > > Acked-by: Jerome Marchand <jmarchand@redhat.com>
> > > Acked-by: Nitin Gupta <ngupta@vflare.org>
> > > Signed-off-by: Minchan Kim <minchan@kernel.org>
> > > ---
> > >  drivers/staging/zram/zram_drv.c   |  189 +++++++++++++++++++------------------
> > >  drivers/staging/zram/zram_drv.h   |   12 ++-
> > >  drivers/staging/zram/zram_sysfs.c |   11 ++-
> > >  3 files changed, 116 insertions(+), 96 deletions(-)
> > 
> > This patch fails to apply to my staging-next branch, but the three
> > others did, so I took them.  Please refresh this one and resend if you
> > want it applied.
> 
> We must have missed each other.

Yes, I was on a flight with no email :)

> A few hours ago, I sent to you v7 based on next-20130202.
> https://lkml.org/lkml/2013/2/3/319
> 
> v7 includes acks of Jerome and resolve conflict with latest staging.
> I believe it is okay to apply your tree.
> 
> Please reapply v7 instead of v6.

Please just send the one patch I need to apply here, I added Jerome's
acks to the previous patches already.

thanks,

greg k-h

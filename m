Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757365AbaHGFgH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 01:36:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41276 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757241AbaHGFgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 01:36:05 -0400
Date: Wed, 6 Aug 2014 22:35:30 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: A Raghavendra Rao <raghav3276@gmail.com>
Cc: peter.p.waskiewicz.jr@intel.com, c@24.io, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, A Raghavendra Rao <arrao@cdac.in>
Subject: Re: [PATCH] Staging: rtl8192u: fix sparse warnings in r8192U_core.c
Message-ID: <20140807053530.GB5754@kroah.com>
References: <1407386447-16308-1-git-send-email-arrao@cdac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407386447-16308-1-git-send-email-arrao@cdac.in>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2014 at 10:10:47AM +0530, A Raghavendra Rao wrote:
> Fix the following sparse warnings:
> drivers/staging/rtl8192u/r8192U_core.c:670:6: warning: symbol 'dump_eprom'
> was not declared. Should it be static?
> drivers/staging/rtl8192u/r8192U_core.c:1556:14: warning: symbol
> 'txqueue2outpipe' was not declared. Should it be static?
> drivers/staging/rtl8192u/r8192U_core.c:4876:5: warning: symbol
> 'GetRxPacketShiftBytes819xUsb' was not declared. Should it be static?
> 
> Signed-off-by: A Raghavendra Rao <arrao@cdac.in>
> ---
>  drivers/staging/rtl8192u/r8192U_core.c |   16 +++++++++++-----
>  1 file changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
> index 7640386..6ad767a 100644
> --- a/drivers/staging/rtl8192u/r8192U_core.c
> +++ b/drivers/staging/rtl8192u/r8192U_core.c
> @@ -667,12 +667,14 @@ static void tx_timeout(struct net_device *dev)
>  
>  
>  /* this is only for debug */
> -void dump_eprom(struct net_device *dev)
> +#ifdef DEBUG_EPROM

You can't define this, so just delete the whole thing.

Wait, didn't someone already do this?  Yes, someone just sent me this
same thing on the 1st, it's in my queue to apply after 3.17-rc1 is out.

Sorry, I can't take this.

greg k-h

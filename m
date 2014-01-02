Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603AbaABMQk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 07:16:40 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:45698 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbaABMQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 07:16:37 -0500
Date: Thu, 2 Jan 2014 15:16:26 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Chase Southwood <chase.southwood@yahoo.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, abbotti@mev.co.uk
Subject: Re: [PATCH] Staging: comedi: replace printk() calls with dev_dbg()
 in pcmmio.c
Message-ID: <20140102121626.GB28413@mwanda>
References: <1388222032-3691-1-git-send-email-chase.southwood@yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1388222032-3691-1-git-send-email-chase.southwood@yahoo.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 28, 2013 at 03:13:52AM -0600, Chase Southwood wrote:
> From: Chase Southwood <chase.southwood@yahoo.com>

We get this from your email.  It's not needed unless you are forwarding
a patch from someone else.

> 
> This is a patch for pcmmio.c that changes several printk() calls to dev_dbg() or dev_err() to fix checkpatch.pl warnings.  Patched from 3.13-rc5.

Line wrap the description at 72 characters.

Don't put "Patched from 3.13-rc5." in the patch description because we
don't want it to be a part of the permanent change description.  Also
you should be doing these against linux-next anyway.

> 
> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
> ---
>  drivers/staging/comedi/drivers/pcmmio.c | 23 +++++++++++++----------
>  1 file changed, 13 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/staging/comedi/drivers/pcmmio.c b/drivers/staging/comedi/drivers/pcmmio.c
> index 14cee3a..8a567c9 100644
> --- a/drivers/staging/comedi/drivers/pcmmio.c
> +++ b/drivers/staging/comedi/drivers/pcmmio.c
> @@ -252,7 +252,8 @@ static int pcmmio_dio_insn_bits(struct comedi_device *dev,
>  
>  #ifdef DAMMIT_ITS_BROKEN
>  	/* DEBUG */
> -	printk(KERN_DEBUG "write mask: %08x  data: %08x\n", data[0], data[1]);
> +	dev_dbg(dev->class_dev, "write mask: %08x  data: %08x\n",
> +			data[0], data[1]);

Just delete everything to do with DAMMIT_ITS_BROKEN.

regards,
dan carpenter


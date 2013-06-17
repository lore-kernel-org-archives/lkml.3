Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615Ab3FQP34 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 11:29:56 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:49534 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab3FQP3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 11:29:55 -0400
Date: Mon, 17 Jun 2013 18:28:23 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Lorenz Haspel <lorenz@badgers.com>
Cc: devel@linuxdriverproject.org, gregkh@linuxfoundation.org,
        puff65537@bansheeslibrary.com, viro@zeniv.linux.org.uk,
        michael.banken@mathe.stud.uni-erlangen.de, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        linux-kernel@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH 4/5] silicom: checkpatch: trailing statements
Message-ID: <20130617152823.GF5008@mwanda>
References: <1371478817-28357-1-git-send-email-lorenz@badgers.com>
 <1371478817-28357-4-git-send-email-lorenz@badgers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371478817-28357-4-git-send-email-lorenz@badgers.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 04:20:16PM +0200, Lorenz Haspel wrote:
> fixed checkpatch error:
> trailing statements that should be on next line
> 
> Signed-off-by: Michael Banken <michael.banken@mathe.stud.uni-erlangen.de>
> Signed-off-by: Lorenz Haspel <lorenz@badgers.com>
> ---
>  drivers/staging/silicom/bpctl_mod.c |   14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/silicom/bpctl_mod.c b/drivers/staging/silicom/bpctl_mod.c
> index 78570dd..85aa900 100644
> --- a/drivers/staging/silicom/bpctl_mod.c
> +++ b/drivers/staging/silicom/bpctl_mod.c
> @@ -165,7 +165,9 @@ static int bp_device_event(struct notifier_block *unused,
>  			memcpy(&cbuf, drvinfo.bus_info, 32);
>  			buf = &cbuf[0];
>  
> -			while (*buf++ != ':') ;
> +			while (*buf != ':')
> +				buf++;
> +			buf++;


No.  This is more complicated than the original.  While loops like
this are idiomatic in C.  The way to fix this is just to do:

			while (*buf++ != ':')
				;

Same for the rest, just move the semi-colon down in every case.

regards,
dan carpenter


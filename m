Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350AbaDGOCT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 10:02:19 -0400
Received: from mail1.bemta5.messagelabs.com ([195.245.231.151]:52106 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755208AbaDGOCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 10:02:16 -0400
X-Env-Sender: Johannes.Thumshirn@men.de
X-Msg-Ref: server-8.tower-180.messagelabs.com!1396879332!24232028!1
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.11.1; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Mon, 07 Apr 2014 16:02:12 +0200
Date: Mon, 7 Apr 2014 16:02:06 +0200
From: Johannes Thumshirn <johannes.thumshirn@men.de>
To: Christoph Jaeger <christophjaeger@linux.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <johannes.thumshirn@men.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers: mcb: fix memory leak in chameleon_parse_cells()
 error path
Message-ID: <20140407140206.GA23383@jtlinux>
References: <1396638298-3173-1-git-send-email-christophjaeger@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1396638298-3173-1-git-send-email-christophjaeger@linux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [192.1.1.31]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2014 at 09:04:58PM +0200, Christoph Jaeger wrote:
> chameleon_parse_cells() bails out if chameleon descriptor type is
> invalid but does not free the storage 'header' points to.
>
> Signed-off-by: Christoph Jaeger <christophjaeger@linux.com>
> ---
>  drivers/mcb/mcb-parse.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/mcb/mcb-parse.c b/drivers/mcb/mcb-parse.c
> index d1278b5..0049269 100644
> --- a/drivers/mcb/mcb-parse.c
> +++ b/drivers/mcb/mcb-parse.c
> @@ -141,6 +141,7 @@ int chameleon_parse_cells(struct mcb_bus *bus, phys_addr_t mapbase,
>  		default:
>  			pr_err("Invalid chameleon descriptor type 0x%x\n",
>  				dtype);
> +			kfree(header);
>  			return -EINVAL;
>  		}
>  		num_cells++;
> --
> 1.9.0
>

*Doh*

Thanks for the patch.

@Greg, how should be the process here? Should I collect MCB related patches
somewhere and forward them to you, or do you pick them up yourself?

Thanks,
	Johannes

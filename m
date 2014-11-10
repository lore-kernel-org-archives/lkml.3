Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950AbaKJEwk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 23:52:40 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:40433 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751184AbaKJEwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 23:52:38 -0500
X-Sasl-enc: OLlqdlE3PnvYyUtfrWmq4NTGHUwlgDxYyP0Q1okG4Xdf 1415595156
Date: Mon, 10 Nov 2014 13:39:40 +0900
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Lee Jones <lee.jones@linaro.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pankaj Dubey <pankaj.dubey@samsung.com>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: Re: linux-next: manual merge of the driver-core tree with the mfd
 tree
Message-ID: <20141110043940.GC25797@kroah.com>
References: <20141110152426.7f1f3da8@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141110152426.7f1f3da8@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 03:24:26PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the driver-core tree got a conflict in
> drivers/mfd/syscon.c between commit d4ad08b424c1 ("mfd: syscon:
> Decouple syscon interface from platform devices") from the mfd tree and
> commit 78a835416ad6 ("mfd: drop owner assignment from
> platform_drivers") from the driver-core tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc drivers/mfd/syscon.c
> index 72373b113885,e85c052b302c..000000000000
> --- a/drivers/mfd/syscon.c
> +++ b/drivers/mfd/syscon.c
> @@@ -219,7 -166,7 +219,6 @@@ static const struct platform_device_id 
>   static struct platform_driver syscon_driver = {
>   	.driver = {
>   		.name = "syscon",
> - 		.owner = THIS_MODULE,
>  -		.of_match_table = of_syscon_match,
>   	},
>   	.probe		= syscon_probe,
>   	.id_table	= syscon_ids,


Looks good, thanks.

greg k-h

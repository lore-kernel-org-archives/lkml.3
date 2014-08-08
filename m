Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870AbaHHQ1A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 12:27:00 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:32823 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646AbaHHQ06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 12:26:58 -0400
Date: Fri, 8 Aug 2014 09:26:54 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Kiran Padwal <kiran.padwal@smartplayin.com>
Cc: support.opensource@diasemi.com, anthony.olech.opensource@diasemi.com,
        david.chen@diasemi.com, kiran.padwal21@gmail.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Input: da9055_onkey: Remove unnecessary OOM meassage
Message-ID: <20140808162654.GF26820@core.coreip.homeip.net>
References: <1407482097-17624-1-git-send-email-kiran.padwal@smartplayin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407482097-17624-1-git-send-email-kiran.padwal@smartplayin.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2014 at 12:44:57PM +0530, Kiran Padwal wrote:
> There is no need to print out-of-memory errors since this is already
> done by the memory management subsystem which even calls dump_stack().

This is implementation detail as far as I am concerned. We might switch
dumping stack off down the road.

Thanks.

> 
> Signed-off-by: Kiran Padwal <kiran.padwal@smartplayin.com>
> ---
>  drivers/input/misc/da9055_onkey.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/input/misc/da9055_onkey.c b/drivers/input/misc/da9055_onkey.c
> index 4765799..ed6eaa9 100644
> --- a/drivers/input/misc/da9055_onkey.c
> +++ b/drivers/input/misc/da9055_onkey.c
> @@ -87,10 +87,8 @@ static int da9055_onkey_probe(struct platform_device *pdev)
>  	}
>  
>  	onkey = devm_kzalloc(&pdev->dev, sizeof(*onkey), GFP_KERNEL);
> -	if (!onkey) {
> -		dev_err(&pdev->dev, "Failed to allocate memory\n");
> +	if (!onkey)
>  		return -ENOMEM;
> -	}
>  
>  	input_dev = input_allocate_device();
>  	if (!input_dev) {
> -- 
> 1.7.9.5
> 

-- 
Dmitry

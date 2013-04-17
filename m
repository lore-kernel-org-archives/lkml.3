Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936238Ab3DQCCN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 22:02:13 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:63070 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936095Ab3DQCCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 22:02:12 -0400
Date: Tue, 16 Apr 2013 18:58:09 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Andrei Epure <epure.andrei@gmail.com>
Cc: dwmw2@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] power: kmemdup instead of kzalloc + memcpy
Message-ID: <20130417015809.GD18418@lizard.mcd26095.sjc.wayport.net>
References: <1364420901-10438-1-git-send-email-epure.andrei@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1364420901-10438-1-git-send-email-epure.andrei@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 11:48:21PM +0200, Andrei Epure wrote:
> Patch found using coccinelle.
> 
> Signed-off-by: Andrei Epure <epure.andrei@gmail.com>
> ---

Applied, thanks!

>  drivers/power/charger-manager.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
> index 8acc3f8..fefc39f 100644
> --- a/drivers/power/charger-manager.c
> +++ b/drivers/power/charger-manager.c
> @@ -1485,13 +1485,12 @@ static int charger_manager_probe(struct platform_device *pdev)
>  
>  	/* Basic Values. Unspecified are Null or 0 */
>  	cm->dev = &pdev->dev;
> -	cm->desc = kzalloc(sizeof(struct charger_desc), GFP_KERNEL);
> +	cm->desc = kmemdup(desc, sizeof(struct charger_desc), GFP_KERNEL);
>  	if (!cm->desc) {
>  		dev_err(&pdev->dev, "Cannot allocate memory.\n");
>  		ret = -ENOMEM;
>  		goto err_alloc_desc;
>  	}
> -	memcpy(cm->desc, desc, sizeof(struct charger_desc));
>  	cm->last_temp_mC = INT_MIN; /* denotes "unmeasured, yet" */
>  
>  	/*
> -- 
> 1.7.9.5

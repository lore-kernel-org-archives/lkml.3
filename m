Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285Ab3ITRBu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 13:01:50 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:57649 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798Ab3ITRBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 13:01:47 -0400
Date: Fri, 20 Sep 2013 10:01:35 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Manish Badarkhe <badarkhe.manish@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        josh.wu@atmel.com
Subject: Re: [PATCH] Input: atmel_tscadcc - update to devm_* API
Message-ID: <20130920170135.GB6300@core.coreip.homeip.net>
References: <1379343178-6468-1-git-send-email-badarkhe.manish@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379343178-6468-1-git-send-email-badarkhe.manish@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Manish,

On Mon, Sep 16, 2013 at 08:22:58PM +0530, Manish Badarkhe wrote:
>  static int atmel_tsadcc_remove(struct platform_device *pdev)
>  {
>  	struct atmel_tsadcc *ts_dev = platform_get_drvdata(pdev);
> -	struct resource *res;
> -
> -	free_irq(ts_dev->irq, ts_dev);
>  
>  	input_unregister_device(ts_dev->input);
>  
> -	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	iounmap(tsc_base);
> -	release_mem_region(res->start, resource_size(res));
> -
>  	clk_disable(ts_dev->clk);
> -	clk_put(ts_dev->clk);
> -
> -	kfree(ts_dev);
>  
>  	return 0;
>  }


By doing this conversion we disable the clock too early. I need to
resurrect my patches to add devm_clk_enable and then we can revisit this
patch.

Thanks.

-- 
Dmitry

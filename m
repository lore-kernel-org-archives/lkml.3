Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804AbaEUPcY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 11:32:24 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:56635 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321AbaEUPcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 11:32:21 -0400
Date: Wed, 21 May 2014 08:32:17 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Himangi Saraogi <himangi774@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        julia.lawall@lip6.fr
Subject: Re: [PATCH] touchscreen: Introduce the use of the managed version of
 kzalloc
Message-ID: <20140521153217.GA28195@core.coreip.homeip.net>
References: <20140521151405.GA8526@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140521151405.GA8526@himangi-Dell>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Himangi,

On Wed, May 21, 2014 at 08:44:05PM +0530, Himangi Saraogi wrote:
> -	input_dev = input_allocate_device();
> +	input_dev = devm_input_allocate_device(&pdev->dev);

...

> @@ -365,7 +359,6 @@ static int da9034_touch_remove(struct platform_device *pdev)
>  	struct da9034_touch *touch = platform_get_drvdata(pdev);
>  
>  	input_unregister_device(touch->input_dev);

When using managed input devices calling input_unregister_device() is
unnecessary. Whole da9034_touch_remove() can be removed. I fixed it up
locally and applied your patch.

Thanks!

> -	kfree(touch);
>  
>  	return 0;
>  }
> -- 
> 1.9.1
> 

-- 
Dmitry

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932678Ab3GMNH0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 09:07:26 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:41955 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755625Ab3GMNHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 09:07:24 -0400
Message-ID: <1373720843.1906.4.camel@joe-AO722>
Subject: Re: [PATCH 5/5] media: davinci: vpbe: Replace printk with dev_*
From: Joe Perches <joe@perches.com>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Sat, 13 Jul 2013 06:07:23 -0700
In-Reply-To: <1373705431-11500-6-git-send-email-prabhakar.csengg@gmail.com>
References: <1373705431-11500-1-git-send-email-prabhakar.csengg@gmail.com>
	 <1373705431-11500-6-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-07-13 at 14:20 +0530, Prabhakar Lad wrote:
> Use the dev_* message logging API instead of raw printk.
[]
> diff --git a/drivers/media/platform/davinci/vpbe.c b/drivers/media/platform/davinci/vpbe.c
[]
> @@ -735,7 +735,7 @@ static int vpbe_initialize(struct device *dev, struct vpbe_device *vpbe_dev)
>  
>  	mutex_unlock(&vpbe_dev->lock);
>  
> -	printk(KERN_NOTICE "Setting default output to %s\n", def_output);
> +	dev_info(dev, "Setting default output to %s\n", def_output);

You are changing logging levels too.
You should mention that in the changelog.

> @@ -743,7 +743,7 @@ static int vpbe_initialize(struct device *dev, struct vpbe_device *vpbe_dev)
>  		return ret;
>  	}
>  
> -	printk(KERN_NOTICE "Setting default mode to %s\n", def_mode);
> +	dev_info(dev, "Setting default mode to %s\n", def_mode);
>  	ret = vpbe_set_default_mode(vpbe_dev);
>  	if (ret) {
>  		v4l2_err(&vpbe_dev->v4l2_dev, "Failed to set default mode %s",

Maybe these should be v4l2_notice() which could
be added to include/media/v4l2-common.h



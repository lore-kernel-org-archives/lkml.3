Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644AbbA2BJP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:09:15 -0500
Received: from lists.s-osg.org ([54.187.51.154]:41337 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752519AbbA2BJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:09:11 -0500
Message-ID: <54C9760C.3040402@osg.samsung.com>
Date: Wed, 28 Jan 2015 16:51:40 -0700
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: m.chehab@samsung.com, hans.verkuil@cisco.com, prabhakar.csengg@gmail.com,
        laurent.pinchart@ideasonboard.com
CC: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH] media: fix au0828_analog_register() to not free
 au0828_dev
References: <1419132288-4529-1-git-send-email-shuahkh@osg.samsung.com>
In-Reply-To: <1419132288-4529-1-git-send-email-shuahkh@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2014 08:24 PM, Shuah Khan wrote:
> au0828_analog_register() frees au0828_dev when it fails to
> locate isoc endpoint. au0828_usb_probe() continues with dvb
> and rc probe and registration assuming dev is still valid.
> When au0828_analog_register() fails to locate isoc endpoint,
> it should return without free'ing au0828_dev. Otherwise, the
> probe will fail as dev is null when au0828_dvb_register() is
> called.
> 
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> ---
> 
> Resending as the first one had malformed changelog
> 
>  drivers/media/usb/au0828/au0828-video.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
> index 3bdf132..94b65b8 100644
> --- a/drivers/media/usb/au0828/au0828-video.c
> +++ b/drivers/media/usb/au0828/au0828-video.c
> @@ -1713,7 +1713,6 @@ int au0828_analog_register(struct au0828_dev *dev,
>  	}
>  	if (!(dev->isoc_in_endpointaddr)) {
>  		pr_info("Could not locate isoc endpoint\n");
> -		kfree(dev);
>  		return -ENODEV;
>  	}
>  
> 

Just checking if this patch was lost in holiday fog :)

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978

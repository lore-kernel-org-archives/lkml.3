Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304Ab3I0SUA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 14:20:00 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:43648 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031Ab3I0ST5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 14:19:57 -0400
Message-ID: <5245CC50.9050906@cogentembedded.com>
Date: Fri, 27 Sep 2013 22:20:00 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Robert Baldyga <r.baldyga@samsung.com>
CC: balbi@ti.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, mina86@mina86.com,
        b.zolnierkie@samsung.com, m.szyprowski@samsung.com,
        andrzej.p@samsung.com
Subject: Re: [PATCH] USB: gadget: f_fs: fix error handling
References: <1380277734-17590-1-git-send-email-r.baldyga@samsung.com>
In-Reply-To: <1380277734-17590-1-git-send-email-r.baldyga@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 09/27/2013 02:28 PM, Robert Baldyga wrote:

> This patch add missing error check in ffs_func_bind() function, after
> ffs_do_descs() funcion call for hs descriptors. Without this check it's

    s/funcion/function/.
    Perhaps it's worth expanding "hs" to "high speed" for clarity?

> possible that the module will try dereference incorrect pointer.

> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> ---
>   drivers/usb/gadget/f_fs.c |    3 +++
>   1 file changed, 3 insertions(+)

> diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
> index 1a66c5b..fe7d532 100644
> --- a/drivers/usb/gadget/f_fs.c
> +++ b/drivers/usb/gadget/f_fs.c
> @@ -2264,7 +2264,10 @@ static int ffs_func_bind(struct usb_configuration *c,
>   				   data->raw_descs + ret,
>   				   (sizeof data->raw_descs) - ret,
>   				   __ffs_func_bind_do_descs, func);
> +		if (unlikely(ret < 0))
> +			goto error;
>   	}
> +	
>

    Why add second empty line here?

>   	/*
>   	 * Now handle interface numbers allocation and interface and

WBR, Sergei


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931AbaJGJZZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 05:25:25 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:47972 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753704AbaJGJZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 05:25:18 -0400
Date: Tue, 7 Oct 2014 10:25:12 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Johan Hovold <johan@kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 6/6] mfd: core: fix platform-device id generation
Message-ID: <20141007092512.GV25331@lee--X1>
References: <1411728933-13351-1-git-send-email-johan@kernel.org>
 <1411728933-13351-7-git-send-email-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1411728933-13351-7-git-send-email-johan@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Sep 2014, Johan Hovold wrote:

> Make sure to always honour multi-function devices registered with
> PLATFORM_DEVID_NONE (-1) or PLATFORM_DEVID_AUTO (-2) as id base. In this
> case it does not make sense to append the cell id to the mfd-id base and
> potentially change the requested behaviour.
> 
> Specifically this will allow multi-function devices to be registered
> with PLATFORM_DEVID_AUTO while still having non-zero cell ids.
> 
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
>  drivers/mfd/mfd-core.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)

Applied for v3.19.

> diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
> index 892d343193ad..79f25633d7db 100644
> --- a/drivers/mfd/mfd-core.c
> +++ b/drivers/mfd/mfd-core.c
> @@ -87,9 +87,15 @@ static int mfd_add_device(struct device *parent, int id,
>  	struct platform_device *pdev;
>  	struct device_node *np = NULL;
>  	int ret = -ENOMEM;
> +	int platform_id;
>  	int r;
>  
> -	pdev = platform_device_alloc(cell->name, id + cell->id);
> +	if (id < 0)
> +		platform_id = id;
> +	else
> +		platform_id = id + cell->id;
> +
> +	pdev = platform_device_alloc(cell->name, platform_id);
>  	if (!pdev)
>  		goto fail_alloc;
>  

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

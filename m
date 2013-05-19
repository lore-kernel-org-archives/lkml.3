Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab3ESOWF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 10:22:05 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:40945 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517Ab3ESOWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 10:22:03 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pwm: renesas-tpu: Add missing pwmchip_remove() call in tpu_remove()
Date: Sun, 19 May 2013 16:22:21 +0200
Message-ID: <3914560.biJ8gxkuTL@avalon>
User-Agent: KMail/4.10.2 (Linux/3.8.13-gentoo; KDE/4.10.2; x86_64; ; )
In-Reply-To: <1368942331.3455.2.camel@phoenix>
References: <1368942331.3455.2.camel@phoenix>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

Thank you for the patch.

On Sunday 19 May 2013 13:45:31 Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/pwm/pwm-renesas-tpu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/pwm/pwm-renesas-tpu.c b/drivers/pwm/pwm-renesas-tpu.c
> index 8e6d8d7..351addd 100644
> --- a/drivers/pwm/pwm-renesas-tpu.c
> +++ b/drivers/pwm/pwm-renesas-tpu.c
> @@ -444,7 +444,7 @@ static int tpu_remove(struct platform_device *pdev)
> 
>  	pm_runtime_disable(&pdev->dev);
> 
> -	return 0;
> +	return pwmchip_remove(&tpu->chip);

Could you please move that line at the beginning of the function ? There would 
be a race condition otherwise, as the user could reenable PWM between the 
tpu_pwm_timer_stop() calls and the pwmchip_remove() call.

Apart from that, the patch looks good.

>  }
> 
>  static struct platform_driver tpu_driver = {

-- 
Regards,

Laurent Pinchart


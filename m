Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881Ab3ETNqp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 09:46:45 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:47884 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756519Ab3ETNqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 09:46:40 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Axel Lin <axel.lin@ingics.com>, Simon Horman <horms+renesas@verge.net.au>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH v2] pwm: renesas-tpu: Add missing pwmchip_remove() call in tpu_remove()
Date: Mon, 20 May 2013 15:46:59 +0200
Message-ID: <1454213.B1kNpQ6JtX@avalon>
User-Agent: KMail/4.10.2 (Linux/3.8.13-gentoo; KDE/4.10.2; x86_64; ; )
In-Reply-To: <1369057541.11578.1.camel@phoenix>
References: <1369057541.11578.1.camel@phoenix>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

Thank you for the patch.

On Monday 20 May 2013 21:45:41 Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/pwm/pwm-renesas-tpu.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/pwm/pwm-renesas-tpu.c b/drivers/pwm/pwm-renesas-tpu.c
> index 8e6d8d7..319a6fe 100644
> --- a/drivers/pwm/pwm-renesas-tpu.c
> +++ b/drivers/pwm/pwm-renesas-tpu.c
> @@ -432,6 +432,11 @@ static int tpu_remove(struct platform_device *pdev)
>  {
>  	struct tpu_device *tpu = platform_get_drvdata(pdev);
>  	unsigned int i;
> +	int ret;
> +
> +	ret = pwmchip_remove(&tpu->chip);
> +	if (ret)
> +		return ret;
> 
>  	for (i = 0; i < ARRAY_SIZE(tpu->pwms); ++i) {
>  		struct tpu_pwm_device *pwm = &tpu->pwms[i];
-- 
Regards,

Laurent Pinchart

